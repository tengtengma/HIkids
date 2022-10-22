//
//  HStudentCloseView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/22.
//

#import "HStudentCloseView.h"
#import "HStudentTopView.h"
#import "HStudent.h"

@interface HStudentCloseView()

@end

@implementation HStudentCloseView

- (instancetype)initWithArray:(NSArray *)array
{
    if (self = [super init]) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12;
        self.layer.borderWidth = 2;
        
        self.topView = [[HStudentTopView alloc] init];
        
        HStudent *student = [array safeObjectAtIndex:0];
        if (student.exceptionTime) {
            [self.topView setDangerStyleWithStudentCount:array.count];
        }else{
            [self.topView setSafeStyleWithStudentCount:array.count];
        }
        [self addSubview:self.topView];

        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.mas_equalTo(PAaptation_y(40));
        }];
        
        DefineWeakSelf;
        self.topView.expandBlock = ^{
            if (weakSelf.expandBlock) {
                weakSelf.expandBlock();
            }
        };
        
        UIImageView *tempView = nil;
        for (NSInteger i = 0; i < array.count; i++) {
            
            HStudent *student = [array safeObjectAtIndex:i];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
            imageView.layer.cornerRadius = PAdaptation_x(36)/2;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth = 2;
            imageView.layer.borderColor = BWColor(108, 159, 155, 1).CGColor;
            [self addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topView.mas_bottom).offset(PAaptation_y(89)/2 - PAaptation_y(36)/2);
                if (tempView) {
                    make.left.equalTo(tempView.mas_right).offset(PAdaptation_x(6));
                }else{
                    make.left.equalTo(self).offset(PAdaptation_x(6));
                }
                make.width.mas_equalTo(PAdaptation_x(36));
                make.height.mas_equalTo(PAaptation_y(36));
            }];
            
            tempView = imageView;
        }
        
        
    }
    return self;
}

@end
