//
//  BWSetRingReq.m
//  Hikids
//
//  Created by 马腾 on 2024/4/22.
//

#import "BWSetRingReq.h"

@implementation BWSetRingReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@/%ld",BaseURL,SetRingNumberURL,self.ringNumber.integerValue];
    return [NSURL URLWithString:str];
}
- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
