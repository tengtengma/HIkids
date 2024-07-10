//
//  HBaseMenuView.m
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import "HBaseMenuView.h"
#import "HSmallCardView.h"
#import "UIView+Frame.h"
#import <QuartzCore/QuartzCore.h>

@interface HBaseMenuView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,assign) float bottomH;//下滑后距离顶部的距离
@property (nonatomic,assign) float stop_y;//tableView滑动停止的位置
@property (nonatomic,assign) NSInteger state;//0 top 1 center 2 bottom
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
    self.smallView.tag = 1001;
    [headerView addSubview:self.smallView ];
    
    DefineWeakSelf;
    self.smallView .clickBlock = ^{
        if (weakSelf.openReport) {
            weakSelf.openReport();
        }
    };
    
    self.busOrWalkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.busOrWalkButton.tag = 1003;
    [self.busOrWalkButton setFrame:CGRectMake(PAdaptation_x(20) , headerView.frame.size.height - PAaptation_y(82), PAdaptation_x(40), PAaptation_y(40))];
    [self.busOrWalkButton setImage:[UIImage imageNamed:@"bus_mode.png"] forState:UIControlStateNormal];
    [self.busOrWalkButton addTarget:self action:@selector(clickBusAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.busOrWalkButton];
    
    self.gpsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.gpsButton.tag = 1002;
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
- (void)clickBusAction
{
    if (self.busBlock) {
        self.busBlock();
    }
}
- (void)clickGpsAction
{
    if (self.gpsBlock) {
        self.gpsBlock();
    }
}

- (CAShapeLayer *)createTrapezoidLayer {
    CAShapeLayer *trapezoidLayer = [CAShapeLayer layer];

    // 设置梯形的位置和大小
    trapezoidLayer.frame = CGRectMake(0, 0, self.bounds.size.width, [self PAaptation_y:121]);

    // 创建梯形路径
    UIBezierPath *trapezoidPath = [UIBezierPath bezierPath];
    [trapezoidPath moveToPoint:CGPointMake(0, [self PAaptation_y:121])];
    [trapezoidPath addLineToPoint:CGPointMake(self.bounds.size.width, [self PAaptation_y:121])];
    [trapezoidPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    [trapezoidPath addLineToPoint:CGPointMake(0, 0)];
    [trapezoidPath closePath];

    // 将路径设置为梯形图层的路径
    trapezoidLayer.path = trapezoidPath.CGPath;

    // 设置梯形的填充颜色
    trapezoidLayer.fillColor = [UIColor greenColor].CGColor; // 你可以根据需要更改颜色

    return trapezoidLayer;
}

- (CGFloat)PAaptation_y:(CGFloat)value {
    // 这里你可以根据需要进行屏幕适配
    return value;
}
#pragma mark - 滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    // 获取点击的位置
    CGPoint tapLocation = [pan locationInView:self];
    NSLog(@"x = %f, y = %f", tapLocation.x, tapLocation.y);

    // 通过位置判断手指是否在某个 UIView 上
    for (UIView *subview in self.subviews) {

        if ([subview isKindOfClass:[UITableView class]]) {
        }
    }
    
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
                
        NSLog(@"velocity = %f",velocity.y);
        
        
        //停留在顶部0 ，停留在底部 520
        CGFloat stayPointY = pan.view.origin.y;
        
        if (velocity.y >= -50 && velocity.y <= 50) {
            NSLog(@"位置判断系");
            //此处是如果慢慢的滑动 就按停留位置计算
            if (stayPointY >= 0 && stayPointY <= 200) {
                [self goTop];
                return;
            }
            if (stayPointY > 200 && stayPointY < 346) {
                [self goCenter];
                return;

            }
            if (stayPointY >=346) {
                [self goBack];
                return;

            }
        }
        


        //速度在-3000 和 3000 之间的 属于中间center
        if (velocity.y > - 3000 && velocity.y < 3000) {
            NSLog(@"速度判断系 中");

            if (velocity.y <= -1200) {
                //在中间时，向上滑动
                [self goTop];

            }else if (velocity.y > 1200){
                //在中间时，向下滑动
                [self goBack];

            }else{
                if (self.state == 2 && velocity.y > 0) {
                    return;
                }
                //在中间时，向上或向下速度不够 维持原样
                NSLog(@"center");
                [self goCenter];
            }
            return;
        }
        //速度滑动快 直接到顶部 无center
        if (velocity.y <= -3000 ) {
            NSLog(@"速度判断系");

            NSLog(@"top");
            [self goTop];
            return;
        }
        //速度滑动快 直接到底部 无center
        if (velocity.y >= 3000) {
            NSLog(@"速度判断系");

            NSLog(@"bottom");
            [self goBack];
            return;
        }
    
    }
    
    [pan setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)goTop {
    
    DefineWeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        self.top = self.topH;
    }completion:^(BOOL finished) {
        self.tableView.scrollEnabled = YES;
        //此处用来控制gpsbutton的隐藏
        if (weakSelf.toTopBlock) {
            weakSelf.toTopBlock();
        }
    }];
    self.state = 0;

}
- (void)goCenter
{
    if (self.tableView.isDragging || self.tableView.isDecelerating) {
        // UITableView 正在滚动中
        NSLog(@"UITableView 正在滚动中");
        return;
        
    }
    
    DefineWeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        self.top = SCREEN_HEIGHT/5*2;
    }completion:^(BOOL finished) {
        self.stop_y = -100;
        self.tableView.scrollEnabled = NO;
        
        //此处用来控制gpsbutton的显示
        if (weakSelf.toBottomBlock) {
            weakSelf.toBottomBlock();
        }
    }];
    self.state = 1;

}

- (void)goBack {
    
    DefineWeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        self.top = self.bottomH;
    }completion:^(BOOL finished) {
        self.tableView.scrollEnabled = NO;
        //此处用来控制gpsbutton的显示
        if (weakSelf.toBottomBlock) {
            weakSelf.toBottomBlock();
        }
    }];
    self.state = 2;

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
        _tableView.tag = 1000;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;//上来默认不许滚动
    }
    return _tableView;
}
@end
