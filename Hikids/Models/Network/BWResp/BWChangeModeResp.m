//
//  BWChangeModeResp.m
//  Hikids
//
//  Created by 马腾 on 2024/7/9.
//

#import "BWChangeModeResp.h"

@implementation BWChangeModeResp
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
