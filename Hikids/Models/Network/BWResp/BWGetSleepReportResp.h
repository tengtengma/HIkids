//
//  BWGetSleepReportResp.h
//  Hikids
//
//  Created by 马腾 on 2023/1/13.
//

#import "BWBaseResp.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWGetSleepReportResp : BWBaseResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
