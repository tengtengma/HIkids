//
//  BWGetPDFResp.m
//  Hikids
//
//  Created by 马腾 on 2023/1/15.
//

#import "BWGetPDFResp.h"

@implementation BWGetPDFResp
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
