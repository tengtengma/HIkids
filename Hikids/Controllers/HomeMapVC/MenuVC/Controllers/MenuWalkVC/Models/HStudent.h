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
@property (nonatomic, strong) NSString *heartRate;//4.14 先单独新增一个数据
@property (nonatomic, assign) BOOL isSelected;
@end

@interface HStudentDeviceInfo : NSObject
@property (nonatomic, strong) NSString *batteryLevel;
@property (nonatomic, strong) NSString *chargingStatus;
@property (nonatomic, strong) NSString *movingStatgus;
@property (nonatomic, strong) NSString *averangheart;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *currentLocation;

//item.normalKids.data.batteryLevel    string    电池残量（百分比）
//item.normalKids.data.chargingStatus    string    充电状态 0: not charging, 1:charging, 2:full charge
//item.normalKids.data.movingStatgus    string    移动状态 0: staing, 1: nomal moving, 2: high speed moving
//item.normalKids.data.connectionStatus    string    连接状态 0: no connect cellular, 1: connect cellular, 2: connect platform
//item.normalKids.data.longitude    string    最新经度
//item.normalKids.data.latitude    string    最新纬度
//item.normalKids.data.currentLocation

@end

NS_ASSUME_NONNULL_END
