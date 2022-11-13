//
//  HWalkStudentStateView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/15.
//

#import "HWalkStudentStateView.h"
#import "HStudent.h"
#import "UIView+Frame.h"
#import "HStudentTopView.h"
#import "HStudentFooterView.h"
#import "HStudentCloseView.h"
#import "HSmallCardView.h"

#define OFFSET1               44
#define OFFSET2               self.frame.size.height - 294
#define OFFSET3               self.frame.size.height - 158

@interface HWalkStudentStateView()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) HSmallCardView *smallMenuView;
@property (nonatomic, strong) UIButton *gpsButton;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) float bottomH;//下滑后距离顶部的距离
@property (nonatomic, assign) float stop_y;//tableView滑动停止的位置
@property (nonatomic, assign) BOOL dangerIsExpand;
@property (nonatomic, assign) BOOL safeIsExpand;
@property (nonatomic, assign) NSInteger state; //0  1  2 三个档位

@end

@implementation HWalkStudentStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
                        
        [self addSubview:self.smallMenuView];
        [self.smallMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(PAdaptation_x(10));
            make.width.mas_equalTo(PAdaptation_x(115));
            make.height.mas_equalTo(PAaptation_y(79));
        }];
        
        [self addSubview:self.gpsButton];
        [self.gpsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.smallMenuView.mas_bottom);
            make.right.equalTo(self.mas_right).offset(-PAdaptation_x(10));
            make.width.mas_equalTo(PAdaptation_x(52));
            make.height.mas_equalTo(PAaptation_y(52));
        }];
        
        [self addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.smallMenuView.mas_bottom).offset(PAaptation_y(13));
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.mas_equalTo(PAaptation_y(32));
        }];
        
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(self);
        }];
        
//        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//        panGestureRecognizer.delegate = self;
//        [self addGestureRecognizer:panGestureRecognizer];
        
//        self.bottomH = self.top;
        
        UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        downSwipe.direction = UISwipeGestureRecognizerDirectionDown ; // 设置手势方向
        downSwipe.delegate = self;
        [self addGestureRecognizer:downSwipe];
        
        UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        upSwipe.direction = UISwipeGestureRecognizerDirectionUp; // 设置手势方向
        upSwipe.delegate = self;
        [self addGestureRecognizer:upSwipe];
        
        self.dangerIsExpand = YES;
        
        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 当table Enabled且offsetY不为0时，让swipe响应
    if (self.scrollView.scrollEnabled == YES && self.scrollView.contentOffset.y != 0) {
        return NO;
    }
    if (self.scrollView.scrollEnabled == YES) {
        return YES;
    }
    return NO;
}

- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    float stopY = 0;     // 停留的位置
    float animateY = 0;  // 做弹性动画的Y
    float margin = 10;   // 动画的幅度
    float offsetY = self.frame.origin.y; // 这是上一次Y的位置
    //    NSLog(@"==== === %f == =====",self.vc.table.contentOffset.y);
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        
        // 当vc.table滑到头 且是下滑时，让vc.table禁止滑动
        if (self.scrollView.contentOffset.y == 0) {
            self.scrollView.scrollEnabled = NO;
        }
        
        if (offsetY >= OFFSET1 && offsetY < OFFSET2) {
            // 停在y2的位置
            stopY = OFFSET2;
            NSLog(@"center2222");

            self.smallMenuView.hidden = NO;
            self.gpsButton.hidden = NO;

        }else if (offsetY >= OFFSET2 ){
            // 停在y3的位置
            stopY = OFFSET3;
            
            self.smallMenuView.hidden = NO;
            self.gpsButton.hidden = NO;
            
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
            self.scrollView.scrollEnabled = YES;
            
            self.smallMenuView.hidden = YES;
            self.gpsButton.hidden = YES;
            
        }else if (offsetY > OFFSET2 && offsetY <= OFFSET3 ){
            // 停在y2的位置
            // 当停在Y1位置 且是上划时，让vc.table不再禁止滑动
//            self.tableViewController.tableView.scrollEnabled = YES;
            stopY = OFFSET2;
            NSLog(@"center11111");
            
        }else{
            stopY = OFFSET3;
        }
        animateY = stopY - margin;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.frame = CGRectMake(0, animateY, self.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, stopY, self.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        }];
    }];
    
    // 记录shadowView在第一个视图中的位置
    self.topH = stopY;
}

