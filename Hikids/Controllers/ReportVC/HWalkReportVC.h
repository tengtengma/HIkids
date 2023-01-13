//
//  HWalkReportVC.h
//  Hikids
//
//  Created by 马腾 on 2023/1/5.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class HTask;

typedef void(^closeWalkReportAction)(void);

@interface HWalkReportVC : BaseVC
@property (nonatomic, copy) closeWalkReportAction closeWalkReportBlock;
@property (nonatomic, strong) HTask *currentTask;
@property (nonatomic, strong) NSString *source;

@end

NS_ASSUME_NONNULL_END
