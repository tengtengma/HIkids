//
//  BWGetSleepReportResp.m
//  Hikids
//
//  Created by 马腾 on 2023/1/13.
//

#import "BWGetSleepReportResp.h"
#import "HReportInfo.h"

@implementation BWGetSleepReportResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSMutableArray *itemList = [[NSMutableArray alloc] init];

        NSDictionary *dic = [jsonDic safeObjectForKey:@"item"];
        if (dic) {
            HReportInfo *model = [HReportInfo mj_objectWithKeyValues:dic];
            [itemList addObject:model];
            self.itemList = itemList;
        }
    }
    return self;
}
@end
