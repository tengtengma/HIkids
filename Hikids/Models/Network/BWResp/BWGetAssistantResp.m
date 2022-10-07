//
//  BWGetAssistantResp.m
//  Hikids
//
//  Created by 马腾 on 2022/10/7.
//

#import "BWGetAssistantResp.h"
#import "HTeacher.h"

@implementation BWGetAssistantResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSMutableArray *itemList = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [jsonDic safeObjectForKey:@"itemList"]) {
            HTeacher *model = [HTeacher mj_objectWithKeyValues:dic];
            model.tId = [dic safeObjectForKey:@"id"];
            [itemList addObject:model];
        }
        self.itemList = itemList;

    }
    return self;
}
@end
