//
//  HStudentStateBottomView.m
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import "HStudentStateBottomView.h"
#import "HStudent.h"

@implementation HStudentStateBottomView

- (instancetype)initWithArray:(NSArray *)array withSafe:(BOOL)isSafe;
{
    if (self = [super init]) {
        
        UIImageView *tempView = nil;
        for (NSInteger i = 0; i < array.count; i++) {
            
            HStudent *student = [array safeObjectAtIndex:i];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
            
            if (!isSafe) {
                imageView.layer.borderColor = BWColor(255, 75, 0, 1).CGColor;

            }else{
                imageView.layer.borderColor = BWColor(108, 159, 155, 1).CGColor;
            }
            imageView.layer.cornerRadius = [BWTools getIsIpad] ? 36/2 : PAdaptation_x(36)/2;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth = 2;
            [self addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                if (tempView) {
                    make.left.equalTo(tempView.mas_right).offset(PAdaptation_x(6));
                }else{
                    make.left.equalTo(self).offset(PAdaptation_x(6));
                }
                make.width.mas_equalTo([BWTools getIsIpad] ? 36 : PAdaptation_x(36));
                make.height.mas_equalTo([BWTools getIsIpad] ? 36 : PAaptation_y(36));
            }];
            
            tempView = imageView;
        }
        
    }
    return self;
}

@end
