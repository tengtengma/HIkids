//
//  BWAddTaskReq.m
//  Hikids
//
//  Created by 马腾 on 2022/10/13.
//

#import "BWAddTaskReq.h"

@implementation BWAddTaskReq
- (NSURL *)url
{
    
    NSString *str = [NSString stringWithFormat:@"%@%@",BaseURL,TaskAddURL];
    return [NSURL URLWithString:str];
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *dic = [super getRequestParametersDictionary];
    
    if (self.type) {
        [dic setObject:self.type forKey:@"type"];
    }
    if (self.planTime) {
        [dic setObject:[NSNumber numberWithLong:self.planTime.longLongValue] forKey:@"planTime"];
    }
    if (self.assistants) {
        [dic setObject:self.assistants forKey:@"assistants"];
    }
    if (self.kids) {
        [dic setObject:self.kids forKey:@"kids"];
    }
    if (self.destinationId) {
        [dic setObject:self.destinationId forKey:@"destinationId"];
    }
    if (self.remark) {
        [dic setObject:self.remark forKey:@"remark"];
    }

    return dic;
}
@end
