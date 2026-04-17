# Release Notes

## v1.1.0 - 2026-04-17

Adds a separate Codex-compatible skill distribution while preserving the existing Claude Code plugin layout.

### Added

- Codex skill source under `codex/android-cli/`.
- Codex release artifact: `android-cli-codex-skill-v1.1.0.skill`.
- Claude Code plugin release artifact: `android-cli-claude-plugin-v1.1.0.zip`.
- README instructions for installing and using both Claude Code and Codex variants.

### Verified

- `claude plugin validate .`
- Codex skill packaged with `package_skill.py`.
- `bash -n bin/android-cli-doctor`
- `bash -n skills/android-cli/scripts/android_cli_doctor.sh`
- `bash -n codex/android-cli/scripts/android_cli_doctor.sh`
- Doctor script execution from extracted release artifacts.

## v1.0.0 - 2026-04-17

Initial release of the Android CLI Claude Code plugin.

### Added

- Claude Code plugin manifest at `.claude-plugin/plugin.json`.
- `android-cli` skill for Android SDK command-line workflows:
  - `sdkmanager` package listing, install, update, and license handling.
  - `avdmanager` AVD listing, creation, and deletion.
  - Emulator lifecycle commands using the preferred SDK emulator path.
  - `adb` device targeting, APK install/run, screenshot, UI tree dump, and logcat workflows.
- `android-cli-doctor` command in `bin/`.
- `android_cli_doctor.sh` diagnostic script for:
  - SDK root discovery.
  - `adb`, `sdkmanager`, `avdmanager`, and `emulator` resolution.
  - stale `tools/emulator` PATH detection.
  - AVD listing.
  - optional adb device enforcement via `--require-device`.

### Verified

- `claude plugin validate .`
- `bash -n bin/android-cli-doctor`
- `bash -n skills/android-cli/scripts/android_cli_doctor.sh`
- `android-cli-doctor`

### Known Behavior

- `android-cli-doctor` exits successfully with a warning when no adb device is attached.
- Use `android-cli-doctor --require-device` when a connected device or running emulator is required.
