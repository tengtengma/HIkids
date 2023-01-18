//
//  HDestnationModel.h
//  Hikids
//
//  Created by 马腾 on 2022/10/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDestnationModel : NSObject
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *fence;
@property (nonatomic, strong) NSString *dId;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, assign) BOOL isSelected;


@end

NS_ASSUME_NONNULL_END
