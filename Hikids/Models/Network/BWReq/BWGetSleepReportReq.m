//
//  BWGetSleepReportReq.m
//  Hikids
//
//  Created by 马腾 on 2023/1/13.
//

#import "BWGetSleepReportReq.h"

@implementation BWGetSleepReportReq

- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@/%@",BaseURL,GetSleepReportURL,self.taskId];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
