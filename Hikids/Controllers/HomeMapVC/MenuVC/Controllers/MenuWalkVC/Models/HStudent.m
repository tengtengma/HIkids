//
//  HStudent.m
//  Hikids
//
//  Created by 马腾 on 2022/10/6.
//

#import "HStudent.h"

@implementation HStudent

- (HStudentDeviceInfo *)deviceInfo
{
    if (!_deviceInfo) {
        _deviceInfo = [[HStudentDeviceInfo alloc] init];
    }
    return _deviceInfo;
}
@end

@implementation HStudentDeviceInfo

@end
