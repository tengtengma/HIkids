//
//  HStudentEclipseView.m
//  Hikids
//
//  Created by 马腾 on 2023/6/24.
//

#import "HStudentEclipseView.h"
#import "HStudent.h"

@interface HStudentEclipseView()
@property (nonatomic, strong) UIImageView *ellipseView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HStudentEclipseView

- (instancetype)initWithFrame:(CGRect)frame withStudent:(HStudent *)student
{
    if(self = [super initWithFrame:frame]){
        
        [self addSubview:self.ellipseView];
        
        self.imageView.layer.borderColor = student.exceptionTime.length == 0 ? BWColor(79, 173, 113, 1).CGColor : BWColor(255, 75, 0, 1).CGColor;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
        [self.ellipseView addSubview:self.imageView];
        
    }
    return self;
}
- (void)setBgImage:(UIImage *)img
{
//    UIImageView *imageView = (UIImageView *)[self viewWithTag:1000];
    [self.ellipseView setImage:img];
}

#pragma mark - LazyLoad -
- (UIImageView *)ellipseView
{
    if(!_ellipseView){
        _ellipseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _ellipseView;
}
- (UIImageView *)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - PAdaptation_x(40)/2, self.frame.size.height/2 - PAaptation_y(40)/2, PAdaptation_x(40), PAaptation_y(40))];
        _imageView.layer.cornerRadius = PAaptation_y(40)/2;
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.borderWidth = 4;
    }
    return _imageView;
}
@end
