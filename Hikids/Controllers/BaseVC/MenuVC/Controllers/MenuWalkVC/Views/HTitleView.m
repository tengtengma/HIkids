//
//  HTitleView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/6.
//

#import "HTitleView.h"
#import "HTeacher.h"
#import "HTime.h"

@interface HTitleView()
@property (nonatomic, strong) UILabel *label;

@end

@implementation HTitleView

- (instancetype)init
{
    if (self = [super init]) {

        self.layer.cornerRadius = 8;
        self.layer.borderWidth = 1;
        self.layer.borderColor = BWColor(34, 34, 34, 1.0).CGColor;
        
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}
- (void)setupWithModel:(id)model
{
    if ([model isKindOfClass:[HTeacher class]]) {
        HTeacher *teacher = (HTeacher *)model;
        self.label.text = teacher.name;
    }
    if ([model isKindOfClass:[HTime class]]) {
        HTime *time = (HTime *)model;
        self.label.text = time.name;
    }
}
- (void)cellNomal
{
    self.label.textColor = [UIColor blackColor];
    self.layer.borderColor = BWColor(34, 34, 34, 1.0).CGColor;
    self.backgroundColor = [UIColor whiteColor];
    
}
- (void)cellSelected
{
    self.label.textColor = BWColor(191, 76, 13, 1);
    self.layer.borderColor = BWColor(191, 76, 13, 1).CGColor;
    self.backgroundColor = BWColor(244, 207, 184, 1);
}
#pragma mark - LazyLoad -
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
//        _label.layer.cornerRadius = 8;
//        _label.layer.borderWidth = 1;
//        _label.layer.borderColor = BWColor(34, 34, 34, 1.0).CGColor;
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont boldSystemFontOfSize:16];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
@end
