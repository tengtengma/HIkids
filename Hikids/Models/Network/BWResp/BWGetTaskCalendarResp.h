//
//  BWGetTaskCalendarResp.h
//  Hikids
//
//  Created by 马腾 on 2023/1/14.
//

#import "BWBaseResp.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWGetTaskCalendarResp : BWBaseResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic;

@end

@interface BWGetTaskMonthCalendarResp : BWBaseResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
