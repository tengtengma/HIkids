//
//  HBaseMenuView.m
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import "HBaseMenuView.h"
#import "HSmallCardView.h"
#import "UIView+Frame.h"

@interface HBaseMenuView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,assign) float bottomH;//下滑后距离顶部的距离
@property (nonatomic,assign) float stop_y;//tableView滑动停止的位置
@end

@implementation HBaseMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor clearColor];

        [self addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(PAaptation_y(121));
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
                
        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        

        [self createHeaderView];
        
        self.bottomH = self.top;

       
    }
    return self;
    
}

- (void)createHeaderView
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, PAaptation_y(121))];
    headerView.backgroundColor = [UIColor clearColor];
    [self addSubview:headerView];
    
    self.smallView = [[HSmallCardView alloc] initWithFrame:CGRectMake(PAdaptation_x(10),0 , PAdaptation_x(115), PAaptation_y(79))];
    [headerView addSubview:self.smallView ];
    
    DefineWeakSelf;
    self.smallView .clickBlock = ^{
        if (weakSelf.openReport) {
            weakSelf.openReport();
        }
    };
    
    self.gpsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gpsButton setFrame:CGRectMake(headerView.frame.size.width - PAdaptation_x(50) , headerView.frame.size.height - PAaptation_y(82), PAdaptation_x(40), PAaptation_y(40))];
    [self.gpsButton setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    [self.gpsButton addTarget:self action:@selector(clickGpsAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.gpsButton];

    UIImageView *topView = [[UIImageView alloc] init];
    [topView setImage:[UIImage imageNamed:@"menu_header.png"]];
    [headerView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(PAaptation_y(90));
        make.left.equalTo(headerView);
        make.width.equalTo(headerView);
        make.height.mas_equalTo(PAaptation_y(32));
    }];
    
    UIImageView *lineView = [[UIImageView alloc] init];
    [lineView setImage:[UIImage imageNamed:@"line.png"]];
    [headerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topView);
        make.width.mas_equalTo(PAdaptation_x(64));
        make.height.mas_equalTo(PAaptation_y(6));
    }];
    
}
- (void)clickGpsAction
{
    if (self.gpsBlock) {
        self.gpsBlock();
    }
}
#pragma mark - 滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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
            NSLog(@"11111111");
            [self goBack];
            [pan setTranslation:CGPointMake(0, 0) inView:self];
            return;
        }
        
        NSLog(@"top=%f",self.top);
        NSLog(@"屏幕高度三=%f",SCREEN_HEIGHT/3);

        if (self.top > SCREEN_HEIGHT/2) {
            [self goBack];
        }else{
            [self goTop];
        }
    }
    
    [pan setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)goTop {
    DefineWeakSelf;
    [UIView animateWithDuration:0.5 animations:^{
        self.top = self.topH;
    }completion:^(BOOL finished) {
        self.tableView.scrollEnabled = YES;
        if (weakSelf.toTopBlock) {
            weakSelf.toTopBlock();
        }
    }];
}

- (void)goBack {
    
    DefineWeakSelf;
    [UIView animateWithDuration:0.5 animations:^{
        self.top = self.bottomH;
    }completion:^(BOOL finished) {
        self.tableView.scrollEnabled = NO;
        if (weakSelf.toBottomBlock) {
            weakSelf.toBottomBlock();
        }
    }];
}

- (void)scrollToMiddle
{
//    NSLog(@"%f",self.contentOffset.y);
//
//    //先设置为窗口用户自己展开时 为了防止窗口来回展开收起
//    if (self.contentOffset.y > 0) {
//        return;
//    }
//
//    [self scrollRectToVisible:CGRectMake(0,  0, SCREEN_WIDTH, PAaptation_y(500)) animated:YES];
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
//    NSLog(@"point=%@",NSStringFromCGPoint(point));
//
//    NSLog(@"y=%f",self.contentOffset.y);
    
    if (point.y<0) {
        return nil;
    }

    return  [super hitTest:point withEvent:event];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentPostion = scrollView.contentOffset.y;
    self.stop_y = currentPostion;
        
    if (scrollView.contentOffset.y <= 0) {
        self.tableView.scrollEnabled = NO;//tableView内容滚动到顶部时 锁住
    }

    
//    if (self.top>self.topH) {
//        [scrollView setContentOffset:CGPointMake(0, 0)];
//    }
}
#pragma mark - LazyLoad -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;//上来默认不许滚动
    }
    return _tableView;
}
@end
