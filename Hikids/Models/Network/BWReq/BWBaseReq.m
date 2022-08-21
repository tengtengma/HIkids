//
//  BWBaseReq.m
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/11.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import "BWBaseReq.h"
#import <CommonCrypto/CommonDigest.h>

@implementation BWBaseReq

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (NSURL *)url
{
    return nil;
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *JSONDict = [NSMutableDictionary dictionary];
        
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
//    NSString *userId = [user objectForKey:KEY_UserID];
//    NSString *trainPlanId = [user objectForKey:KEY_trainPlanId];
//    if (userId) {
//        [JSONDict setObject:userId forKey:@"userId"];
//    }
//    if (trainPlanId) {
//        [JSONDict setObject:trainPlanId forKey:@"trainPlanId"];
//    }
        
    return JSONDict;
}
- (BOOL)isSecurityPolicy
{
    return NO;
}
-(BOOL)isCancel
{
    return NO;
}

@end
