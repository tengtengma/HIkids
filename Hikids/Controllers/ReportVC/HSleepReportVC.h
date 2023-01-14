//
//  HSleepReportVC.h
//  Hikids
//
//  Created by 马腾 on 2023/1/4.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^closeSleepReportAction)(void);

@interface HSleepReportVC : BaseVC
@property (nonatomic, copy) closeSleepReportAction closeSleepReportBlock;
@property (nonatomic, strong) NSString *taskId;

@end

NS_ASSUME_NONNULL_END
