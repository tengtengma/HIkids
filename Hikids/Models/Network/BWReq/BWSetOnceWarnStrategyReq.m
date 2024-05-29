//
//  BWChangeWalkWarnReq.m
//  Hikids
//
//  Created by 马腾 on 2024/5/29.
//

#import "BWSetOnceWarnStrategyReq.h"

@implementation BWSetOnceWarnStrategyReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@/%@/%@",BaseURL,ChangeWalkWarnURL,self.taskId,self.strategyLevel];
    return [NSURL URLWithString:str];
}
- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
