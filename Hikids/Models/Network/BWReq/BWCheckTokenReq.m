//
//  BWCheckTokenReq.m
//  Hikids
//
//  Created by 马腾 on 2022/9/6.
//

#import "BWCheckTokenReq.h"

@implementation BWCheckTokenReq

- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,CheckToken_URL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    
    return dic;
}
@end
