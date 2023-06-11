//
//  BWGetWalkReportReq.h
//  Hikids
//
//  Created by 马腾 on 2023/6/11.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWGetWalkReportReq : BWBaseReq
@property (nonatomic, strong) NSString *taskId;

- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
