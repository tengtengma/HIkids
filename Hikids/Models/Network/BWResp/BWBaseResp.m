//
//  BWBaseResp.m
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/11.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import "BWBaseResp.h"

@implementation BWBaseResp

- (id)initWithJSONDictionary: (NSDictionary*)jsonDic
{
    if (self = [super init])
    {
        self.errorCode = [[jsonDic safeObjectForKey:@"code"] intValue];
        self.errorMessage = [jsonDic safeObjectForKey:@"msg"];
    }
    return self;
}
@end
