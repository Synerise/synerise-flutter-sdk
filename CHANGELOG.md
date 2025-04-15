# Changelog
All notable changes to this project will be documented in this file.

## [2.1.0] - 2025-04-11

### Fixed
- [Android] Empty payload in NotificationInfo after clicking on push.

### Added
- In-app campaigns can now use the safe area of the screen, allowing you to display full-screen in-app messages. This option is called "Safe area" in the "Display type" option group in the campaign creator. If switched on, it allows the in-app message to extend into system UI. If switched off, it avoids system bars, notches, and other UI elements.


## [2.0.2] - 2025-03-25
 
 ### Fixed
 - [Android] NPE when clicking on notification with killed app.


## [2.0.1] - 2025-03-13

### Fixed
- [iOS] Issue with authentication (all types): when a customer wanted to authenticate another account, the UUID was not regenerated. The problem occurred in version 2.0.0.


## [2.0.0] - 2025-03-10

IMPORTANT:
- This major version is NOT backwards compatible.
- Update of native SDK's dependencies to 6.0.0 (Android) and 5.0.0 (iOS).
- [iOS] Support for older iOS versions ends. Minimum deployment target is changed to iOS 13.
- [iOS] Bitcode is not supported in SDK version 5.0.0 and higher. Xcode ignores bitcode.

### Added
- `appVersion` parameter for `client.applicationStarted` event. It is the same as `version`. `version` is deprecated.
- `sdkPreviousVersion` parameter for `client.applicationStarted` event. It is the version of the SDK before the current version in the application.

### Removed
- `InjectorWalkthroughListener` for handling actions from Walkthrough campaigns.
- `InjectorBannerListener` for handling actions from Banner campaigns.
- `Synerise.content.getDocument(slugName, onSuccess, onError)` method. You should use `Synerise.content.generateDocument(slug, onSuccess, onError:)` method.
- `Synerise.content.getDocuments(apiQuery, onSuccess, onError)` method.
- `Synerise.content.getRecommendations(options, onSuccess, onError)` method.
- `Synerise.content.getScreenView(onSuccess, onError)` method and correlated models (`screen_view_response`, `screen_view_audience`). You should use the `Synerise.content.generateScreenView(feedSlug, onSuccess, onError)` or the `Synerise.content.generateScreenView(apiQuery, onSuccess, onError)` method.
- `Synerise.notifications.isSyneriseBanner(payload:)`
- `Synerise.injector.getWalkthrough()` method.
- `Synerise.injector.showWalkthrough()` method.
- `Synerise.injector.isWalkthroughLoaded()` method.
- `Synerise.injector.isLoadedWalkthroughUnique()` method.
- [iOS] `deviceID` parameter from `client.applicationStarted` event. It was redundant with the `deviceId` parameter.

### Changed
- Synerise initialization builder method `withClientApiKey(clientApiKey)` to `withApiKey(apiKey)`.
- `Synerise.changeClientApiKey(clientApiKey, config)` to `Synerise.changeApiKey(apiKey, config)`.
- `Synerise.client.activateAccount(email, onSuccess, onError)` to `Synerise.client.requestAccountActivation(email, onSuccess, onError)`.
- `Synerise.client.confirmAccount(token:onSuccess:failure:)` to `Synerise.client.confirmAccountActivation(token, onSuccess, onError)`.
- Property `identifier` in the `Document` model changed to `uuid`.
- Improvements to stability.


## [1.5.1] - 2025-03-25
 
 ### Fixed
 - [Android] NPE when clicking on notification with killed app.


## [1.5.0] - 2025-01-30

### Fixed
- [Android] We fixed issue with mapping of the `ClientAccountInformation` model. 

### Added
[Android] We added HMS support. It can be enabled using the new `setMessagingServiceType(messagingServiceType)` method in `SyneriseInitializer`. You can pass `MessagingServiceType.hms` to this method to enable notification processing for HMS payloads.

### Changed
- Nullability of the `tags` property in the `ClientAccountInformation` model.


## [1.4.3] - 2024-11-12

### Fixed
- [iOS] Potential issues with checking if the app is launched in the background. The SDK set the background mode to true on UIScene and SwiftUI based apps. It could cause the app to freeze.


## [1.4.2] - 2024-10-15

### Fixed
- [iOS] Optimization of the registration for push notifications process. The cache for that request was erroneously removed in version 4.23.0 of the native SDK.


## [1.4.1] - 2024-10-14

### Fixed
- [Android] workManager npe - for android api lower than 24

