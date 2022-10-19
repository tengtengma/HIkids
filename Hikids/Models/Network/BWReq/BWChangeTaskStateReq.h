//
//  BWChangeTaskStateReq.h
//  Hikids
//
//  Created by 马腾 on 2022/10/19.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWChangeTaskStateReq : BWBaseReq
@property (nonatomic, strong) NSString *tId;
@property (nonatomic, strong) NSString *status;

- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
