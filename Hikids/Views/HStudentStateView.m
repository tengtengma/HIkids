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
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIView *numberBg;
@property (nonatomic, strong) UILabel *numberLabel;

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

        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = BWColor(255, 75, 0, 1);
        [headerView addSubview:self.topView];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView);
            make.left.equalTo(headerView);
            make.width.equalTo(headerView);
            make.height.mas_equalTo(PAaptation_y(47));
        }];
        
        self.iconView = [[UIImageView alloc] init];
        [self.iconView setImage:[UIImage imageNamed:@"safeIcon.png"]];
        [headerView addSubview:self.iconView];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.left.equalTo(self.topView).offset(PAdaptation_x(16));
            make.width.mas_equalTo(PAdaptation_x(24));
            make.height.mas_equalTo(PAaptation_y(24));
        }];
        
        self.stateLabel = [[UILabel alloc] init];
        self.stateLabel.textColor = [UIColor whiteColor];
        self.stateLabel.font = [UIFont systemFontOfSize:20];
        [self.topView addSubview:self.stateLabel];
        
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.left.equalTo(self.iconView.mas_right).offset(PAdaptation_x(10));
        }];
        
        self.numberBg = [[UILabel alloc] init];
        self.numberBg.backgroundColor = [UIColor whiteColor];
        [self.topView addSubview:self.numberBg];
        
        [self.numberBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconView);
            make.left.equalTo(self.stateLabel.mas_right).offset(PAdaptation_x(10));
            make.width.mas_equalTo(PAdaptation_x(59));
            make.height.mas_equalTo(PAaptation_y(26));
        }];
        
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.font = [UIFont systemFontOfSize:16];
        self.numberLabel.textColor = [UIColor whiteColor];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:self.numberLabel];
        
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.numberBg);
        }];
        
        UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
        [expandBtn setImage:[UIImage imageNamed:@"triangle_small.png"] forState:UIControlStateNormal];
        [self.topView addSubview:expandBtn];
        
        [expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.right.equalTo(self.topView.mas_right).offset(-PAdaptation_x(11.5));
            make.width.mas_equalTo(PAdaptation_x(21));
            make.height.mas_equalTo(PAaptation_y(24));
        }];
        

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
    if (self.isSafe) {
        [self.iconView setImage:[UIImage imageNamed:@"safeIcon.png"]];
        self.stateLabel.text = @"安全";
        self.numberLabel.text = [NSString stringWithFormat:@"%ld人",self.array.count];
        self.numberLabel.textColor = [UIColor whiteColor];
        self.numberBg.backgroundColor = BWColor(5, 70, 11, 1);
        self.topView.backgroundColor = BWColor(0, 176, 107, 1);
    }else{
        [self.iconView setImage:[UIImage imageNamed:@"dangerIcon.png"]];
        self.stateLabel.text = @"危険";
        self.numberLabel.text = [NSString stringWithFormat:@"%ld人",self.array.count];
        self.numberLabel.textColor = BWColor(255, 75, 0, 1);
        self.topView.backgroundColor = BWColor(255, 75, 0, 1);
        self.numberBg.backgroundColor = [UIColor whiteColor];
    }

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
