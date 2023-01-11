//
//  BWGetSleepTaskReq.h
//  Hikids
//
//  Created by 马腾 on 2023/1/11.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWGetSleepTaskReq : BWBaseReq
- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;

@end

NS_ASSUME_NONNULL_END