//- (void)panAction:(UIPanGestureRecognizer *)pan
//{
//    // 获取视图偏移量
//    CGPoint point = [pan translationInView:self];
//
//    // stop_y是tableview的偏移量，当tableview的偏移量大于0时则不去处理视图滑动的事件
//    if (self.stop_y>0) {
//        // 将视频偏移量重置为0
//        [pan setTranslation:CGPointMake(0, 0) inView:self];
//        return;
//    }
//
//    // self.top是视图距离顶部的距离
//    self.top += point.y;
//    if (self.top < self.topH) {
//        self.top = self.topH;
//    }
//
//    // self.bottomH是视图在底部时距离顶部的距离
//    if (self.top > self.bottomH) {
//        self.top = self.bottomH;
//
//    }
//
//
//
//    NSLog(@"top %f",self.top);
//
//    // 在滑动手势结束时判断滑动视图距离顶部的距离是否超过了屏幕的一半，如果超过了一半就往下滑到底部
//    // 如果小于一半就往上滑到顶部
//    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
//
//
//        if (self.top <= PAaptation_y(220)) {
//            [self goTop];
//        }else if(self.top > PAaptation_y(220) && self.top < PAaptation_y(450)){
//            [self goCenter];
//        }else{
//            [self goBack];
//        }
//
//        // 滑动速度
//        CGPoint velocity = [pan velocityInView:self];
//
//
//        CGFloat speed = 350;
//        if (velocity.y < -speed) {
//            [pan setTranslation:CGPointMake(0, 0) inView:self];
//            return;
//        }else if (velocity.y > speed){
//            [pan setTranslation:CGPointMake(0, 0) inView:self];
//            return;
//        }else{
//            [pan setTranslation:CGPointMake(0, 0) inView:self];
//
//        }
//
//
////        NSLog(@"%f",self.top);
////
////        if (self.top > SCREEN_HEIGHT/2) {
////            [self goBack];
////        }else{
////            [self goTop];
////        }
//    }
//
//    [pan setTranslation:CGPointMake(0, 0) inView:self];
//}




//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat currentPostion = scrollView.contentOffset.y;
//    self.stop_y = currentPostion;
//
////    if (self.top>self.topH) {
////        [scrollView setContentOffset:CGPointMake(0, 0)];
////    }
//}

- (void)goCenter
{
    self.smallMenuView.hidden = NO;
    self.gpsButton.hidden = NO;
    self.scrollView.scrollEnabled = NO;
    
    float stopY = OFFSET2;
    
    float animateY = stopY - 10;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.frame = CGRectMake(0, animateY, self.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, stopY, self.frame.size.width, [UIScreen mainScreen].bounds.size.height);
        }];
    }];
    
//    [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.smallMenuView.mas_bottom).offset(PAaptation_y(13));
//        make.left.equalTo(self);
//        make.width.equalTo(self);
//        make.height.mas_equalTo(PAaptation_y(32));
//    }];
//
//    [self.smallMenuView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.left.equalTo(self).offset(PAdaptation_x(10));
//        make.width.mas_equalTo(PAdaptation_x(115));
//        make.height.mas_equalTo(PAaptation_y(79));
//    }];
//
//    [self.gpsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.smallMenuView.mas_bottom);
//        make.right.equalTo(self.mas_right).offset(-PAdaptation_x(10));
//        make.width.mas_equalTo(PAdaptation_x(52));
//        make.height.mas_equalTo(PAaptation_y(52));
//    }];
    
}
- (void)walkEndAction
{
    if (self.walkEndBlock) {
        self.walkEndBlock();
    }
}
//暂时不用
//- (void)clickTopViewAction
//{
//    if (self.ShowOrHideWalkStateViewBlock) {
//        self.ShowOrHideWalkStateViewBlock(self.state);
//    }
//}

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
    for (id v in self.scrollView.subviews)
        [v removeFromSuperview];
    
////    //测试用
//    NSMutableArray *except = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i<10; i++) {
//        HStudent *student = [[HStudent alloc] init];
//        student.avatar = @"https://img0.baidu.com/it/u=2643936262,3742092684&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=357";
//        student.sId = [NSString stringWithFormat:@"%ld",100+i];
//        student.name = @"asdfsa";
//        student.exceptionTime = @"123";
//        student.distance = @"200";
//        [except addObject:student];
//    }
//
//    self.exceptArray = except;
////
//    NSMutableArray *nomal = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i<12; i++) {
//        HStudent *student = [[HStudent alloc] init];
//        student.avatar = @"https://img0.baidu.com/it/u=2643936262,3742092684&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=357";
//        student.sId = [NSString stringWithFormat:@"%ld",300+i];
//        student.name = @"asdfsa";
//        [nomal addObject:student];
//    }
//
//    self.nomalArray = nomal;
    
    [self createStudentView];
    
    self.smallMenuView.safeLabel.text = [NSString stringWithFormat:@"使用中%ld人",self.nomalArray.count + self.exceptArray.count];
    self.smallMenuView.dangerLabel.text = @"アラート0回";
}

