//
//  BWGetTaskCalendarResp.m
//  Hikids
//
//  Created by 马腾 on 2023/1/14.
//

#import "BWGetTaskCalendarResp.h"
#import "HReport.h"

@implementation BWGetTaskCalendarResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSMutableArray *itemList = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in [jsonDic safeObjectForKey:@"itemList"]) {
            HReport *model = [HReport mj_objectWithKeyValues:dic];
            model.rId = [dic safeObjectForKey:@"id"];
            [itemList addObject:model];
        }
        self.itemList = itemList;

    }
    return self;
}
@end

@implementation BWGetTaskMonthCalendarResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSMutableArray *itemList = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in [jsonDic safeObjectForKey:@"itemList"]) {
            HReport *model = [HReport mj_objectWithKeyValues:dic];
            model.rId = [dic safeObjectForKey:@"id"];
            [itemList addObject:model];
        }
        self.itemList = itemList;
    }
    return self;
}
@end
