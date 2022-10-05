//
//  BWGetDestnationReq.m
//  Hikids
//
//  Created by 马腾 on 2022/10/5.
//

#import "BWGetDestnationReq.h"

@implementation BWGetDestnationReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,GetDestinationsURL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    
    return dic;
}
@end
