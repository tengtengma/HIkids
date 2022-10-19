//
//  BWChangeTaskStateReq.m
//  Hikids
//
//  Created by 马腾 on 2022/10/19.
//

#import "BWChangeTaskStateReq.h"

@implementation BWChangeTaskStateReq
- (NSURL *)url
{
    
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,ChangeTaskStateURL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    
    if (self.tId) {
        [dic setObject:self.tId forKey:@"id"];
    }
    if (self.status) {
        [dic setObject:self.status forKey:@"status"];

    }

    return dic;
}
@end
