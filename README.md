# Synerise Flutter SDK (synerise-flutter-sdk) (3.1.0)

[![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)](https://github.com/synerise/ios-sdk)
[![Platform](https://img.shields.io/badge/platform-Android-orange.svg)](https://github.com/synerise/android-sdk)
[![Languages](https://img.shields.io/badge/language-Dart%20%7C%20Java%20%7C%20Objective--C-orange.svg)](https://github.com/synerise/synerise-flutter-sdk)
[![Synerise](https://img.shields.io/badge/www-synerise-green.svg)](https://synerise.com)
[![Documentation](https://img.shields.io/badge/docs-mobile%20sdk-brightgreen.svg)](https://hub.synerise.com/developers/mobile-sdk/)

---

## About
[Synerise](https://www.synerise.com) SDK plugin for Flutter.

## Documentation
Most up-to-date documentation is available at [Developer Guide - Mobile SDK](https://hub.synerise.com/developers/mobile-sdk).

## Requirements
* Access to workspace
* A Profile API Key
* Flutter configured on your machine - [Getting Started](https://docs.flutter.dev)
* VS Code / Android Studio / Xcode

## Android

For the **Android** platform it uses the [Synerise Android SDK](https://github.com/Synerise/android-sdk).

The development and debugging can be done with Android Studio.

* Recommended environment:
  - Minimum Android SDK version - 24
  - Supported targetSDKVersion - 33

## iOS

For the **iOS** platform it uses the [Synerise iOS SDK](https://github.com/Synerise/synerise-ios-sdk).

The development and debugging can be done with Xcode.

* Recommended environment:
  - Xcode 16
  - iOS SDK 18
* Target deployment:
  * iOS 13.0+ for SDK versions 2.0.0 and higher
  * iOS 9.0+ for SDK versions lower than 2.0.0
* Integration: Swift Package Manager or CocoaPods (Flutter chooses it, see [iOS configuration](#ios-configuration))
  * Swift Package Manager requires Flutter 3.41 or later (enabled by default since Flutter 3.44)

**Bitcode is not supported in SDK version 2.0.0 and higher. Xcode ignores bitcode.**

## Installation

### With flutter

```
 $ flutter pub add synerise_flutter_sdk
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```
dependencies:
  synerise_flutter_sdk: ^3.1.0
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

### Path dependency

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

### Importing Synerise SDK
```
import 'package:synerise_flutter_sdk/synerise.dart';
```

## Android gradle & configuration

Add to the `android/build.gradle`:
```
repositories {
    google()
    mavenCentral()
    maven { url 'https://pkgs.dev.azure.com/Synerise/AndroidSDK/_packaging/prod/maven/v1' }
}

``` 

No changes in `MainActivity` are required. Since version 2.11.1 the plugin configures its method channels itself, on both Android and iOS.

If your `MainActivity` still calls `SyneriseMethodChannel.configureChannel(flutterEngine)`, it keeps working and you may remove it:
```
public class MainActivity extends FlutterActivity {
@Override    
public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);        
    SyneriseMethodChannel.configureChannel(flutterEngine);    
}}
```

## iOS configuration

The plugin supports both Swift Package Manager and CocoaPods. Flutter chooses the integration based on the `enable-swift-package-manager` setting and resolves iOS dependencies on `flutter build` and `flutter run`, so you don't need to run `pod install` manually.

### Swift Package Manager

The plugin brings the native SDK from the [synerise-ios-sdk](https://github.com/Synerise/synerise-ios-sdk) package. **Do not add `pod 'SyneriseSDK'` to `ios/Podfile`** - it duplicates the framework and the build fails with `Multiple commands produce '.../Frameworks/SyneriseSDK.framework'`.

### CocoaPods

If `pod install` fails after a plugin update with `CocoaPods could not find compatible versions for pod "SyneriseSDK"`:
- If extension targets in `ios/Podfile` contain `pod 'SyneriseSDK'`, set their version to the one used by the plugin.
- Otherwise, run `pod update SyneriseSDK` in the `ios` directory.

## Initialization

First of all, you need to initialize Synerise Flutter SDK and provide `Profile API Key`.
  
To get `Profile API Key`, please sign in to your Synerise account and visit [https://app.synerise.com/settings/apikeys](https://app.synerise.com/settings/apikeys).
Then, generate new `API Key` for `Profile` audience.

```
Synerise.initializer()
  .withClientApiKey("YOUR_PROFILE_API_KEY")
  .init(); 
```

## Running example app
- iOS: the example app uses Swift Package Manager and requires Flutter 3.41 or later. Clone the repository into a directory named `synerise_flutter_sdk`, otherwise the iOS build fails with a package identity error ([flutter/flutter#186881](https://github.com/flutter/flutter/issues/186881))
- Open project folder in selected IDE
- `flutter pub get` in the terminal (dependencies pull)
- Select the device/emulator in your IDE
- Fill the file `api_key.txt` located in `example/lib` with your profile api key
- Make sure the firebase related files `example/ios/Runner/GoogleService-Info.plist` and `example/android/app/google-services.json` are filled with your firebase project configuration data
- Run the example app via selected sdk or execute `cd example` and `flutter run` in the terminal

## Changelog
Changelog can be found [here](./CHANGELOG.md).

## Author
Synerise, developer@synerise.com. If you need support please feel free to contact us.
