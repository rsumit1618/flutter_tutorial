fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android test

```sh
[bundle exec] fastlane android test
```

Run all tests

### android clean

```sh
[bundle exec] fastlane android clean
```

Clean project

### android build_apk

```sh
[bundle exec] fastlane android build_apk
```

Build release APK

### android build_aab

```sh
[bundle exec] fastlane android build_aab
```

Build release App Bundle

### android build

```sh
[bundle exec] fastlane android build
```

Build both APK and AAB

### android ci

```sh
[bundle exec] fastlane android ci
```

Full CI pipeline

### android deploy_playstore

```sh
[bundle exec] fastlane android deploy_playstore
```

Deploy to Play Store Internal Testing

### android usage

```sh
[bundle exec] fastlane android usage
```

Show all available lanes

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
