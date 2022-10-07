//
//  BWGetAssistantReq.m
//  Hikids
//
//  Created by 马腾 on 2022/10/7.
//

#import "BWGetAssistantReq.h"

@implementation BWGetAssistantReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,GetAssistantURL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    
    return dic;
}
@end
