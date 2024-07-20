//
//  HStudentEclipseView.m
//  Hikids
//
//  Created by 马腾 on 2023/6/24.
//

#import "HStudentEclipseView.h"
#import "HStudent.h"

@interface HStudentEclipseView()
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HStudentEclipseView

- (instancetype)initWithFrame:(CGRect)frame withStudent:(HStudent *)student
{
    if(self = [super initWithFrame:frame]){
        
        
        if (student.exceptionTime.length == 0) {
            self.imageView.layer.borderColor = student.exceptionTime.length == 0 ? BWColor(79, 173, 113, 1).CGColor : BWColor(255, 75, 0, 1).CGColor;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
            self.imageView.layer.cornerRadius = PAaptation_y(58)/2;
            self.imageView.layer.masksToBounds = YES;
            self.imageView.layer.borderWidth = 2;
        }else{
            [self.imageView setImage:[UIImage imageNamed:@"pin_danger.png"]];

        }
        [self addSubview:self.imageView];
        
    }
    return self;
}
//- (void)setBgImage:(UIImage *)img
//{
////    UIImageView *imageView = (UIImageView *)[self viewWithTag:1000];
//    [self.ellipseView setImage:img];
//}

#pragma mark - LazyLoad -
- (UIImageView *)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, self.bounds.size.width, self.bounds.size.height)];

    }
    return _imageView;
}
@end
