//
//  BWGetKindergartenReq.m
//  Hikids
//
//  Created by 马腾 on 2022/10/17.
//

#import "BWGetKindergartenReq.h"

@implementation BWGetKindergartenReq
- (NSURL *)url
{
    
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,GetKindergartenURL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
