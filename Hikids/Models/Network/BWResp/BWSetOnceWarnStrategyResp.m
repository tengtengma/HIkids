//
//  BWChangeWalkWarnResp.m
//  Hikids
//
//  Created by 马腾 on 2024/5/29.
//

#import "BWSetOnceWarnStrategyResp.h"

@implementation BWSetOnceWarnStrategyResp
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
