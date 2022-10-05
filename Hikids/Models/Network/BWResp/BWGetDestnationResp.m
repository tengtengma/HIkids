//
//  BWGetDestnationResp.m
//  Hikids
//
//  Created by 马腾 on 2022/10/5.
//

#import "BWGetDestnationResp.h"
#import "HDestnationModel.h"

@implementation BWGetDestnationResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSMutableArray *itemList = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [jsonDic safeObjectForKey:@"itemList"]) {
            HDestnationModel *model = [HDestnationModel mj_objectWithKeyValues:dic];
            model.dId = [dic safeObjectForKey:@"id"];
            [itemList addObject:model];
        }
        self.itemList = itemList;

    }
    return self;
}
@end
