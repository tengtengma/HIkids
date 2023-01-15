//
//  BWGetPDFReq.m
//  Hikids
//
//  Created by 马腾 on 2023/1/15.
//

#import "BWGetPDFReq.h"

@implementation BWGetPDFReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@/%@",BaseURL,GetPDFURL,self.taskId];
    return [NSURL URLWithString:str];
}
- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    return dic;
}
@end
