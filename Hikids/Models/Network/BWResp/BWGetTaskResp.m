//
//  BWGetTaskResp.m
//  Hikids
//
//  Created by 马腾 on 2022/10/17.
//

#import "BWGetTaskResp.h"
#import "HWalkTask.h"

@implementation BWGetTaskResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSMutableArray *itemList = [[NSMutableArray alloc] init];

        NSDictionary *dic = [jsonDic safeObjectForKey:@"item"];
        HWalkTask *model = [HWalkTask mj_objectWithKeyValues:dic];
        model.tId = [dic safeObjectForKey:@"id"];
        [itemList addObject:model];
        self.itemList = itemList;

    }
    return self;
}
@end
