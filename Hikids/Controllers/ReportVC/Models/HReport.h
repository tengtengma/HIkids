//
//  HReport.h
//  Hikids
//
//  Created by 马腾 on 2023/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//报告列表页模型
@interface HReport : NSObject
@property (nonatomic, strong) NSArray *assistants;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *createBy;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *endType;
@property (nonatomic, strong) NSString *rId;
@property (nonatomic, strong) NSArray *kids;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *planTime;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
