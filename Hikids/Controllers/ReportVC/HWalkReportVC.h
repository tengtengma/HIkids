//
//  HWalkReportVC.h
//  Hikids
//
//  Created by 马腾 on 2023/1/5.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^closeWalkReportAction)(void);

@interface HWalkReportVC : BaseVC
@property (nonatomic, copy) closeWalkReportAction closeWalkReportBlock;

@end

NS_ASSUME_NONNULL_END
