//
//  BWStudentLocationReq.m
//  Hikids
//
//  Created by 马腾 on 2022/10/7.
//

#import "BWStudentLocationReq.h"

@implementation BWStudentLocationReq
- (NSURL *)url
{
    
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,StudentsLocationURL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    if (self.longitude) {
        [dic setObject:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    }
    if (self.latitude) {
        [dic setObject:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
    }
    return dic;
}
@end
