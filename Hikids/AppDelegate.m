//
//  AppDelegate.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "AppDelegate.h"
#import "HRootVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[HRootVC alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark - 初始化google地图
- (void)setupGoogleMap
{
    [GMSServices provideAPIKey:APIKEY_Google];
    [GMSPlacesClient provideAPIKey:APIKEY_Google];
}



@end
