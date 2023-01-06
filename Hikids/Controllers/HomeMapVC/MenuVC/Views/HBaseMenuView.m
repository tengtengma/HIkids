//
//  HBaseMenuView.m
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import "HBaseMenuView.h"
#import "HSmallCardView.h"


@interface HBaseMenuView()

@end

@implementation HBaseMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //tableview不延时
        self.delaysContentTouches = NO;
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)subView).delaysContentTouches = NO;
            }
        }
        
        //tableview下移
        self.contentInset = UIEdgeInsetsMake(PAaptation_y(600), 0, 0, 0);
    //    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];//去掉头部空白
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.sectionHeaderHeight = 0.0;//消除底部空白
        self.sectionFooterHeight = 0.0;//消除底部空白
        
        [self createHeaderView];
    }
    return self;
    
}

- (void)createHeaderView
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, PAaptation_y(121))];
    self.tableHeaderView = headerView;
    
    HSmallCardView *smallView = [[HSmallCardView alloc] initWithFrame:CGRectMake(PAdaptation_x(10),0 , PAdaptation_x(115), PAaptation_y(79))];
    
    [headerView addSubview:smallView];
    
    DefineWeakSelf;
    smallView.clickBlock = ^{
        if (weakSelf.openReport) {
            weakSelf.openReport();
        }
    };

    UIImageView *topView = [[UIImageView alloc] init];
    [topView setImage:[UIImage imageNamed:@"menu_header.png"]];
    [headerView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(PAaptation_y(89));
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

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
//    NSLog(@"point=%@",NSStringFromCGPoint(point));
//
//    NSLog(@"y=%f",self.contentOffset.y);
    
    if (point.y<0) {
        return nil;
    }

    return  [super hitTest:point withEvent:event];
}



@end
