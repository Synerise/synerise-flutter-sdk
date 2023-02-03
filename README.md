# Synerise Flutter SDK (v0.2.0) - User documentation

[![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)](https://github.com/synerise/ios-sdk)
[![Platform](https://img.shields.io/badge/platform-Android-orange.svg)](https://github.com/synerise/android-sdk)
[![Documentation](https://img.shields.io/badge/docs-latest-brightgreen.svg?style=flat-square)](https://help.synerise.com/)

---

## Experimental alpha version. - !! Not for production release !!
This flutter plugin is an implementation of Synerise SDK.

Path dependency:

via ssh:
```
synerise_flutter_sdk: 
    git:
      url: git@github.com:Synerise/synerise-flutter-sdk.git
``` 

or 

via https:

```
synerise_flutter_sdk: 
    git:
      url: https://github.com/Synerise/synerise-flutter-sdk.git
``` 


*Requirements*:
- Flutter configured on your machine [Getting started](https://docs.flutter.dev)
- Flutter Doctor green output for the selected platform
- Android Studio / VS Code / XCode

----------

## Documentation

Most up-to-date documentation is available at [Synerise Help Center - Mobile SDK](https://help.synerise.com/developers/mobile-sdk).

----------

## Android

For the **Android** platform it uses the [Synerise Android SDK](https://github.com/Synerise/android-sdk).

The development and debugging can be done with Android Studio.

*Requirements*:
-   Access to  [Workspaces](https://help.synerise.com/docs/settings/business-profile/)
-   Created Client (customer)  [API Key](https://help.synerise.com/docs/settings/tool/api)
-   Minimum Android SDK version - 21
-   Supported targetSDKVersion - 30

----------

## iOS

For the **iOS** platform it uses the [Synerise iOS SDK](https://cocoapods.org/pods/SyneriseSDK).

The development and debugging can be done with Xcode.

*Requirements*:
-   Xcode 14 and iOS SDK 16
-   iOS 9.0+ minimum deployment target
-   Valid architectures: arm64 devices and arm64, x86_64 simulators

----------

## Running example app

-  Open project folder in selected IDE
- `flutter pub get` in the terminal (dependencies pull)
- select the device/emulator in your IDE (for ios part it is required to run `pod update` in example/ios directory)
- `cd example` and  `flutter run`

