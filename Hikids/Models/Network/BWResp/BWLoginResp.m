//
//  BWLoginResp.m
//  NStudyCenterDemo
//
//  Created by 马腾 on 2020/5/7.
//  Copyright © 2020 beiwaionline. All rights reserved.
//

#import "BWLoginResp.h"

@implementation BWLoginResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    
    if (self = [super initWithJSONDictionary:jsonDic]) {
        if (self.errorCode == ResponseCode_Success)
        {
            self.item = [jsonDic safeObjectForKey:@"item"];
            self.itemList = [jsonDic safeObjectForKey:@"itemList"];
            
            NSString *token = [jsonDic safeObjectForKey:@"token"];
            if (token.length != 0) {
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_Jwtoken];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        }
    }
    return self;
}
@end
