//
//  AppDelegate.h
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
//*******强制横竖屏********
@property (assign , nonatomic) BOOL isForceLandscape;
@property (assign , nonatomic) BOOL isForcePortrait;

@end

