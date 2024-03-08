# Changelog
All notable changes to this project will be documented in this file.

## [0.8.3] - 2024-03-08

### Added
- Global Control Group support for in-app messages. From now on, you can use this feature in in-app messaging communication. This lets you take your marketing efforts to the next level and provides a solid foundation for accurate measurement of campaign effectiveness. Read more at https://hub.synerise.com/docs/settings/configuration/global-control-group/.

### Fixed
- [iOS] Issue with non-scrolling in-app messages.

### Changed
- Stability improvements.


## [0.8.2] - 2024-02-02

### Fixed
- [android] Deeplink action when clicking on push notification will directly open in app instead of prompt between app/browser. We set packageName to intent.


## [0.8.1] - 2024-01-15

### Fixed
- [iOS] In-app message did not hide automatically after invoking `SRInapp.openUrl(url)` or `SRInapp.openDeeplink(deeplink)` the action as it should


## [0.8.0] - 2024-01-11

IMPORTANT: 
Due to changes in the handling of actions for URLs and deep links in Synerise campaigns, we strongly recommend comparing your configuration with the SDK documentation. Review the changes from the previous SDK version integrated into your application here: 
https://hub.synerise.com//developers/mobile-sdk/campaigns/action-handling/

### Fixed
- [iOS] Running example by `flutter run` command.

### Added
- New methods for dealing with encrypted notifications: `Synerise.notifications.decryptNotification` and `Synerise.notifications.isNotificationEncrypted`.

### Changed
- Changes in handling actions from campaigns (read important note above).
- Update of native SDK's dependencies.


## [0.7.4] - 2023-12-19

### Fixed
- Resolved the issue of SDK initializing multiple times in a specific scenario and implemented a prevention mechanism.

### Changed
- Example app project files refinements.


## [0.7.3] - 2023-12-05

### Fixed
- [iOS] Potential issues with Simple Authentication requests.
- [iOS] Issue with location of some SDK files in the Documents directory. The old location caused the SDK files to be visible in the shared documents directory if the host application file sharing was enabled.
- [iOS] Potential issue with native notification buttons when Simple Push campaign contained Rich Media (Single Media) or had a custom notification category identifier.

### Changed
- Update of native SDK's dependencies.


## [0.7.2] - 2023-11-13

### Added
- `setRequestValidationSalt` is now optional. Salt is not required for simpleAuthentication, but we recommend using it for improved security (it needs to be enabled in the Synerise portal first).
- `Synerise.settings.inAppMessaging.shouldSendInAppCappingEvent` option in settings to enable or disable sending `inApp.capping` event by the SDK.

### Fixed
- iOS example app project files refinements.

### Changed
- Stability improvements.


## [0.7.1] - 2023-10-26

### Added
- **Notifications Methods**: Introduced new methods for notification payload verification, including `isSyneriseNotification`, `isSyneriseSimplePush`, `isSyneriseBanner`, `isSilentCommand`, and `isSilentSDKCommand`.

### Fixed
- Addressed issues with inApp listeners handling in the Android platform.
- Improved the handling of the `activateAccount` method in the Android portion.
- Enhanced the architecture of the `events` classes in the Dart part.
- Corrected the field name in the `IdentityProvider` class.

### Changed
- Stability improvements.


## [0.7.0] - 2023-08-04

### Added
- New authentication mechanism - **Simple Authentication**. It allows identification of customers without implementing more complicated processes such as RaaS, OAuth, or authenticating by third party services, for example Facebook or Apple. Simple Authentication needs only two methods - `client.simpleAuthentication` to recognize a customer and `client.isSignedInViaSimpleAuthentication` to check if the customer is signed in and uses the Simple Authentication feature. The `client.signOut` method and similar methods are a common way to sign out and clear the user context.
- **Client Methods**: Added several client methods, including `pinCodeMethods` (request and confirm), conditional authentication and sign-in, `changeApiKey`, `phone/EmailChange`, `regenerateWithUUID`, and `signOutWithMode`.
- Added the `Apple` value to the `identityProvider` enum.

### Fixed
- Implemented minor fixes to improve the handling of channel method results.

### Changed
- Stability improvements.


## [0.6.3] - 2023-07-13

### Added
- Included iOS native push extensions to the example app.

### Fixed
- Resolved issues with iOS tracker params mapping.
- Enhanced the handling of channel methods result.


## [0.6.2] - 2023-06-28

### Fixed
- Removed redundant code from the example app.
- Fixed parameter mapping for custom events in the iOS native part.


## [0.6.1] - 2023-06-28

### Fixed
- Addressed a bug related to Android push notifications banners.

### Changed
- Stability improvements.


## [0.6.0] - 2023-06-16

### Added
- We added a new `content.generateDocument` method. It's analogous to `Content.getDocument``. The old method is deprecated. The new method generates the document that is defined for the provided slug.
- We added a new `content.getRecommendationsV2` method. It's analogous to `content.getRecommendations`. The old method is deprecated. The new method gets recommendations that are defined for the options provided.
- We added a new `content.generateScreenView` method. It's analogous to `content.getScreenView`. The old method is deprecated. The new method generates a customer's highest-priority screen view campaign that is defined for the provided slug.
- We added models correlating with new methods: `ScreenView`, `Document`.
- Introduced predefined `Events`. Full list is available in the documentation.

### Fixed
- Clarified the terminology related to the API key.

### Removed
- Deprecated old methods in the `Content` module.


## [0.5.0] - 2023-05-10

### Added
- Introduced the `Promotions` module.

### Fixed
- Made minor fixes to improve mapping.

### Changed
- Stability improvements.


## [0.4.1] - 2023-04-21

### Added
- Updated SSL pins for all domains.

### Removed
- Removed the `QUERY_ALL_PACKAGES` permission in Android.


## [0.4.0] - 2023-03-28

### Added 
- Extended and polished the example app.

### Fixed
- Enhanced object mappings for `Content` methods.
- Adjusted project structure to align with the preferred pattern on pub.dev.


## [0.3.0] - 2023-03-15

### Added 
- Implemented `Inapp` and `Push` notifications handling.
- Enhanced native listeners handling.
- Introduced several methods in the `Client` module for client account management.

### Fixed
- Improved the project structure.

### Changed
- Stability improvements.


## [0.2.0] - 2023-02-03

### Added
- Added the `Settings` module.
- Introduced the `Tracker` module with custom events.
- Implemented the `Content` module with several methods.

### Fixed
- Enhanced the project structure.


## [0.1.0] - 2023-01-24

### Added
- Initiated the SDK with basic configuration options.
- Introduced the `Client` module with several methods for user authorization and session management.