### Changed
- Update of native SDK's dependencies.


## [1.4.0] - 2024-10-09

### Fixed
- [iOS] Some potential issues with possible database corruption.
- [Android] Notification callback issue when app was in foreground.

### Added
- `Synerise.settings.inAppMessaging.contentBaseUrl` option in settings to let you set the base URL to use for all relative URLs in an in-app message's creation.
- `Synerise.client.updateAccountBasicInformation(context, onSuccess, onError)` method. The new method updates anonymous users.
- `ClientAccountUpdateBasicInformationContext` model correlated with the new `Synerise.Client.updateAccountBasicInformation(context, onSuccess, onError)` method.

### Changed
- Update of native SDK's dependencies.
- Improvements to stability.


## [1.3.1] - 2024-09-16

### Fixed
- [Android] Null pointer exception while launching callback from push notification in some cases.


## [1.3.0] - 2024-08-05

### Fixed
- [iOS] Potential issue with slow SDK initialization.
- [iOS] Potential issues with Simple Authentication requests.

### Added
- We extended a `Synerise.changeClientApiKey(apiKey, config)` method and added new parameter (`config`) that allows adding some initialization parameters.
- We added new parameters to the push.click event: `clickSource`, `actionType`, `url` and `actionButtonTitle`.

### Changed
- `requestValidationSalt` (Simple Auth) is cleared when  `Synerise.changeClientApiKey(apiKey, config)` is invoked without suitable config.
- Update of native SDK's dependencies.
- Improvements to stability.

## [1.2.0] - 2024-07-15

### Added
- We added a`testDelivery` and `journeyId` parameters to tracked notification events (`push.view`, `push.click`, and so on). It describes if the notification was sent as a test notification from a campaign.
- We added a new `Synerise.content.generateDocumentWithApiQuery(apiQuery, onSuccess, onError)` method. It is analogous to `Synerise.content.generateDocument(slug, onSuccess, onError)`, but can contain more context parameters provided in a query object.
- We added a new `Synerise.content.generateScreenViewWithApiQuery(apiQuery, onSuccess, onError)` method. It is analogous to `Synerise.content.generateScreenView(feedSlug, onSuccess, onError)`, but can contain more context parameters provided in a query object.
- Anchors from Drag & Drop Builder in the In-App editor are interpreted as URL or as deeplink depending on the value.

### Changed
- We added validation of reserved parameters in events. Now, if a parameter is forbidden, it is removed from the parameters and a log is printed.
- Improvements to stability.

### Changed
- Stability improvements.


## [1.1.1] - 2024-06-17

### Changed
- Stability improvements.


## [1.1.0] - 2024-06-17

### Fixed
- [iOS] Some potential issues with retrieving system push consent by the SDK.

### Added
- `Synerise.settings.tracker.eventsTriggeringFlush` option in settings to let you set the list of event actions which will trigger instant sending of all events in the queue. The default array contains only push event's actions.

### Changed
- All events connected with push campaigns will flush the queue and send events immediately.
- Improvements to push notifications registration.
- Stability improvements.


## [1.0.2] - 2024-05-06

### Fixed
- [android] NPE on registerForPush while SDK was not initialized yet.

### Added
- `Synerise.onReady` callback to properly handle Synerise SDK initialization state.

### Changed
- Stability improvements.


## [1.0.1] - 2024-04-05

### Fixed
- [android] NPE on getClientId after apiKey changes.
- [android] registerForPushCache was not passing request after client context change within 24h.

### Changed
- Stability improvements.


## [1.0.0] - 2024-04-04

IMPORTANT: 
We've introduced significant improvements to our method invocation patterns to enhance error handling and simplify success callbacks. This change requires updates to existing method calls in your applications.

- **API Call Pattern Changes**: Previously, asynchronous API calls were structured to use await along with catchError for error handling. Now, we've shifted to a more structured callback approach using onSuccess and onError parameters, providing clearer control over success and error handling.

- **Simplification of Data Retrieval Methods**: For methods that retrieve data from native SDKs, such as obtaining a UUID, the pattern has been simplified to use .then for handling successful outcomes. This change promotes cleaner code and more intuitive success handling. Now, the new pattern is more streamlined and focused on the success case.

### Added
- [iOS] `Synerise.settings.sdk.localizable` option in settings to let you localize some strings displayed by the SDK.
- `clientId` property in the `Token` model.

### Fixed
- Improved mechanism for checking capping in in-app messages. The number of views no longer resets when the account's UUID changes.

### Changed
- Stability improvements.


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
