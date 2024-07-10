//
//  BWChangeModeReq.m
//  Hikids
//
//  Created by 马腾 on 2024/7/9.
//

#import "BWChangeModeReq.h"

@implementation BWChangeModeReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@/%@/%ld",BaseURL,ChangeModeURL,self.tId,self.modeCode];
    return [NSURL URLWithString:str];
}
- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];

    return dic;
}
@end
