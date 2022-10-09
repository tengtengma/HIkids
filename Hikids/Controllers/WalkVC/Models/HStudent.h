//
//  HStudent.h
//  Hikids
//
//  Created by 马腾 on 2022/10/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HStudentDeviceInfo;

@interface HStudent : NSObject
@property (nonatomic, strong) NSString *sId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *exceptionTime;
@property (nonatomic, strong) NSString *exceptionType;
@property (nonatomic, strong) HStudentDeviceInfo *deviceInfo;
@property (nonatomic, assign) BOOL isSelected;
@end

@interface HStudentDeviceInfo : NSObject
@property (nonatomic, strong) NSString *averagestepfrequency;
@property (nonatomic, strong) NSString *averagestride;
@property (nonatomic, strong) NSString *averagevelocity;
@property (nonatomic, strong) NSString *averangheart;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *lca;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *maxhearts;
@property (nonatomic, strong) NSString *minimumhearts;
@property (nonatomic, strong) NSString *sportcalorie;
@property (nonatomic, strong) NSString *sportsteps;
@property (nonatomic, strong) NSString *sporttime;
@property (nonatomic, strong) NSString *zone;

@end

NS_ASSUME_NONNULL_END
