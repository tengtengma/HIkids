//
//  BWAlertCtrl.m
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/25.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import "BWAlertCtrl.h"

@interface BWAlertCtrl ()

@end

@implementation BWAlertCtrl


+ (id)alertControllerWithTitle:(NSString *)title buttonArray:(NSArray *)array message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle clickBlock:(void (^)(NSString *buttonTitle))clickAction
{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    for (int i = 0;i < array.count;i++) {
        UIAlertAction *action ;
        
        if ([[array safeObjectAtIndex:i] isEqualToString:@"アラート停止"]) {
            action = [UIAlertAction actionWithTitle:[array safeObjectAtIndex:i] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                clickAction(action.title);
            }];
        }else{
            action = [UIAlertAction actionWithTitle:[array safeObjectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                clickAction(action.title);
            }];
        }
        
        
        [alertCtrl addAction:action];
    }
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
    
    return alertCtrl;

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

