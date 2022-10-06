//
//  BWGetStudentResp.m
//  Hikids
//
//  Created by 马腾 on 2022/10/6.
//

#import "BWGetStudentResp.h"
#import "HStudent.h"

@implementation BWGetStudentResp
- (id)initWithJSONDictionary:(NSDictionary *)jsonDic
{
    if (self = [super initWithJSONDictionary:jsonDic]) {
        
        NSMutableArray *itemList = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [jsonDic safeObjectForKey:@"itemList"]) {
            HStudent *model = [HStudent mj_objectWithKeyValues:dic];
            model.sId = [dic safeObjectForKey:@"id"];
            [itemList addObject:model];
        }
        self.itemList = itemList;

    }
    return self;
}
@end
