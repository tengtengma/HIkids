//
//  MBProgressHUD+ShowMessage.h
//  Hikids
//
//  Created by 马腾 on 2022/9/19.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (ShowMessage)

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view hudModel:(MBProgressHUDMode)model hide:(BOOL)hide;

@end

NS_ASSUME_NONNULL_END
