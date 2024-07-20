//
//  BWStudentLocationResp.h
//  Hikids
//
//  Created by 马腾 on 2022/10/7.
//

#import "BWBaseResp.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWStudentLocationResp : BWBaseResp
@property (nonatomic, strong) NSArray *exceptionKids;
@property (nonatomic, strong) NSArray *normalKids;
@property (nonatomic, assign) BOOL isSafe;
@property (nonatomic, copy) NSString *kinFence;     //园区围栏信息
@property (nonatomic, copy) NSString *desFence;     //目的地围栏信息
@property (nonatomic, assign) float deviceLastUpload;     //最后更新时间
@property (nonatomic, strong) NSNumber *changeStatus;//当前任务状态 0走出目的地 1进入目的地 -1无变化


- (id)initWithJSONDictionary:(NSDictionary *)jsonDic;

@end

NS_ASSUME_NONNULL_END
