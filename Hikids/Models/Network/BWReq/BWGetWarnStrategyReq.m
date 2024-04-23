//
//  BWGetWarnStrategyReq.m
//  Hikids
//
//  Created by 马腾 on 2024/4/22.
//

#import "BWGetWarnStrategyReq.h"

@implementation BWGetWarnStrategyReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,GetWarnStrategyURL];
    return [NSURL URLWithString:str];
}
- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
