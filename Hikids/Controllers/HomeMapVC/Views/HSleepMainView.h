//
//  HSleepMainView.h
//  Hikids
//
//  Created by 马腾 on 2023/1/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^sleepTimeOver)(void);

@interface HSleepMainView : UIView
@property (nonatomic, copy) sleepTimeOver sleepTimeOverBlock;

- (void)setupContent:(id)model;
- (void)closeTimer;
@end

NS_ASSUME_NONNULL_END
