//
//  BWSetWarnStrategyReq.h
//  Hikids
//
//  Created by 马腾 on 2024/4/22.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWSetWarnStrategyReq : BWBaseReq
@property (nonatomic, strong) NSNumber *strategyLevel;
- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
