//
//  BWStopWarnResp.m
//  Hikids
//
//  Created by 马腾 on 2024/4/23.
//

#import "BWStopWarnResp.h"

@implementation BWStopWarnResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSDictionary *dic = [jsonDic safeObjectForKey:@"item"];
        if (dic) {
            self.item = dic;
        }
    }
    return self;
}
@end
