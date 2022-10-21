//
//  HWalkStudentStateView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/15.
//

#import "HWalkStudentStateView.h"
#import "HStudent.h"
#import "UIView+Frame.h"


@interface HWalkStudentStateView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) float bottomH;//下滑后距离顶部的距离
@property (nonatomic, assign) float stop_y;//tableView滑动停止的位置

@end

@implementation HWalkStudentStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.mas_equalTo(PAaptation_y(32));
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(self);
        }];
        
        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        
        self.bottomH = self.top;
        
        
    }
    return self;
}
- (void)panAction:(UIPanGestureRecognizer *)pan
{
    // 获取视图偏移量
    CGPoint point = [pan translationInView:self];
    // stop_y是tableview的偏移量，当tableview的偏移量大于0时则不去处理视图滑动的事件
    if (self.stop_y>0) {
        // 将视频偏移量重置为0
        [pan setTranslation:CGPointMake(0, 0) inView:self];
        return;
    }
    
    // self.top是视图距离顶部的距离
    self.top += point.y;
    if (self.top < self.topH) {
        self.top = self.topH;
    }
    
    // self.bottomH是视图在底部时距离顶部的距离
    if (self.top > self.bottomH) {
        self.top = self.bottomH;
    }
    
    // 在滑动手势结束时判断滑动视图距离顶部的距离是否超过了屏幕的一半，如果超过了一半就往下滑到底部
    // 如果小于一半就往上滑到顶部
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        
        // 滑动速度
        CGPoint velocity = [pan velocityInView:self];
        CGFloat speed = 350;
        if (velocity.y < -speed) {
            [self goTop];
            [pan setTranslation:CGPointMake(0, 0) inView:self];
            return;
        }else if (velocity.y > speed){
            [self goBack];
            [pan setTranslation:CGPointMake(0, 0) inView:self];
            return;
        }
        
        if (self.top > SCREEN_HEIGHT/2) {
            [self goBack];
        }else{
            [self goTop];
        }
    }
    
    [pan setTranslation:CGPointMake(0, 0) inView:self];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat currentPostion = scrollView.contentOffset.y;
//    self.stop_y = currentPostion;
//}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentPostion = scrollView.contentOffset.y;
    self.stop_y = currentPostion;
    
//    if (self.top>self.topH) {
//        [scrollView setContentOffset:CGPointMake(0, 0)];
//    }
}
- (void)goTop {
    [UIView animateWithDuration:0.5 animations:^{
        self.top = self.topH;
    }completion:^(BOOL finished) {
        self.tableView.userInteractionEnabled = YES;
    }];
}

