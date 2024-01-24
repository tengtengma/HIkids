//
//  BWGetInfomationReq.h
//  Hikids
//
//  Created by 马腾 on 2024/1/22.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWGetInformationReq : BWBaseReq

- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
