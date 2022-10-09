//
//  BWStudentLocationResp.h
//  Hikids
//
//  Created by 马腾 on 2022/10/7.
//

#import "BWBaseResp.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWStudentLocationResp : BWBaseResp
@property (nonatomic, strong) NSArray *exceptionKids;
@property (nonatomic, strong) NSArray *normalKids;

- (id)initWithJSONDictionary:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
