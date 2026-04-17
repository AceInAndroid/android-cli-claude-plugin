# Android CLI Claude Code Plugin

Android CLI is a Claude Code plugin for Android SDK command-line work. It gives Claude a focused skill for `sdkmanager`, `avdmanager`, `emulator`, and `adb` workflows, plus a diagnostic command that checks the local Android CLI setup.

## What It Includes

- `android-cli` skill for Android SDK command-line workflows.
- `android-cli-doctor` executable added to Claude Code's Bash `PATH` while the plugin is loaded.
- Diagnostics for SDK root discovery, tool resolution, emulator path problems, AVDs, and attached adb devices.
- Guidance for APK install/run, screenshots, UI tree dumps, and logcat capture.

## Requirements

- Claude Code 2.x with plugin support.
- Android SDK command-line tools installed.
- `ANDROID_HOME` or `ANDROID_SDK_ROOT` set, or an SDK installed at one of the common local paths.

The doctor prefers this emulator binary:

```bash
$ANDROID_HOME/emulator/emulator
```

This avoids stale `$ANDROID_HOME/tools/emulator` installations that can fail with Qt library errors.

## Local Usage

Clone the repository and load the plugin for a Claude Code session:

```bash
git clone git@github.com:AceInAndroid/android-cli-claude-plugin.git
claude --plugin-dir ./android-cli-claude-plugin
```

The skill is available in Claude Code as:

```text
/android-cli:android-cli
```

## Diagnostic Command

With the plugin loaded, run:

```bash
android-cli-doctor
```

Require an attached device or emulator when the task depends on one:

```bash
android-cli-doctor --require-device
```

## Plugin Structure

```text
android-cli-claude-plugin/
├── .claude-plugin/
│   └── plugin.json
├── bin/
│   └── android-cli-doctor
├── skills/
│   └── android-cli/
│       ├── SKILL.md
│       └── scripts/
│           └── android_cli_doctor.sh
├── README.md
└── RELEASE.md
```

## Validate

Run Claude Code's plugin validator:

```bash
claude plugin validate .
```

Run script checks:

```bash
bash -n bin/android-cli-doctor
bash -n skills/android-cli/scripts/android_cli_doctor.sh
android-cli-doctor
```

## Notes

- Use `adb -s <serial>` when multiple devices or emulators may be connected.
- Use `-wipe-data` only when clearing emulator state is intended.
- Derive tap coordinates from UI-tree bounds rather than screenshots.