- (void)goBack {
    [UIView animateWithDuration:0.5 animations:^{
        self.top = self.bottomH;
    }completion:^(BOOL finished) {
        self.tableView.userInteractionEnabled = NO;
    }];
}
#pragma mark - UITableViewDataSource -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PAaptation_y(129);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.exceptArray.count == 0) {
        return 2;
    }
    return 3;
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
    

    UIView *bgView = [[UIView alloc] init];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 12;
    bgView.layer.borderWidth = 2;
    bgView.layer.borderColor = BWColor(0.133, 0.133, 0.133, 1.0).CGColor;
    [cell.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
        make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
        make.bottom.equalTo(cell.contentView.mas_bottom).offset(-PAaptation_y(16));
    }];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = BWColor(255, 75, 0, 1);
    [bgView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(bgView);
        make.width.equalTo(bgView);
        make.height.mas_equalTo(PAaptation_y(40));
    }];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    [bgView addSubview:iconView];
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
    expandBtn.tag = indexPath.row+1000;
    [expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
    [expandBtn setImage:[UIImage imageNamed:@"triangle_small.png"] forState:UIControlStateNormal];
    [topView addSubview:expandBtn];
    [expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(topView.mas_right).offset(-PAdaptation_x(11.5));
        make.width.mas_equalTo(PAdaptation_x(21));
        make.height.mas_equalTo(PAaptation_y(24));
    }];
    
    if (self.exceptArray.count != 0) {
        
        if (indexPath.row == 0) {
            [iconView setImage:[UIImage imageNamed:@"dangerIcon.png"]];
            stateLabel.text = @"危険";
            numberLabel.text = [NSString stringWithFormat:@"%ld人",self.exceptArray.count];
            topView.backgroundColor = BWColor(255, 75, 0, 1);
            numberLabel.textColor = BWColor(255, 75, 0, 1);
            numberBg.backgroundColor = [UIColor whiteColor];
            [self createStudentViewWithArray:self.exceptArray topView:topView bgView:bgView];
        }else if(indexPath.row == 1){
            [iconView setImage:[UIImage imageNamed:@"safeIcon.png"]];
            stateLabel.text = @"安全";
            numberLabel.text = [NSString stringWithFormat:@"%ld人",self.nomalArray.count];
            numberBg.backgroundColor = BWColor(5, 70, 11, 1);
            topView.backgroundColor = BWColor(0, 176, 107, 1);
            [self createStudentViewWithArray:self.nomalArray topView:topView bgView:bgView];
        }else{
            
            [bgView removeFromSuperview];
            
            stateLabel.text = @"危険";
            numberLabel.text = [NSString stringWithFormat:@"%ld人",self.exceptArray.count];
            topView.backgroundColor = BWColor(255, 75, 0, 1);
            numberLabel.textColor = BWColor(255, 75, 0, 1);
            numberBg.backgroundColor = [UIColor whiteColor];
            
            
            UIImageView *walkEndView = [[UIImageView alloc] init];
            [walkEndView setImage:[UIImage imageNamed:@"walkEnd.png"]];
            walkEndView.userInteractionEnabled = YES;
            [cell.contentView addSubview:walkEndView];
            
            [walkEndView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell.contentView);
                make.width.mas_equalTo(PAdaptation_x(240));
                make.height.mas_equalTo(PAaptation_y(47));
            }];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(walkEndAction)];
            [walkEndView addGestureRecognizer:tap];
        }
        

    }else{
        
        if (indexPath.row == 0) {
            
            [iconView setImage:[UIImage imageNamed:@"safeIcon.png"]];
            stateLabel.text = @"安全";
            numberLabel.text = [NSString stringWithFormat:@"%ld人",self.nomalArray.count];
            numberBg.backgroundColor = BWColor(5, 70, 11, 1);
            topView.backgroundColor = BWColor(0, 176, 107, 1);
            [self createStudentViewWithArray:self.nomalArray topView:topView bgView:bgView];
            
            
        }else{
            
            [bgView removeFromSuperview];

            
            UIImageView *walkEndView = [[UIImageView alloc] init];
            [walkEndView setImage:[UIImage imageNamed:@"walkEnd.png"]];
            walkEndView.userInteractionEnabled = YES;
            [cell.contentView addSubview:walkEndView];
            
            [walkEndView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell.contentView);
                make.width.mas_equalTo(PAdaptation_x(240));
                make.height.mas_equalTo(PAaptation_y(47));
            }];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(walkEndAction)];
            [walkEndView addGestureRecognizer:tap];
        }
    }
    
    
    
    
    return cell;
    
}
- (void)walkEndAction
{
    if (self.walkEndBlock) {
        self.walkEndBlock();
    }
}
- (void)clickTopViewAction
{
    if (self.ShowOrHideWalkStateViewBlock) {
        self.ShowOrHideWalkStateViewBlock();
    }
}
- (void)clickExpandAction:(UIButton *)button
{
    if (self.closeExpandBlock) {
        self.closeExpandBlock();
    }
}
- (void)createStudentViewWithArray:(NSArray *)array topView:(UIView *)topView bgView:(UIView *)bgView
{
    UIImageView *tempView = nil;
    for (NSInteger i = 0; i < array.count; i++) {
        
        HStudent *student = [array safeObjectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
        imageView.layer.cornerRadius = PAdaptation_x(36)/2;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 2;
        imageView.layer.borderColor = BWColor(108, 159, 155, 1).CGColor;
        [bgView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).offset(PAaptation_y(12));
            if (tempView) {
                make.left.equalTo(tempView.mas_right).offset(PAdaptation_x(6));
            }else{
                make.left.equalTo(bgView).offset(PAdaptation_x(6));
            }
            make.width.mas_equalTo(PAdaptation_x(36));
            make.height.mas_equalTo(PAaptation_y(36));
        }];
        
        tempView = imageView;
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
        _tableView.bounces = NO;
        _tableView.userInteractionEnabled = NO;
    }
    return _tableView;
}
- (UIImageView *)topView
{
    if (!_topView) {
        _topView = [[UIImageView alloc] init];
        _topView.userInteractionEnabled = YES;
        [_topView setImage:[UIImage imageNamed:@"menu_header.png"]];
        
        UIImageView *lineView = [[UIImageView alloc] init];
        [lineView setImage:[UIImage imageNamed:@"line.png"]];
        [_topView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_topView);
            make.width.mas_equalTo(PAdaptation_x(64));
            make.height.mas_equalTo(PAaptation_y(6));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTopViewAction)];
        [_topView addGestureRecognizer:tap];
    }
    return _topView;
    
}
@end
