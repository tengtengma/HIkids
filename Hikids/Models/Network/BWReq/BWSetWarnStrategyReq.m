//
//  BWSetWarnStrategyReq.m
//  Hikids
//
//  Created by 马腾 on 2024/4/22.
//

#import "BWSetWarnStrategyReq.h"

@implementation BWSetWarnStrategyReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@/%ld",BaseURL,SetWarnStrategyURL,self.strategyLevel.integerValue];
    return [NSURL URLWithString:str];
}
- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
