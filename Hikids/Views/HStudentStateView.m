//
//  HStudentStateView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/11.
//

#import "HStudentStateView.h"
#import "HStudent.h"

@interface HStudentStateView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HStudentStateView

- (instancetype)init
{
    if (self = [super init]) {
        
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:headerView];
        
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(PAdaptation_x(24));
            make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
            make.height.mas_equalTo(PAaptation_y(47));
        }];

        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = BWColor(255, 75, 0, 1);
        [headerView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView);
            make.left.equalTo(headerView);
            make.width.equalTo(headerView);
            make.height.mas_equalTo(PAaptation_y(47));
        }];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.backgroundColor = [UIColor redColor];
        [headerView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView);
            make.left.equalTo(topView).offset(PAdaptation_x(16));
            make.width.mas_equalTo(PAdaptation_x(24));
            make.height.mas_equalTo(PAaptation_y(24));
        }];
        
        UILabel *stateLabel = [[UILabel alloc] init];
        stateLabel.textColor = [UIColor whiteColor];
        stateLabel.font = [UIFont systemFontOfSize:20];
        [topView addSubview:stateLabel];
        
        [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView);
            make.left.equalTo(iconView.mas_right).offset(PAdaptation_x(10));
        }];
        
        UIView *numberBg = [[UILabel alloc] init];
        numberBg.backgroundColor = [UIColor whiteColor];
        [topView addSubview:numberBg];
        [numberBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iconView);
            make.left.equalTo(stateLabel.mas_right).offset(PAdaptation_x(10));
            make.width.mas_equalTo(PAdaptation_x(59));
            make.height.mas_equalTo(PAaptation_y(26));
        }];
        
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.font = [UIFont systemFontOfSize:16];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:numberLabel];
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(numberBg);
        }];
        
        UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
        [expandBtn setImage:[UIImage imageNamed:@"triangle_small.png"] forState:UIControlStateNormal];
        [topView addSubview:expandBtn];
        [expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView);
            make.right.equalTo(topView.mas_right).offset(-PAdaptation_x(11.5));
            make.width.mas_equalTo(PAdaptation_x(21));
            make.height.mas_equalTo(PAaptation_y(24));
        }];
        
        stateLabel.text = @"安全";
        numberLabel.text = [NSString stringWithFormat:@"%ld人",self.array.count];
        numberBg.backgroundColor = BWColor(5, 70, 11, 1);
        topView.backgroundColor = BWColor(0, 176, 107, 1);
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_bottom);
            make.left.equalTo(headerView);
            make.width.equalTo(headerView);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
    }
    return self;
}

#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (id v in cell.contentView.subviews)
        [v removeFromSuperview];
    
    HStudent *student = [self.array safeObjectAtIndex:indexPath.row];
    
    UIImageView *headerView = [[UIImageView alloc] init];
    [headerView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
    [cell.contentView addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.width.mas_equalTo(PAdaptation_x(58));
        make.height.mas_equalTo(PAaptation_y(58));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = student.name;
    [cell.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.left.equalTo(headerView.mas_right).offset(PAdaptation_x(12));
    }];
    
    
    return cell;
    
}
- (void)clickExpandAction:(UIButton *)button
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}

- (void)tableReload
{
    [self.tableView reloadData];
}
#pragma mark - LazyLoad -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.layer.masksToBounds = YES;
//        _tableView.layer.cornerRadius = 12;
//        _tableView.layer.borderWidth = 2;
//        _tableView.layer.borderColor = BWColor(0.133, 0.133, 0.133, 1.0).CGColor;
    }
    return _tableView;
}
@end
