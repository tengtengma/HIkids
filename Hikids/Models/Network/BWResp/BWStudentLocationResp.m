//
//  BWStudentLocationResp.m
//  Hikids
//
//  Created by 马腾 on 2022/10/7.
//

#import "BWStudentLocationResp.h"

@implementation BWStudentLocationResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSMutableArray *itemList = [[NSMutableArray alloc] init];
        NSDictionary *dic = [jsonDic safeObjectForKey:@"item"];
//        HDestnationModel *model = [HDestnationModel mj_objectWithKeyValues:dic];
//        model.dId = [dic safeObjectForKey:@"id"];
//        [itemList addObject:model];
        self.itemList = itemList;

    }
    return self;
}
@end
