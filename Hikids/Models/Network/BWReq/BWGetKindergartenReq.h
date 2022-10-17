//
//  BWGetKindergartenReq.h
//  Hikids
//
//  Created by 马腾 on 2022/10/17.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWGetKindergartenReq : BWBaseReq

- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
