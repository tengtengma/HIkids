//
//  HWalkMenuVC.h
//  Hikids
//
//  Created by 马腾 on 2022/10/5.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class HTask;

typedef void(^startWalkAction)(HTask *task);

@interface HWalkMenuVC : BaseVC
@property (nonatomic, copy) startWalkAction startWalkBlock;

@end

NS_ASSUME_NONNULL_END
