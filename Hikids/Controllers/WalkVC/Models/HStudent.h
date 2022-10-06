//
//  HStudent.h
//  Hikids
//
//  Created by 马腾 on 2022/10/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HStudent : NSObject
@property (nonatomic, strong) NSString *sId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
