//
//  BWStopWarnReq.h
//  Hikids
//
//  Created by 马腾 on 2024/4/23.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWStopWarnReq : BWBaseReq
@property (nonatomic, strong) NSString *studentId;
- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
