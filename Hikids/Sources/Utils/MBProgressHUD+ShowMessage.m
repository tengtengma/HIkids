//
//  MBProgressHUD+ShowMessage.m
//  Hikids
//
//  Created by 马腾 on 2022/9/19.
//

#import "MBProgressHUD+ShowMessage.h"

@implementation MBProgressHUD (ShowMessage)

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view hudModel:(MBProgressHUDMode)model hide:(BOOL)hide{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = model;
    // YES代表需要蒙版效果
//    hud.dimBackground = NO;
    if (hide) {
        [hud hideAnimated:YES afterDelay:2];
    }
    return hud;
}
@end
