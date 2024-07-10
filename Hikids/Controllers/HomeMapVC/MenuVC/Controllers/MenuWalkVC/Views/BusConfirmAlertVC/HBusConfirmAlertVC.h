//
//  HBusConfirmAlertView.h
//  Hikids
//
//  Created by 马腾 on 2024/7/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^cancelAction)(void);
typedef void(^confirmBusAction)(NSString * type);

@interface HBusConfirmAlertVC : UIViewController
@property (nonatomic, copy) cancelAction cancelBlock;
@property (nonatomic, copy) confirmBusAction confirmBlock;

- (instancetype)initWithType:(NSString *)type;


@end

NS_ASSUME_NONNULL_END
