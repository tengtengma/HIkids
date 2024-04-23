//
//  BWStopWarnReq.m
//  Hikids
//
//  Created by 马腾 on 2024/4/23.
//

#import "BWStopWarnReq.h"

@implementation BWStopWarnReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@/%@",BaseURL,StopWarnURL,self.studentId];
    return [NSURL URLWithString:str];
}
- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
