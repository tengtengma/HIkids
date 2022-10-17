//
//  BWGetTaskReq.m
//  Hikids
//
//  Created by 马腾 on 2022/10/17.
//

#import "BWGetTaskReq.h"

@implementation BWGetTaskReq
- (NSURL *)url
{
    
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,GetTaskURL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
