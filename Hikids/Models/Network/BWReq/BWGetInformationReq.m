//
//  BWGetInfomationReq.m
//  Hikids
//
//  Created by 马腾 on 2024/1/22.
//

#import "BWGetInformationReq.h"

@implementation BWGetInformationReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,GetInfomationURL];
    return [NSURL URLWithString:str];
}
- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