- (void)createStudentView
{
    if (self.exceptArray.count != 0) {
        
        if (self.dangerIsExpand) {
            
            HStudentTopView *topView = [[HStudentTopView alloc] init];
            topView.tag = 10000;
            [topView setDangerStyleWithStudentCount:self.exceptArray.count];
            [self.scrollView addSubview:topView];
            
            [topView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.scrollView);
                make.left.equalTo(self).offset(PAdaptation_x(24));
                make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
                make.height.mas_equalTo(PAaptation_y(40));
            }];
            
            UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            expandBtn.tag = 1000;
            [expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
            [expandBtn setImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
            [topView addSubview:expandBtn];
            
            [expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(topView);
                make.right.equalTo(topView.mas_right).offset(-PAdaptation_x(11.5));
                make.width.mas_equalTo(PAdaptation_x(21));
                make.height.mas_equalTo(PAaptation_y(24));
            }];
            
            
            for (NSInteger i = 0; i < self.exceptArray.count; i++) {
                
                HStudent *student = [self.exceptArray safeObjectAtIndex:i];

                HStudentFooterView *bottomView = [[HStudentFooterView alloc] init];
                bottomView.backgroundColor = [UIColor whiteColor];
                [bottomView setFrame:CGRectMake(PAdaptation_x(24), PAaptation_y(40)+ PAaptation_y(89)*i, SCREEN_WIDTH -PAdaptation_x(48), PAaptation_y(89))];
                
                if (i == self.exceptArray.count -1) {
                    
                    bottomView.lineView.hidden = YES;

                    //最后一个单独处理圆角
                    
                    UIImageView *listBottomView = [[UIImageView alloc] initWithFrame:bottomView.bounds];
                    listBottomView.userInteractionEnabled = YES;
                    [listBottomView setImage:[UIImage imageNamed:@"listBottom_danger@2x.png"]];
                    [bottomView addSubview:listBottomView];
                    [bottomView sendSubviewToBack:listBottomView];

                                    
                }else{
                    [BWTools setBorderWithView:bottomView top:NO left:YES bottom:NO right:YES borderColor:BWColor(83, 38, 2, 1) borderWidth:2];
                }
                [bottomView setupWithModel:student];
                [self.scrollView addSubview:bottomView];
                
            }
        }else{
            
            float height = PAaptation_y(0);
        
            HStudentCloseView *bgView = [[HStudentCloseView alloc] initWithArray:self.exceptArray];
            [self.scrollView addSubview:bgView];
        
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(height);
                make.left.equalTo(self).offset(PAdaptation_x(24));
                make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
                make.height.mas_equalTo(PAaptation_y(129));
            }];
        
        
            UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            expandBtn.tag = 1001;
            [expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
            [expandBtn setImage:[UIImage imageNamed:@"close_state.png"] forState:UIControlStateNormal];
            [bgView addSubview:expandBtn];
            
            [expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView.topView);
                make.right.equalTo(bgView.mas_right).offset(-PAdaptation_x(11.5));
                make.width.mas_equalTo(PAdaptation_x(21));
                make.height.mas_equalTo(PAaptation_y(24));
            }];

        }
        
        if (self.nomalArray.count != 0) {
            if (self.safeIsExpand) {
                
                float height;
                if (self.dangerIsExpand) {
                    height = PAaptation_y(30) + PAaptation_y(40)+ PAaptation_y(89)*self.exceptArray.count;
                }else{
                    height = PAaptation_y(30) + PAaptation_y(40)+ PAaptation_y(89)*1;
                }

                HStudentTopView *topView = [[HStudentTopView alloc] init];
                topView.tag = 10001;
                [topView setSafeStyleWithStudentCount:self.nomalArray.count];
                [self.scrollView addSubview:topView];
                
                [topView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(height);
                    make.left.equalTo(self).offset(PAdaptation_x(24));
                    make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
                    make.height.mas_equalTo(PAaptation_y(40));
                }];
                
                UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                expandBtn.tag = 1002;
                [expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
                [expandBtn setImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
                [topView addSubview:expandBtn];
                
                [expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(topView);
                    make.right.equalTo(topView.mas_right).offset(-PAdaptation_x(11.5));
                    make.width.mas_equalTo(PAdaptation_x(21));
                    make.height.mas_equalTo(PAaptation_y(24));
                }];
                
                
                for (NSInteger i = 0; i < self.nomalArray.count; i++) {
                    
                    HStudentFooterView *bottomView = [[HStudentFooterView alloc] init];
                    bottomView.backgroundColor = [UIColor whiteColor];
                    
                    if (self.dangerIsExpand) {
                        height = (PAaptation_y(30) + PAaptation_y(40)+ (PAaptation_y(40)+PAaptation_y(89)*self.exceptArray.count))+i*PAaptation_y(89);
                    }else{
                        height = (PAaptation_y(30)+PAaptation_y(40)+ (PAaptation_y(40)+PAaptation_y(89)*1))+i*PAaptation_y(89);
                    }
                    
                    [bottomView setFrame:CGRectMake(PAdaptation_x(24), height, SCREEN_WIDTH - PAdaptation_x(48), PAaptation_y(89))];
                    if (i == self.nomalArray.count -1) {
                        
                        bottomView.lineView.hidden = YES;

                        //最后一个单独处理圆角
                        UIImageView *listBottomView = [[UIImageView alloc] initWithFrame:bottomView.bounds];
                        listBottomView.userInteractionEnabled = YES;
                        [listBottomView setImage:[UIImage imageNamed:@"listBottom_safe@2x.png"]];
                        [bottomView addSubview:listBottomView];
                        [bottomView sendSubviewToBack:listBottomView];

                        
                    }else{
                        [BWTools setBorderWithView:bottomView top:NO left:YES bottom:NO right:YES borderColor:BWColor(0, 102, 10, 1) borderWidth:2];
                    }
                    [bottomView setupWithModel:[self.nomalArray safeObjectAtIndex:i]];

                    [self.scrollView addSubview:bottomView];

                }
                
            }else{
                
                float height;
                if (self.dangerIsExpand) {
                    height = (PAaptation_y(30) + PAaptation_y(40)+PAaptation_y(89)*self.exceptArray.count);
                }else{
                    height = PAaptation_y(30) + PAaptation_y(40)+ PAaptation_y(89)*1;
                }
                                                         
                HStudentCloseView *bgView = [[HStudentCloseView alloc] initWithArray:self.nomalArray];
                [self.scrollView addSubview:bgView];
            
                [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(height);
                    make.left.equalTo(self).offset(PAdaptation_x(24));
                    make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
                    make.height.mas_equalTo(PAaptation_y(129));
                }];
                
                
                UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                expandBtn.tag = 1003;
                [expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
                [expandBtn setImage:[UIImage imageNamed:@"close_state.png"] forState:UIControlStateNormal];
                [bgView addSubview:expandBtn];
                
                [expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bgView.topView);
                    make.right.equalTo(bgView.mas_right).offset(-PAdaptation_x(11.5));
                    make.width.mas_equalTo(PAdaptation_x(21));
                    make.height.mas_equalTo(PAaptation_y(24));
                }];

            }
        }
        

    }else{
        if (self.nomalArray.count != 0) {
            if (self.safeIsExpand) {
                
                float height = 0;

                HStudentTopView *topView = [[HStudentTopView alloc] init];
                topView.tag = 10001;
                [topView setSafeStyleWithStudentCount:self.nomalArray.count];
                [self.scrollView addSubview:topView];
                
                [topView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(height);
                    make.left.equalTo(self).offset(PAdaptation_x(24));
                    make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
                    make.height.mas_equalTo(PAaptation_y(40));
                }];
                
                UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                expandBtn.tag = 1002;
                [expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
                [expandBtn setImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
                [topView addSubview:expandBtn];
                
                [expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(topView);
                    make.right.equalTo(topView.mas_right).offset(-PAdaptation_x(11.5));
                    make.width.mas_equalTo(PAdaptation_x(21));
                    make.height.mas_equalTo(PAaptation_y(24));
                }];
                
                
                for (NSInteger i = 0; i < self.nomalArray.count; i++) {
                    
                    HStudentFooterView *bottomView = [[HStudentFooterView alloc] init];
                    bottomView.backgroundColor = [UIColor whiteColor];
                    
                    height = PAaptation_y(40)+i*PAaptation_y(89);

                    [bottomView setFrame:CGRectMake(PAdaptation_x(24), height, SCREEN_WIDTH - PAdaptation_x(48), PAaptation_y(89))];
                    if (i == self.nomalArray.count -1) {
                        bottomView.lineView.hidden = YES;
                        //最后一个单独处理圆角
                        UIImageView *listBottomView = [[UIImageView alloc] initWithFrame:bottomView.bounds];
                        listBottomView.userInteractionEnabled = YES;
                        [listBottomView setImage:[UIImage imageNamed:@"listBottom_safe@2x.png"]];
                        [bottomView addSubview:listBottomView];
                        [bottomView sendSubviewToBack:listBottomView];
                        
                    }else{
                        [BWTools setBorderWithView:bottomView top:NO left:YES bottom:NO right:YES borderColor:BWColor(83, 38, 2, 1) borderWidth:2];
                    }
                    [bottomView setupWithModel:[self.nomalArray safeObjectAtIndex:i]];

                    [self.scrollView addSubview:bottomView];

                }
                
            }else{
                
                float height = 0;
                                                         
                HStudentCloseView *bgView = [[HStudentCloseView alloc] initWithArray:self.nomalArray];
                [self.scrollView addSubview:bgView];
            
                [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(height);
                    make.left.equalTo(self).offset(PAdaptation_x(24));
                    make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
                    make.height.mas_equalTo(PAaptation_y(129));
                }];
                
                
                UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                expandBtn.tag = 1003;
                [expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
                [expandBtn setImage:[UIImage imageNamed:@"close_state.png"] forState:UIControlStateNormal];
                [bgView addSubview:expandBtn];
                
                [expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(bgView.topView);
                    make.right.equalTo(bgView.mas_right).offset(-PAdaptation_x(11.5));
                    make.width.mas_equalTo(PAdaptation_x(21));
                    make.height.mas_equalTo(PAaptation_y(24));
                }];

            }
        }

    }

    if (self.dangerIsExpand && self.safeIsExpand) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, PAaptation_y(40)+PAaptation_y(40)+PAaptation_y(89)+self.nomalArray.count*PAaptation_y(89)+self.exceptArray.count * PAaptation_y(89));

        return;
    }
    if (self.dangerIsExpand == YES && self.safeIsExpand == NO) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, PAaptation_y(40)+PAaptation_y(120)+PAaptation_y(89)+self.exceptArray.count * PAaptation_y(89));
        return;

    }
    if (self.dangerIsExpand == NO && self.safeIsExpand == YES) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, PAaptation_y(40)+PAaptation_y(120)+PAaptation_y(89)+self.nomalArray.count * PAaptation_y(89));
        return;
    }
    if (self.dangerIsExpand == NO && self.safeIsExpand == NO) {
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - (PAaptation_y(129)*2 + PAaptation_y(30)));
        return;
    }
}
- (void)clickExpandAction:(UIButton *)button
{
    if (button.tag == 1000) {
        NSLog(@"1000");
        self.dangerIsExpand = !self.dangerIsExpand;
        
    }
    if (button.tag == 1001) {
        NSLog(@"1001");
        self.dangerIsExpand = !self.dangerIsExpand;

    }
    if (button.tag == 1002) {
        NSLog(@"1002");
        self.safeIsExpand = !self.safeIsExpand;

    }
    if (button.tag == 1003) {
        NSLog(@"1003");
        self.safeIsExpand = !self.safeIsExpand;
    }

    [self tableReload];
}
- (void)locationAction:(id)sender
{
    if (self.clickGpsBlock) {
        self.clickGpsBlock();
    }
}
#pragma mark - LazyLoad -
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
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
        
    }
    return _topView;
    
}
- (HSmallCardView *)smallMenuView
{
    if (!_smallMenuView) {
        _smallMenuView = [[HSmallCardView alloc] initWithFrame:CGRectMake(PAdaptation_x(5), SCREEN_HEIGHT - PAaptation_y(189), PAdaptation_x(115), PAaptation_y(79))];
    }
    return _smallMenuView;
}
- (UIButton *)gpsButton
{
    if (!_gpsButton) {
        _gpsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gpsButton setFrame:CGRectMake(SCREEN_WIDTH - PAdaptation_x(62), SCREEN_HEIGHT - PAaptation_y(162), PAdaptation_x(52), PAaptation_y(52))];
        [_gpsButton setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
        [_gpsButton addTarget:self action:@selector(locationAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gpsButton;
}
@end
