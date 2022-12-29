//
//  HBaseMenuView.m
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import "HBaseMenuView.h"

@implementation HBaseMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createHeaderView];
    }
    return self;
    
}


- (void)createHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, PAaptation_y(32))];
    self.tableHeaderView = headerView;

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

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    NSLog(@"point=%@",NSStringFromCGPoint(point));
    
    NSLog(@"y=%f",self.contentOffset.y);
    
    if (point.y<0) {
        return nil;
    }

    return  [super hitTest:point withEvent:event];
}



@end
