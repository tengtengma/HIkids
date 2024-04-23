//
//  BWGetWarnStrategyResp.m
//  Hikids
//
//  Created by 马腾 on 2024/4/22.
//

#import "BWGetWarnStrategyResp.h"

@implementation BWGetWarnStrategyResp
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
