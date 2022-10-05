//
//  HMenuVC.h
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBaseMenuVC : UIViewController
- (void)clickMenuAction:(UITapGestureRecognizer *)tap;
- (void)showMenuVC;
- (void)closeMenuVC;
- (void)forceShow;
- (void)forceClose;
@end

NS_ASSUME_NONNULL_END
