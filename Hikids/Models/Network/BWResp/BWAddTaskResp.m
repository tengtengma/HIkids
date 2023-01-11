//
//  BWAddTaskResp.m
//  Hikids
//
//  Created by 马腾 on 2022/10/13.
//

#import "BWAddTaskResp.h"
#import "HTask.h"

@implementation BWAddTaskResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSMutableArray *itemList = [[NSMutableArray alloc] init];
        NSDictionary *dic = [jsonDic safeObjectForKey:@"item"];
        HTask *model = [HTask mj_objectWithKeyValues:dic];
        model.tId = [dic safeObjectForKey:@"id"];
        [itemList addObject:model];
        self.itemList = itemList;

    }
    return self;
}
@end
