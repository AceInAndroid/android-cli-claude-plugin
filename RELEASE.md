# Release Notes

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
