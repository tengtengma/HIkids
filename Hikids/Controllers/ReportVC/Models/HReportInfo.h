//
//  HReportInfo.h
//  Hikids
//
//  Created by 马腾 on 2023/1/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//报告详情页模型
@interface HReportInfo : NSObject
@property (nonatomic, strong) NSArray *assistantList;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSArray *kidsList;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSArray *unnormalList;

@end

NS_ASSUME_NONNULL_END
