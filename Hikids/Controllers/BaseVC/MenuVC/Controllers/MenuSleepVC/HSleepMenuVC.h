//
//  HMenuSleepVC.h
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^startSleepAction)(void);

@interface HSleepMenuVC : BaseVC
@property (nonatomic, copy) startSleepAction startSleepBlock;

@end

NS_ASSUME_NONNULL_END
