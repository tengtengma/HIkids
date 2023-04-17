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
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

//#import "JPUSHService.h"
//#import <PushKit/PushKit.h>
//
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//#import <UserNotifications/UserNotifications.h>
//#endif

#import "BaiduMobStat.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化map基础数据
    [self setupGoogleMap];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    HLoginVC *loginVC = [[HLoginVC alloc] init];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:KEY_UserName];
    if (userName.length != 0) {
        [loginVC autoLoginAction];//此处为了刷新一下token
        self.window.rootViewController = [[HMapVC alloc] init];
    }else{
        self.window.rootViewController = loginVC;
    }

    [self.window makeKeyAndVisible];
    


    //注册本地推送
//    [self registerLocalAPN];
    
//    //推送设置
//    [self trackWithDic:launchOptions];
    
    //百度统计
    [self startBaidu];
    
    
    
    
    return YES;
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterActive" object:nil];
}
- (void)startBaidu
{
    [[BaiduMobStat defaultStat] startWithAppId:APIKEY_Baidu];
}
//#pragma mark - 追踪权限 -
//- (void)trackWithDic:(NSDictionary *)launchOptions
//{
//    __block NSString *advertisingId = @"";
//    if (@available(iOS 14, *)) {
//        //设置Info.plist中 NSUserTrackingUsageDescription 需要广告追踪权限，用来定位唯一用户标识
//        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
//              advertisingId = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
//            }
//        }];
//    } else {
//        // 使用原方式访问 IDFA
//      advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    }
//
//    // 3.0.0及以后版本注册
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    if (@available(iOS 12.0, *)) {
//      entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
//    } else {
//      entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    }
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//      //可以添加自定义categories
//  //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//  //      NSSet<UNNotificationCategory *> *categories;
//  //      entity.categories = categories;
//  //    }
//  //    else {
//  //      NSSet<UIUserNotificationCategory *> *categories;
//  //      entity.categories = categories;
//  //    }
//    }
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//
//    //如不需要使用IDFA，advertisingIdentifier 可为nil
//    [JPUSHService setupWithOption:launchOptions appKey:APIKEY_JGPush
//                          channel:@"IOS"
//                 apsForProduction:FALSE
//            advertisingIdentifier:advertisingId];
//
//    //2.1.9版本新增获取registration id block接口。
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//      if(resCode == 0){
//        NSLog(@"registrationID获取成功：%@",registrationID);
//
//      }
//      else{
//        NSLog(@"registrationID获取失败，code：%d",resCode);
//      }
//    }];
//}
#pragma mark - 初始化google地图
- (void)setupGoogleMap
{
    [GMSServices provideAPIKey:APIKEY_Google];
    [GMSPlacesClient provideAPIKey:APIKEY_Google];
}
//#pragma mark - 初始化本地推送 -
//- (void)registerLocalAPN {
//
//    // 检测通知授权情况。可选项，不一定要放在此处，可以运行一定时间后再调用
//    [self performSelector:@selector(checkNotificationAuthorization) withObject:nil afterDelay:10];
//
//    if (@available(iOS 10.0, *)) {
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//
//        }];
//    } else {
//        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
//    }
//}
//竖屏显示
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.isForceLandscape) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}

//#pragma mark - 推送设置 -
//- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
//    NSLog(@"receive notification authorization status:%lu, info:%@", status, info);
//    [self alertNotificationAuthorization:status];
//}
//
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
//
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
//    UNNotificationContent *content = request.content; // 收到推送的消息内容
//
//    NSNumber *badge = content.badge;  // 推送消息的角标
//    NSString *body = content.body;    // 推送消息体
//    UNNotificationSound *sound = content.sound;  // 推送消息的声音
//    NSString *subtitle = content.subtitle;  // 推送消息的副标题
//    NSString *title = content.title;  // 推送消息的标题
//
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//      [JPUSHService handleRemoteNotification:userInfo];
////      NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
////      [rootViewController addNotificationCount];
//
//    }
//    else {
//      // 判断为本地通知
//      NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
//    }
//
//    completionHandler();  // 系统要求执行这个方法
//}
//
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//#pragma mark- JPUSHRegisterDelegate
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler {
//  NSDictionary * userInfo = notification.request.content.userInfo;
//
//  UNNotificationRequest *request = notification.request; // 收到推送的请求
//  UNNotificationContent *content = request.content; // 收到推送的消息内容
//
//  NSNumber *badge = content.badge;  // 推送消息的角标
//  NSString *body = content.body;    // 推送消息体
//  UNNotificationSound *sound = content.sound;  // 推送消息的声音
//  NSString *subtitle = content.subtitle;  // 推送消息的副标题
//  NSString *title = content.title;  // 推送消息的标题
//
//  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//    [JPUSHService handleRemoteNotification:userInfo];
////    NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
//
//  }
//  else {
//    // 判断为本地通知
//    NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
//  }
//  completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
//}
//


//#endif


//#pragma mark - 通知权限引导
//
//// 检测通知权限授权情况
//- (void)checkNotificationAuthorization {
//  [JPUSHService requestNotificationAuthorization:^(JPAuthorizationStatus status) {
//    // run in main thread, you can custom ui
//    NSLog(@"notification authorization status:%lu", status);
//    [self alertNotificationAuthorization:status];
//  }];
//}
//// 通知未授权时提示，是否进入系统设置允许通知，仅供参考
//- (void)alertNotificationAuthorization:(JPAuthorizationStatus)status {
//  if (status < JPAuthorizationStatusAuthorized) {
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"允许通知" message:@"是否进入设置允许通知？" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    [alertView show];
//  }
//}
@end
