//
//  BWGetSleepTaskReq.m
//  Hikids
//
//  Created by 马腾 on 2023/1/11.
//

#import "BWGetSleepTaskReq.h"

@implementation BWGetSleepTaskReq
- (NSURL *)url
{
    
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,GetSleepTaskURL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
