//
//  BWGetAssistantReq.h
//  Hikids
//
//  Created by 马腾 on 2022/10/7.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWGetAssistantReq : BWBaseReq
- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
