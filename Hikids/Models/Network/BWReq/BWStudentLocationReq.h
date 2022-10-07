//
//  BWStudentLocationReq.h
//  Hikids
//
//  Created by 马腾 on 2022/10/7.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWStudentLocationReq : BWBaseReq
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;

- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
