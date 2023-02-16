//
//  AppDelegate.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "AppDelegate.h"
#import "HMapVC.h"
#import "HLoginVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self setupGoogleMap];

    HLoginVC *loginVC = [[HLoginVC alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:KEY_UserName];
    if (userName.length != 0) {
        [loginVC autoLoginAction];//此处为了刷新一下token
        self.window.rootViewController = [[HMapVC alloc] init];
    }else{
        self.window.rootViewController = loginVC;
    }

//    self.window.rootViewController = [[HLoginVC alloc] init];

    [self.window makeKeyAndVisible];
    
    [self registerAPN];
    
    
    return YES;
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterActive" object:nil];
}
#pragma mark - 初始化google地图
- (void)setupGoogleMap
{
    [GMSServices provideAPIKey:APIKEY_Google];
    [GMSPlacesClient provideAPIKey:APIKEY_Google];
}
#pragma mark - 初始化本地推送 -
- (void)registerAPN {

    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
    } else {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}
//竖屏显示
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.isForceLandscape) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}


@end
