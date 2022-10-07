//
//  BWDestnationInfoReq.m
//  Hikids
//
//  Created by 马腾 on 2022/10/7.
//

#import "BWDestnationInfoReq.h"

@implementation BWDestnationInfoReq
- (NSURL *)url
{
    
    NSString *str = [NSString stringWithFormat:@"%@%@/%@",BaseURL,DestinationInfoURL,self.dId];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    
    return dic;
}
@end
