//
//  HSetAlertAccurateVC.h
//  Hikids
//
//  Created by 马腾 on 2024/4/19.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^saveFinished)(void);

@interface HSetAlertAccurateVC : BaseVC
@property (nonatomic, assign) NSInteger source; //0是全局 1是walk
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, copy) saveFinished saveFinishedBlock;

@end

NS_ASSUME_NONNULL_END
