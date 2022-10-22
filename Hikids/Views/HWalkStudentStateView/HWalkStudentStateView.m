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


@interface HWalkStudentStateView()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) float bottomH;//下滑后距离顶部的距离
@property (nonatomic, assign) float stop_y;//tableView滑动停止的位置
@property (nonatomic, assign) BOOL dangerIsExpand;
@property (nonatomic, assign) BOOL safeIsExpand;

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
        
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(self);
        }];
        
        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];
        
        self.bottomH = self.top;
        
        self.dangerIsExpand = YES;
        
        
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
        self.scrollView.userInteractionEnabled = YES;
    }];
}

- (void)goBack {
    [UIView animateWithDuration:0.5 animations:^{
        self.top = self.bottomH;
    }completion:^(BOOL finished) {
        self.scrollView.userInteractionEnabled = NO;
    }];
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
    
    
//    //测试用
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
//
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
    
    
    if (self.exceptArray.count == 0) {
        [self createNomalView];
    }else{
        [self createExceptView];
    }
}
- (void)createNomalView
{

    HStudentCloseView *bgView = [[HStudentCloseView alloc] initWithArray:self.nomalArray];
    [self.scrollView addSubview:bgView];

    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self).offset(PAdaptation_x(24));
        make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
        make.height.mas_equalTo(PAaptation_y(129));
    }];

}
- (void)createExceptView
{
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
        
        DefineWeakSelf;
        topView.expandBlock = ^{
            weakSelf.dangerIsExpand = !weakSelf.dangerIsExpand;
            [weakSelf tableReload];
        };
        
        for (NSInteger i = 0; i < self.exceptArray.count; i++) {
            
            HStudent *student = [self.exceptArray safeObjectAtIndex:i];

            HStudentFooterView *bottomView = [[HStudentFooterView alloc] init];
            bottomView.backgroundColor = [UIColor whiteColor];
            [bottomView setFrame:CGRectMake(PAdaptation_x(24), PAaptation_y(40)+ PAaptation_y(89)*i, SCREEN_WIDTH -PAdaptation_x(48), PAaptation_y(89))];
            
            if (i == self.exceptArray.count -1) {
                //最后一个单独处理圆角
                
                UIImageView *listBottomView = [[UIImageView alloc] initWithFrame:bottomView.bounds];
                listBottomView.userInteractionEnabled = YES;
                [listBottomView setImage:[UIImage imageNamed:@"listBottom_danger@2x.png"]];
                [bottomView addSubview:listBottomView];
                                
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
        
        DefineWeakSelf;
        bgView.expandBlock = ^{
            weakSelf.dangerIsExpand = !weakSelf.dangerIsExpand;
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.isDangerExpand = weakSelf.dangerIsExpand;
            [weakSelf tableReload];
        };
        
        
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

    
    if (self.safeIsExpand) {
        
        float height;
        if (self.dangerIsExpand) {
            height = PAaptation_y(40) + PAaptation_y(40)+ PAaptation_y(89)*self.exceptArray.count;
        }else{
            height = PAaptation_y(40) + PAaptation_y(40)+ PAaptation_y(89)*1;
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
        
        DefineWeakSelf;
        topView.expandBlock = ^{
            weakSelf.safeIsExpand = !weakSelf.safeIsExpand;
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.isSafeExpand = weakSelf.safeIsExpand;
            [weakSelf tableReload];
        };
        
        
        for (NSInteger i = 0; i < self.nomalArray.count; i++) {
            
            HStudentFooterView *bottomView = [[HStudentFooterView alloc] init];
            bottomView.backgroundColor = [UIColor whiteColor];
            
            if (self.dangerIsExpand) {
                height = (PAaptation_y(40) + PAaptation_y(40)+ (PAaptation_y(40)+PAaptation_y(89)*self.exceptArray.count))+i*PAaptation_y(89);
            }else{
                height = (PAaptation_y(40)+PAaptation_y(40)+ (PAaptation_y(40)+PAaptation_y(89)*1))+i*PAaptation_y(89);
            }
            
            [bottomView setFrame:CGRectMake(PAdaptation_x(24), height, SCREEN_WIDTH - PAdaptation_x(48), PAaptation_y(89))];
            if (i == self.nomalArray.count -1) {
                //最后一个单独处理圆角
                UIImageView *listBottomView = [[UIImageView alloc] initWithFrame:bottomView.bounds];
                listBottomView.userInteractionEnabled = YES;
                [listBottomView setImage:[UIImage imageNamed:@"listBottom_safe@2x.png"]];
                [bottomView addSubview:listBottomView];
                
            }else{
                [BWTools setBorderWithView:bottomView top:NO left:YES bottom:NO right:YES borderColor:BWColor(83, 38, 2, 1) borderWidth:2];
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
        
        DefineWeakSelf;
        bgView.expandBlock = ^{
            weakSelf.safeIsExpand = !weakSelf.safeIsExpand;
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.isSafeExpand = weakSelf.safeIsExpand;
            [weakSelf tableReload];
        };
        
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

#pragma mark - LazyLoad -
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.userInteractionEnabled = NO;
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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTopViewAction)];
        [_topView addGestureRecognizer:tap];
    }
    return _topView;
    
}
//- (UIButton *)expandBtn
//{
//    if (!_expandBtn) {
//        _expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _expandBtn.tag = 1001;
//        [_expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
//
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        if (app.isDangerExpand || app.isSafeExpand) {
//            [_expandBtn setImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
//            return _expandBtn;
//
//        }else{
//            [_expandBtn setImage:[UIImage imageNamed:@"close_state.png"] forState:UIControlStateNormal];
//            return _expandBtn;
//
//        }
//
//
//    }
//    return _expandBtn;
//}
@end
