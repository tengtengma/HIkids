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
@property (nonatomic, strong) NSString *source; //区分从哪跳转 如果是散步终了 是1 看报告是 2

@end

NS_ASSUME_NONNULL_END
