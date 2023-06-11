//
//  HWalkReport.h
//  Hikids
//
//  Created by 马腾 on 2023/6/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWalkReport : NSObject
@property (nonatomic, strong) NSString *rId;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *dateTime;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, assign) NSInteger studentCount;
@property (nonatomic, strong) NSArray *studentList;
@property (nonatomic, strong) NSString *taskName;
@property (nonatomic, strong) NSString *teacherCount;
@property (nonatomic, strong) NSArray *teachersList;
@property (nonatomic, strong) NSString *travelCount;
@property (nonatomic, strong) NSArray *unnormalList;

@end

NS_ASSUME_NONNULL_END
