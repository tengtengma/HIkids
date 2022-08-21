//
//  BWAlertCtrl.h
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/25.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWAlertCtrl : UIAlertController

+ (id)alertControllerWithTitle:(NSString *)title buttonArray:(NSArray *)array message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle clickBlock:(void (^)(NSString *buttonTitle))clickAction;

@end
