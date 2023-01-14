//
//  BWGetTaskCalendarReq.h
//  Hikids
//
//  Created by 马腾 on 2023/1/14.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWGetTaskCalendarReq : BWBaseReq
@property (nonatomic, strong) NSString *dateStr;

@end

@interface BWGetTaskMonthCalendarReq : BWBaseReq
@property (nonatomic, strong) NSString *dateStr;

@end

NS_ASSUME_NONNULL_END
