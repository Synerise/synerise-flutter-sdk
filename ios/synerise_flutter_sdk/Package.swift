// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let syneriseSdkVersion: Version = "6.1.2"

let package = Package(
    name: "synerise_flutter_sdk",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "synerise-flutter-sdk", targets: ["synerise_flutter_sdk"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/Synerise/synerise-ios-sdk", exact: syneriseSdkVersion)
    ],
    targets: [
        .target(
            name: "synerise_flutter_sdk",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "SyneriseSDK", package: "synerise-ios-sdk")
            ],
            cSettings: [
                .headerSearchPath("include/synerise_flutter_sdk"),
                .headerSearchPath("Common"),
                .headerSearchPath("Common/Categories"),
                .headerSearchPath("Main"),
                .headerSearchPath("Modules"),
                .headerSearchPath("Views")
            ]
        )
    ]
)
