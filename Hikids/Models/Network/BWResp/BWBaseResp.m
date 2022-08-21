//
//  BWBaseResp.m
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/11.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import "BWBaseResp.h"

@implementation BWBaseResp
@synthesize errorCode = _errorCode, errorMessage = _errorMessage;

- (id)initWithJSONDictionary: (NSDictionary*)jsonDic
{
    if (self = [super init])
    {
//        NSString *className = NSStringFromClass(self.class);
//        if ([className isEqualToString:@"BWGetPicValidResp"]||[className isEqualToString:@"BWGetMobileOrEmailResp"]||[className isEqualToString:@"BWBindResp"]) {
//
//            _errorCode = [[jsonDic safeObjectForKey:@"code"] intValue];
//            _errorMessage = [jsonDic safeObjectForKey:@"message"];
//
//        }else{
            _errorMessage = [jsonDic safeObjectForKey:@"message"];
            
            if ([[jsonDic safeObjectForKey:@"result"] isEqualToString:@"success"]){
                _errorCode = 1;
            }
//        }
        

    }
    return self;
}
@end
