---
name: android-cli
description: "Use when using Android SDK command-line tools from Codex or a terminal: sdkmanager package setup, avdmanager AVD creation, emulator launch, adb install/run/test, screenshots, UI tree dumps, logcat, or diagnosing Android CLI PATH and SDK issues."
---

# Android CLI

Use Android SDK command-line tools without relying on Android Studio UI.

## Official Android CLI

Google's Android CLI helps build Android apps using the agents and developer environments of your choice.

Install the official Android CLI for macOS arm64:

```bash
curl -fsSL https://dl.google.com/android/cli/latest/darwin_arm64/install.sh | bash
```

Official pages:

- Source page: https://developer.android.com/tools/agents
- Documentation: https://developer.android.com/tools/agents/android-cli

## First Step

Run the bundled doctor before changing SDK packages or launching emulators:

```bash
bash ~/.codex/skills/android-cli/scripts/android_cli_doctor.sh
```

Use `--require-device` when the task needs an attached device/emulator.

## Tool Resolution

- Resolve SDK root from `ANDROID_HOME`, then `ANDROID_SDK_ROOT`, then common local SDK paths.
- Prefer explicit SDK paths over `PATH` when ambiguity matters.
- Prefer `$ANDROID_HOME/emulator/emulator`; old `$ANDROID_HOME/tools/emulator` can be stale or broken.
- Use `adb -s <serial>` whenever more than one device or emulator can be attached.

## SDK Packages

```bash
sdkmanager --list_installed
sdkmanager --list
sdkmanager --install "platform-tools" "platforms;android-36"
sdkmanager --install "system-images;android-34;google_apis_playstore;arm64-v8a"
sdkmanager --licenses
```

For CI or repeatable scripts, install exact package IDs instead of relying on "latest".

## AVD Management

```bash
avdmanager list avd
avdmanager list device
avdmanager create avd -n Pixel_8_API_34 -k "system-images;android-34;google_apis_playstore;arm64-v8a"
avdmanager delete avd -n Pixel_8_API_34
```

Use `-f` only when intentionally overwriting an existing AVD.

## Emulator Lifecycle

```bash
"$ANDROID_HOME/emulator/emulator" -list-avds
"$ANDROID_HOME/emulator/emulator" @Pixel_8_API_34 -no-snapshot-load
adb wait-for-device
adb devices
```

Close the emulator window or stop the process to shut it down. Use `-wipe-data` only when clearing app/device state is intended.

## adb App QA

```bash
adb devices
adb -s <serial> install -r path/to/app.apk
adb -s <serial> shell cmd package resolve-activity --brief <package>
adb -s <serial> shell am start -n <package>/<activity>
adb -s <serial> shell am force-stop <package>
```

Capture state for debugging:

```bash
adb -s <serial> exec-out screencap -p > /tmp/android-screen.png
adb -s <serial> exec-out uiautomator dump /dev/tty > /tmp/android-ui.xml
adb -s <serial> logcat -c
adb -s <serial> logcat -d > /tmp/android-logcat.txt
adb -s <serial> logcat -b crash -d > /tmp/android-crash.txt
```

For UI taps, derive coordinates from UI-tree bounds, not screenshots.

## Official References

- Android SDK Manager: https://developer.android.com/tools/sdkmanager
- AVD Manager: https://developer.android.com/tools/avdmanager
- Emulator command line: https://developer.android.com/studio/run/emulator-commandline
- Android Debug Bridge: https://developer.android.com/tools/adb
