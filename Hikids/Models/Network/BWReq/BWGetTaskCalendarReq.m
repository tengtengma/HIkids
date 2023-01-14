//
//  BWGetTaskCalendarReq.m
//  Hikids
//
//  Created by 马腾 on 2023/1/14.
//

#import "BWGetTaskCalendarReq.h"

@implementation BWGetTaskCalendarReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@/%@",BaseURL,GetTaskWithCalendarURL,self.dateStr];
    return [NSURL URLWithString:str];
}
- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end

@implementation BWGetTaskMonthCalendarReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@/%@",BaseURL,GetMonthCalendarURL,self.dateStr];
    return [NSURL URLWithString:str];
}
- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
