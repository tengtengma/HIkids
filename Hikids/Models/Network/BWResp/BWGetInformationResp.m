//
//  BWGetInfomationResp.m
//  Hikids
//
//  Created by 马腾 on 2024/1/22.
//

#import "BWGetInformationResp.h"

@implementation BWGetInformationResp
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
