#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <SyneriseSDK/SyneriseSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UNNotificationCategory *singleMediaCategory = [UNNotificationCategory categoryWithIdentifier:SNRSingleMediaContentExtensionViewControllerCategoryIdentifier actions:@[] intentIdentifiers:@[] options:0];
    
    UNNotificationAction *carouselPreviousAction = [UNNotificationAction actionWithIdentifier:SNRCarouselContentExtensionViewControllerPreviousItemIdentifier title:@"Previous" options:0];
    
    UNNotificationAction *carouselGoAction = [UNNotificationAction actionWithIdentifier:SNRCarouselContentExtensionViewControllerChooseItemIdentifier title:@"Go" options:0];
    
    UNNotificationAction *carouselNextAction = [UNNotificationAction actionWithIdentifier:SNRCarouselContentExtensionViewControllerNextItemIdentifier title:@"Next" options:0];
    
    UNNotificationCategory *carouselCategory = [UNNotificationCategory categoryWithIdentifier:SNRCarouselContentExtensionViewControllerCategoryIdentifier actions:@[carouselPreviousAction, carouselGoAction, carouselNextAction] intentIdentifiers:@[] options:0];
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:singleMediaCategory, carouselCategory, nil]];
    

    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
