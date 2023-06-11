//
//  BWGetWalkReportReq.m
//  Hikids
//
//  Created by 马腾 on 2023/6/11.
//

#import "BWGetWalkReportReq.h"

@implementation BWGetWalkReportReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@/%@",BaseURL,GetTravelReportURL,self.taskId];
    return [NSURL URLWithString:str];
}
- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    return dic;
}
@end
