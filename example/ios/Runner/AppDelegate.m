#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <SyneriseSDK/SyneriseSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> *categories) {
        NSMutableArray<NSString *> *categoryIdentifiers = [NSMutableArray arrayWithCapacity:categories.count];
        for (UNNotificationCategory *category in categories) {
            [categoryIdentifiers addObject:category.identifier];
        }
        
        NSMutableSet<UNNotificationCategory *> *mutableCategories = [categories mutableCopy];
        
        if ([categoryIdentifiers containsObject:SNRSingleMediaContentExtensionViewControllerCategoryIdentifier] == NO) {
            UNNotificationCategory *singleMediaCategory = [UNNotificationCategory categoryWithIdentifier:SNRSingleMediaContentExtensionViewControllerCategoryIdentifier actions:@[] intentIdentifiers:@[] options:0];
            [mutableCategories addObject:singleMediaCategory];
        }
        
        if ([categoryIdentifiers containsObject:SNRCarouselContentExtensionViewControllerCategoryIdentifier] == NO) {
            UNNotificationAction *carouselPreviousAction = [UNNotificationAction actionWithIdentifier:SNRCarouselContentExtensionViewControllerPreviousItemIdentifier title:@"Previous" options:0];
            UNNotificationAction *carouselGoAction = [UNNotificationAction actionWithIdentifier:SNRCarouselContentExtensionViewControllerChooseItemIdentifier title:@"Go" options:0];
            UNNotificationAction *carouselNextAction = [UNNotificationAction actionWithIdentifier:SNRCarouselContentExtensionViewControllerNextItemIdentifier title:@"Next" options:0];
            UNNotificationCategory *carouselCategory = [UNNotificationCategory categoryWithIdentifier:SNRCarouselContentExtensionViewControllerCategoryIdentifier actions:@[carouselPreviousAction, carouselGoAction, carouselNextAction] intentIdentifiers:@[] options:0];
            [mutableCategories addObject:carouselCategory];
        }
        
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:mutableCategories];
    }];

    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
