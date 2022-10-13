//
//  HWalkMenuVC.h
//  Hikids
//
//  Created by 马腾 on 2022/10/5.
//

#import "HBaseMenuVC.h"

NS_ASSUME_NONNULL_BEGIN

@class HWalkTask;

typedef void(^startWalkAction)(HWalkTask *walkTask);

@interface HWalkMenuVC : HBaseMenuVC
@property (nonatomic, copy) startWalkAction startWalkBlock;

@end

NS_ASSUME_NONNULL_END
