//
//  BWGetWalkReportResp.m
//  Hikids
//
//  Created by 马腾 on 2023/6/11.
//

#import "BWGetWalkReportResp.h"
#import "HWalkReport.h"

@implementation BWGetWalkReportResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSMutableArray *itemList = [[NSMutableArray alloc] init];

        NSDictionary *dic = [jsonDic safeObjectForKey:@"item"];
        if (dic) {
            HWalkReport *model = [HWalkReport mj_objectWithKeyValues:dic];
            [itemList addObject:model];
            self.itemList = itemList;
        }
    }
    return self;
}
@end
