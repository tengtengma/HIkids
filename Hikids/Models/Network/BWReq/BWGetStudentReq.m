//
//  BWGetStudentReq.m
//  Hikids
//
//  Created by 马腾 on 2022/10/6.
//

#import "BWGetStudentReq.h"

@implementation BWGetStudentReq
- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,GetStudentsURL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    
    return dic;
}
@end
