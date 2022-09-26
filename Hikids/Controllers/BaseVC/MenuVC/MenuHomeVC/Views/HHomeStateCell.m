//
//  HHomeStateCell.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HHomeStateCell.h"



@interface HHomeStateCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *expandBtn;


@end

@implementation HHomeStateCell

- (void)setupCellWithModel:(id)model withStyle:(CellType)cellType
{
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}


#pragma mark - LazyLoad -
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 12;
        _bgView.layer.borderWidth = 2;
        _bgView.layer.borderColor = BWColor(0.133, 0.133, 0.133, 1.0).CGColor;
    }
    return _bgView;
}


@end
