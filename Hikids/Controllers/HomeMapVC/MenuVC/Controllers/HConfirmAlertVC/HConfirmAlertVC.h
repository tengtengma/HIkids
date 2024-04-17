//
//  HConfirmAlertVC.h
//  Hikids
//
//  Created by 马腾 on 2024/4/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HStudent;

typedef void(^confirmAction)(void);

@interface HConfirmAlertVC : UIViewController
@property (nonatomic, copy) confirmAction confirmBlock;

- (instancetype)initWithStudent:(HStudent *)student;

@end

NS_ASSUME_NONNULL_END
