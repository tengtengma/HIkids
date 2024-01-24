//
//  BWLoginReq.m
//  NStudyCenterDemo
//
//  Created by 马腾 on 2020/5/7.
//  Copyright © 2020 beiwaionline. All rights reserved.
//

#import "BWLoginReq.h"

@implementation BWLoginReq

- (NSURL *)url
{
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,LoginURL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    
    if (self.username) {
        [dic setObject:self.username forKey:@"username"];
    }
    if (self.password) {
        [dic setObject:self.password forKey:@"password"];
    }

    return dic;
}
@end
