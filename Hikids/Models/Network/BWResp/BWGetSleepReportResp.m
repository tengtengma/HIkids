//
//  BWGetSleepReportResp.m
//  Hikids
//
//  Created by 马腾 on 2023/1/13.
//

#import "BWGetSleepReportResp.h"

@implementation BWGetSleepReportResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSMutableArray *itemList = [[NSMutableArray alloc] init];

        NSDictionary *dic = [jsonDic safeObjectForKey:@"item"];
        if (dic) {
//            HTask *model = [HTask mj_objectWithKeyValues:dic];
//            model.tId = [dic safeObjectForKey:@"id"];
//            [itemList addObject:model];
            self.itemList = itemList;
        }
    }
    return self;
}
@end
