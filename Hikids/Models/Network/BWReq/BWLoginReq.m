//
//  BWLoginReq.m
//  NStudyCenterDemo
//
//  Created by 马腾 on 2020/5/7.
//  Copyright © 2020 beiwaionline. All rights reserved.
//

#import "BWLoginReq.h"

@implementation BWLoginReq
@synthesize loginName,passWord;

- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,orgloginURL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    
    if (self.loginName) {
        [dic setObject:self.loginName forKey:@"loginName"];
    }
    if (self.passWord) {
        [dic setObject:self.passWord forKey:@"password"];
    }

    return dic;
}
@end
