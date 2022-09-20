//
//  HConfig.h
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#ifndef HConfig_h
#define HConfig_h


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define BW_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度

#define BW_NavBarHeight 44.0

#define BW_TabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) //底部tabbar高度

#define BW_TopHeight (BW_StatusBarHeight + BW_NavBarHeight) //整个导航栏高度

#define DefineWeakSelf __weak __typeof(self) weakSelf = self

#define myBlueColor [UIColor colorWithRed:63.0/255.0 green:111.0/255.0 blue:219.0/255.0 alpha:1.0]

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhoneXMaxPro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)


#define iphone7 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPHoneXr
#define iPHoneXr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size): NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define kRootView [UIApplication sharedApplication].keyWindow.viewForLastBaselineLayout

//判断数组是否为空
#define IS_VALID_ARRAY(array) (array && ![array isEqual:[NSNull null]] && [array isKindOfClass:[NSArray class]] && [array count])
//判断字符串是否为空
#define IS_VALID_STRING(string) (string && ![string isEqual:[NSNull null]] && [string isKindOfClass:[NSString class]] && [string length])

#define BWColor(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]

#define NAV_HEIGHT  64

//iphonex系列 尺寸比例系数
#define iPhoneXRatio (SCREEN_HEIGHT / 812)
//竖屏使用
#define PAdaptation_x(x) ((x)*SCREEN_WIDTH/390)
#define PAaptation_y(y) (((y)*SCREEN_HEIGHT)/844)
//横屏使用
#define LAdaptation_x(x) ((x)*SCREEN_WIDTH/960)
#define LAdaptation_y(y) ((y)*SCREEN_HEIGHT/600)



//用户信息
#define KEY_Jwtoken       @"jwtoken"
#define KEY_UserName      @"userName"
#define KEY_Password      @"password"
#define KEY_Email         @"email"


//谷歌地图key
#define APIKEY_Google @"AIzaSyDbMPtKwpGdLOLgnG6EFYYfBs0WfQi32kg"



#endif /* HConfig_h */
