# Synerise Flutter SDK

# Experimental alpha version. !! Not for production release.
This flutter plugin is an implementation of SyneriseSDK.

Path dependency:

```
synerise_flutter_sdk: 
    git:
      url: git@github.com:Synerise/synerise-flutter-sdk.git
``` 

*Requirements*

- Flutter configured on your machine [Getting started](https://docs.flutter.dev)
- Flutter Doctor green output for the selected platform
- Android Studio / VS Code / XCode

----------

For the **android** platform it uses the [Synerise Android SDK](https://github.com/Synerise/android-sdk) 

The development and debugging can be done with Android Studio

*Requirements*

-   Access to  [Workspaces](https://help.synerise.com/docs/settings/business-profile/)
-   Created Client (customer)  [API Key](https://help.synerise.com/docs/settings/tool/api)
-   Minimum Android SDK version - 21
-   Supported targetSDKVersion - 30


----------

For the **iOS** platform it uses the [Synerise iOS SDK](https://cocoapods.org/pods/SyneriseSDK)


The development and debugging can be done with XCode

*Requirements*


-   Xcode 14 and iOS SDK 16
-   iOS 9.0+ minimum deployment target
-   Valid architectures: arm64 devices and arm64, x86_64 simulators


## Running example app

-  Open project folder in selected IDE
- `flutter pub get` in the terminal (dependencies pull)
- select the device/emulator in your IDE (for ios part it is required to run `pod update` in example/ios directory)
- `cd example` and  `flutter run`

