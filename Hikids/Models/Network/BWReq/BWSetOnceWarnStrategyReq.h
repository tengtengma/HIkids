//
//  BWChangeWalkWarnReq.h
//  Hikids
//
//  Created by 马腾 on 2024/5/29.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWSetOnceWarnStrategyReq : BWBaseReq
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSNumber *strategyLevel;

- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
