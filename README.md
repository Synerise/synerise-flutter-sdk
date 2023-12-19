# Synerise Flutter SDK (synerise-flutter-sdk) (0.7.4)

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
* Development environment configured - [Flutter documentation](https://docs.flutter.dev)

## Android
* Minimum Android SDK version - 21
* Supported targetSDKVersion - 33

### iOS
* Xcode 15 and iOS SDK 17
* iOS 9.0+ minimum deployment target
* Valid architectures: arm64 devices and arm64, x86_64 simulators

## Installation

### With flutter

```
 $ flutter pub add synerise_flutter_sdk
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```
dependencies:
  synerise_flutter_sdk: ^0.7.4
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

in MainActivity add:
```
public class MainActivity extends FlutterActivity {
@Override    
public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);        
    SyneriseMethodChannel.configureChannel(flutterEngine);    
}}
```

## iOS configuration

In iOS portion of your application (/ios) you will need to run `pod update`.

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
- Open project folder in selected IDE
- `flutter pub get` in the terminal (dependencies pull)
- Select the device/emulator in your IDE (for ios part it is required to run `pod update` in example/ios directory)
- Fill the file `api_key.txt` located in `example/lib` with your profile api key
- Make sure the firebase related files `example/ios/Runner/GoogleService-Info.plist` and `example/android/app/google-services.json` are filled with your firebase project configuration data
- Run the example app via selected sdk or execute `cd example` and `flutter run` in the terminal

## Author
Synerise, developer@synerise.com. If you need support please feel free to contact us.
