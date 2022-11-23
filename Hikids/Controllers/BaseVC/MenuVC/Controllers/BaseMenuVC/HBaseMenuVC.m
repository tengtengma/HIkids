//
//  HMenuVC.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HBaseMenuVC.h"

#define OFFSET1               44
#define OFFSET2               self.view.frame.size.height - 294
#define OFFSET3               self.view.frame.size.height - 129

@interface HBaseMenuVC ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) float stop_y;//tableView滑动停止的位置

@end

@implementation HBaseMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createHeaderView];
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown ; // 设置手势方向
    downSwipe.delegate = self;
    [self.view addGestureRecognizer:downSwipe];
    
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp; // 设置手势方向
    upSwipe.delegate = self;
    [self.view addGestureRecognizer:upSwipe];
}

- (void)createHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.userInteractionEnabled = YES;
    [self.view addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(32));
    }];
    
    
    UIImageView *topView = [[UIImageView alloc] init];
    [topView setImage:[UIImage imageNamed:@"menu_header.png"]];
    [headerView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    
    UIImageView *lineView = [[UIImageView alloc] init];
    [lineView setImage:[UIImage imageNamed:@"line.png"]];
    [headerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
        make.width.mas_equalTo(PAdaptation_x(64));
        make.height.mas_equalTo(PAaptation_y(6));
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 当table Enabled且offsetY不为0时，让swipe响应
//    if (self.scrollView.scrollEnabled == YES && self.scrollView.contentOffset.y != 0) {
//        return NO;
//    }
//    if (self.scrollView.scrollEnabled == YES) {
//        return YES;
//    }
    return NO;
}

- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    float stopY = 0;     // 停留的位置
    float animateY = 0;  // 做弹性动画的Y
    float margin = 10;   // 动画的幅度
    float offsetY = self.view.frame.origin.y; // 这是上一次Y的位置
    //    NSLog(@"==== === %f == =====",self.vc.table.contentOffset.y);
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        
        // 当vc.table滑到头 且是下滑时，让vc.table禁止滑动
//        if (self.scrollView.contentOffset.y == 0) {
//            self.scrollView.scrollEnabled = NO;
//        }
        
        if (offsetY >= OFFSET1 && offsetY < OFFSET2) {
            // 停在y2的位置
            stopY = OFFSET2;
            
        }else if (offsetY >= OFFSET2 ){
            // 停在y3的位置
            stopY = OFFSET3;
            
        }else{
            stopY = OFFSET1;
        }
        animateY = stopY + margin;
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        //        NSLog(@"==== up =====");

        if (offsetY <= OFFSET2) {
            // 停在y1的位置
            stopY = OFFSET1;
            // 当停在Y1位置 且是上划时，让vc.table不再禁止滑动
//            self.scrollView.scrollEnabled = YES;
            
        
            
        }else if (offsetY > OFFSET2 && offsetY <= OFFSET3 ){
            // 停在y2的位置
            // 当停在Y1位置 且是上划时，让vc.table不再禁止滑动
//            self.tableViewController.tableView.scrollEnabled = YES;
            stopY = OFFSET2;
           
            
        }else{
            stopY = OFFSET3;
        }
        animateY = stopY - margin;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.view.frame = CGRectMake(0, animateY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, stopY, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        }];
    }];
    
}
@end
