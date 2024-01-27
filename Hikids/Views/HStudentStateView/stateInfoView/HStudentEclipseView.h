//
//  HStudentEclipseView.h
//  Hikids
//
//  Created by 马腾 on 2023/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HStudent;

@interface HStudentEclipseView : UIView
@property (nonatomic, assign) BOOL isExcept;

- (instancetype)initWithFrame:(CGRect)frame withStudent:(HStudent *)student;
//- (void)setBgImage:(UIImage *)img;
@end

NS_ASSUME_NONNULL_END
