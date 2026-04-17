#!/usr/bin/env bash
set -u

require_device=false
if [[ "${1:-}" == "--require-device" ]]; then
  require_device=true
fi

failures=0

note() {
  printf '%s\n' "$*"
}

ok() {
  printf '[OK] %s\n' "$*"
}

warn() {
  printf '[WARN] %s\n' "$*"
}

fail() {
  printf '[FAIL] %s\n' "$*"
  failures=$((failures + 1))
}

first_existing_dir() {
  for candidate in "$@"; do
    if [[ -n "$candidate" && -d "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

resolve_tool() {
  local preferred="$1"
  local fallback="$2"
  if [[ -x "$preferred" ]]; then
    printf '%s\n' "$preferred"
    return 0
  fi
  command -v "$fallback" 2>/dev/null || true
}

sdk_root="$(first_existing_dir "${ANDROID_HOME:-}" "${ANDROID_SDK_ROOT:-}" "$HOME/Library/Android/sdk" "$HOME/Android/Sdk" "$HOME/Android/sdk" || true)"
if [[ -z "$sdk_root" ]]; then
  fail "Android SDK root not found. Set ANDROID_HOME or ANDROID_SDK_ROOT."
  exit 1
fi
ok "SDK root: $sdk_root"

adb_bin="$(resolve_tool "$sdk_root/platform-tools/adb" adb)"
sdkmanager_bin="$(resolve_tool "$sdk_root/cmdline-tools/latest/bin/sdkmanager" sdkmanager)"
avdmanager_bin="$(resolve_tool "$sdk_root/cmdline-tools/latest/bin/avdmanager" avdmanager)"
emulator_bin="$(resolve_tool "$sdk_root/emulator/emulator" emulator)"
path_emulator="$(command -v emulator 2>/dev/null || true)"

for item in \
  "adb:$adb_bin" \
  "sdkmanager:$sdkmanager_bin" \
  "avdmanager:$avdmanager_bin" \
  "emulator:$emulator_bin"; do
  name="${item%%:*}"
  value="${item#*:}"
  if [[ -n "$value" && -x "$value" ]]; then
    ok "$name: $value"
  else
    fail "$name not found or not executable"
  fi
done

if [[ -n "$path_emulator" && "$path_emulator" != "$emulator_bin" ]]; then
  warn "PATH emulator differs from preferred SDK emulator: $path_emulator"
fi

if [[ -n "$adb_bin" && -x "$adb_bin" ]]; then
  "$adb_bin" version | sed -n '1,3p'
fi

if [[ -n "$sdkmanager_bin" && -x "$sdkmanager_bin" ]]; then
  version="$("$sdkmanager_bin" --version 2>/dev/null || true)"
  if [[ -n "$version" ]]; then
    ok "sdkmanager version: $version"
  else
    warn "sdkmanager --version returned no output"
  fi
fi

if [[ -n "$emulator_bin" && -x "$emulator_bin" ]]; then
  "$emulator_bin" -version 2>&1 | sed -n '1,6p'
  avds="$("$emulator_bin" -list-avds 2>/dev/null || true)"
  if [[ -n "$avds" ]]; then
    ok "AVDs:"
    printf '%s\n' "$avds" | sed 's/^/  - /'
  else
    warn "No AVDs reported by emulator -list-avds"
  fi
fi

if [[ -n "$adb_bin" && -x "$adb_bin" ]]; then
  devices="$("$adb_bin" devices | sed '1d' | awk 'NF {print}')"
  if [[ -n "$devices" ]]; then
    ok "adb devices:"
    printf '%s\n' "$devices" | sed 's/^/  - /'
  elif [[ "$require_device" == true ]]; then
    fail "No adb device/emulator attached"
  else
    warn "No adb device/emulator attached"
  fi
fi

if [[ "$failures" -gt 0 ]]; then
  note "Android CLI doctor found $failures failure(s)."
  exit 1
fi

ok "Android CLI doctor passed."
