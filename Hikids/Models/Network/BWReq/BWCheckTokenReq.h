//
//  BWCheckTokenReq.h
//  Hikids
//
//  Created by 马腾 on 2022/9/6.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWCheckTokenReq : BWBaseReq

- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
