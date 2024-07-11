//
//  HDtAlertVC.h
//  Hikids
//
//  Created by 马腾 on 2024/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^entreAction)(void);

@interface HDtAlertVC : UIViewController

@property (nonatomic, strong) NSString *source;
@property (nonatomic, copy) entreAction entreBlock;
@end

NS_ASSUME_NONNULL_END
