# Synerise Flutter SDK (synerise-flutter-sdk) (0.4.1)

[![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)](https://github.com/synerise/ios-sdk)
[![Platform](https://img.shields.io/badge/platform-Android-orange.svg)](https://github.com/synerise/android-sdk)
[![Documentation](https://img.shields.io/badge/docs-latest-brightgreen.svg?style=flat-square)](https://help.synerise.com/developers/mobile-sdk/)

---

## Documentation

Most up-to-date documentation is available at [Synerise Help Center](https://help.synerise.com/developers/mobile-sdk/)


## Requirements

* Flutter configured - [Getting Started](https://docs.flutter.dev)

## Android

* Recommended environment:

  - Minimum Android SDK version - 21
  - Supported targetSDKVersion - 30

## iOS

* Recommended environment:

  - Xcode 14 
  - iOS SDK 16

* Target deployment: iOS 9.0+

---

## Installation

### With flutter

```
 $ flutter pub add synerise_flutter_sdk
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```
dependencies:
  synerise_flutter_sdk: ^0.4.1
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

---

### Importing Synerise SDK

```
import 'package:synerise_flutter_sdk/synerise.dart';
```


## Android gradle & configuration

Add to the `android/build.gradle`:


```
repositories {
    mavenLocal()
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

In iOS portion of your application (/ios) you will need to run
`pod update`

## Initialization

### Basic initialization

```
Synerise.initializer()
  .withClientApiKey("YOUR_PROFILE_API_KEY")  // 1
  .withDebugModeEnabled(false)  // 2
  .init(); 
```

## Running example app

-  Open project folder in selected IDE
- `flutter pub get` in the terminal (dependencies pull)
- select the device/emulator in your IDE (for ios part it is required to run `pod update` in example/ios directory)
- `cd example` and  `flutter run`

