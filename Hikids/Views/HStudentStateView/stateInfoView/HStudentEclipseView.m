//
//  HStudentEclipseView.m
//  Hikids
//
//  Created by 马腾 on 2023/6/24.
//

#import "HStudentEclipseView.h"
#import "HStudent.h"
@implementation HStudentEclipseView

- (instancetype)initWithFrame:(CGRect)frame withStudent:(HStudent *)student withBgImage:(UIImage *)bgImg
{
    if(self = [super initWithFrame:frame]){
        
        UIImageView *ellipseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        ellipseView.tag = 1000;
        [ellipseView setImage:bgImg];
        [self addSubview:ellipseView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 - PAdaptation_x(40)/2, frame.size.height/2 - PAaptation_y(40)/2, PAdaptation_x(40), PAaptation_y(40))];
        imageView.layer.cornerRadius = PAaptation_y(40)/2;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 4;
        imageView.layer.borderColor = student.exceptionTime.length == 0 ? BWColor(79, 173, 113, 1).CGColor : BWColor(255, 75, 0, 1).CGColor;
        [imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
        [ellipseView addSubview:imageView];
        
    }
    return self;
}
- (void)setDefaultBgImage:(UIImage *)img
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:1000];
    [imageView setImage:img];
}
@end
