//
//  HBaseMenuView.m
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import "HBaseMenuView.h"
#import "HSmallCardView.h"


#define kTabbarSafeBottomMargin  34
#define kStatusBarAndNavigationBarHeight  88.0

//当级别为Mid中间时的窗口大小比例
#define mapWindowHeight  ([[UIScreen mainScreen] bounds].size.height - kStatusBarAndNavigationBarHeight) * 0.4
#define bottomBarHeight  kTabbarSafeBottomMargin + 130

//底层tableView
#define contentOffsetMinY  bottomBarHeight
#define contentOffsetMidY  contentOffsetMaxY - mapWindowHeight
#define contentOffsetMaxY  [[UIScreen mainScreen] bounds].size.height - kStatusBarAndNavigationBarHeight - bottomBarHeight


@interface HBaseMenuView()<UIScrollViewDelegate>
@property (nonatomic, strong) HBaseScrollView *scrollView;
@property (nonatomic, assign) BOOL scrollViewMove;
@property (nonatomic, assign) BOOL tableViewMove;
@property (nonatomic, strong) NSArray *currentOffsetArray;


@end

@implementation HBaseMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.scrollViewMove = YES;
        self.tableViewMove = NO;
        self.currentOffsetArray = @[[NSNumber numberWithFloat:contentOffsetMinY], [NSNumber numberWithFloat:contentOffsetMidY], [NSNumber numberWithFloat:contentOffsetMaxY]];

        
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.tableView];
        
        //设定底层scrollView的滑动起始点
//        self.scrollView.contentOffset.y = contentOffsetMidY;
        self.scrollView.contentOffset = CGPointMake(0, contentOffsetMinY);

        [self createHeaderView];
    }
    return self;
    
}

- (void)createHeaderView
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, PAaptation_y(121))];
    self.tableView.tableHeaderView = headerView;
    
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
- (void)scrollToMiddle
{
//    NSLog(@"%f",self.tableView.contentOffset.y);
//
//    //先设置为窗口用户自己展开时 为了防止窗口来回展开收起
//    if (self.tableView.contentOffset.y > 0) {
//        return;
//    }
//
//    [self.tableView scrollRectToVisible:CGRectMake(0,  0, SCREEN_WIDTH, PAaptation_y(500)) animated:YES];
}


#pragma mark - UIScrollViewDelegate -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //这里主要解决滑动冲突
    if (scrollView == self.scrollView) {
        
        //当contentOffset大于设定最大偏移量时，固定偏移量，同时标记为上层tableView可以滑动，底层不可滑动。
        //这里不能加上”=“，因为有等号时，向上弹性滑动就会导致tableView自动向上跑（这里不要这种效果）。而且当正好上边对齐时，两层不能触发滚动。所以只是">"就好
        if (scrollView.contentOffset.y > contentOffsetMaxY) {
            
            scrollView.contentOffset = CGPointMake(0, contentOffsetMaxY);
            
            self.scrollViewMove = NO;
            self.tableViewMove = YES;
        }
        //当底层不能滚动时，设置其偏移量
        if (!self.scrollViewMove) {
            scrollView.contentOffset = CGPointMake(0, contentOffsetMaxY);
        }
        
    }else if (scrollView == self.tableView) {
        
        
        //同底层的滚动View类似操作。
        if (scrollView.contentOffset.y <= 0) {
            
            scrollView.contentOffset = CGPointMake(0, 0);
            self.tableViewMove = NO;
            self.scrollViewMove = YES;
        }
        
        if (!self.tableViewMove) {
            scrollView.contentOffset = CGPointMake(0, 0);
            
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == self.scrollView) {
        
        //如果滑动减速结束时，就是当滑动速度为0时，若停止位置，不在所在的三段级别位置时，则将其指定跳转到中间级别的位置上
        //这么做是因为内层tableView滑动减速结束后，可能会导致父层的scrollView不在三段级别上，所以才做了如下处理。
        CGFloat currentOffsetY = scrollView.contentOffset.y;
        
        if (![self.currentOffsetArray containsObject:[NSNumber numberWithFloat:currentOffsetY]]) {
            
            //动画到指定位置
            [self scrollView:scrollView initialSpringVelocity:8 movePointY:contentOffsetMidY isAnimate:YES];

        }
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    //不是底层scrollView，则退出！
    if (scrollView == self.tableView) {
        return;
    };
    
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    CGFloat gotoPointY = 0;
    
    //计算滑动手势结束后，页面准备的位置 ---（这里只分析了速度velocity不为0时，当速度为0时，用下面的方式计算位置）
    if (currentOffsetY <= contentOffsetMaxY && currentOffsetY > contentOffsetMidY) {
        
        if (velocity.y > 0) {
            
            gotoPointY = contentOffsetMaxY;
        }else if (velocity.y < 0){
            gotoPointY = contentOffsetMidY;
        }
    }else if (currentOffsetY < contentOffsetMidY && currentOffsetY > contentOffsetMinY) {
        
        if (velocity.y > 0) {
            
            gotoPointY = contentOffsetMidY;
        }else{
            gotoPointY = contentOffsetMinY;
        }
    }else{
        
        gotoPointY = contentOffsetMinY;
    }
    
    //当滑动速度为0时，判断当前位置距离哪一级别最近
    if (velocity.y == 0) {
        
        CGFloat distance = contentOffsetMaxY;

        for (NSNumber *item in self.currentOffsetArray) {
            
            int temp = fabs(item.floatValue - currentOffsetY);
            if (distance > temp) {
                
                distance = temp;
                gotoPointY = item.floatValue;
            }
        }
    }
    //动画到指定位置
    [self scrollView:scrollView initialSpringVelocity:velocity.y movePointY:gotoPointY isAnimate:YES];
    targetContentOffset->x = 0;
    targetContentOffset->y = gotoPointY;

}
- (void)scrollView:(UIScrollView *)scrollView initialSpringVelocity:(CGFloat)velocity movePointY:(CGFloat)movePointY isAnimate:(BOOL)isAnimate
{
    //显示bottomBar放在这里，是仿百度地图显示时机。
    if (movePointY <= contentOffsetMinY) {
        
//        moveButtom(isShow: true)
    }
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    
    if (!isAnimate) {
        
        scrollView.contentOffset = CGPointMake(0, movePointY);
        return;
    };
        
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseOut animations:^{
            
        scrollView.contentOffset = CGPointMake(0, movePointY);
        
    } completion:nil];
    
}

#pragma mark - LazyLoad -
- (HBaseScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[HBaseScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width, (self.bounds.size.height - kStatusBarAndNavigationBarHeight) * 2 - bottomBarHeight);
        
        //这里不能用isPagingEnabled来做分页效果
//        scrollView.isPagingEnabled = true
        _scrollView.alwaysBounceVertical = true;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.clipsToBounds = false;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _scrollView;
}
- (HBaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[HBaseTableView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
//        //tableview不延时
//        _tableView.delaysContentTouches = NO;
//        for (UIView *subView in self.subviews) {
//            if ([subView isKindOfClass:[UIScrollView class]]) {
//                ((UIScrollView *)subView).delaysContentTouches = NO;
//            }
//        }
        
        //tableview下移
//        self.contentInset = UIEdgeInsetsMake(PAaptation_y(600), 0, 0, 0);
    //    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];//去掉头部空白
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionHeaderHeight = 0.0;//消除底部空白
        _tableView.sectionFooterHeight = 0.0;//消除底部空白
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end
