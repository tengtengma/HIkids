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
typedef void(^closeAction)(void);


@interface HWalkMenuVC : HBaseMenuVC
@property (nonatomic, copy) startWalkAction startWalkBlock;
@property (nonatomic, copy) closeAction closeBlock;

@end

NS_ASSUME_NONNULL_END
