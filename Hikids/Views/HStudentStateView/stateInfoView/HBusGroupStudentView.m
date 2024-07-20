//
//  HBusGroupStudentView.m
//  Hikids
//
//  Created by 马腾 on 2024/7/10.
//

#import "HBusGroupStudentView.h"
#import "HStudent.h"

@implementation HBusGroupStudentView

- (instancetype)initWithFrame:(CGRect)frame withGroupList:(NSArray *)groupList
{
    if(self = [super initWithFrame:frame]){
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [bgView setImage:[UIImage imageNamed:@"children-pin-car.png"]];
        [self addSubview:bgView];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(PAdaptation_x(10), 0, bgView.frame.size.width - PAdaptation_x(20), frame.size.height)];
        contentView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:contentView];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height/2 - PAaptation_y(58)/2, PAdaptation_x(58), PAaptation_y(58))];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [icon setImage:[UIImage imageNamed:@"bus_mark.png"]];
        [contentView addSubview:icon];
        
        UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame)+PAdaptation_x(10), contentView.frame.size.height/2 - PAaptation_y(58)/2, PAdaptation_x(58), PAaptation_y(58))];
        header.layer.cornerRadius = PAaptation_y(58)/2;
        header.layer.masksToBounds = YES;
        header.contentMode = UIViewContentModeScaleAspectFit;
        [header setImage:[UIImage imageNamed:@"profile-teacher.png"]];
        [contentView addSubview:header];
        
        HStudent *student1 = [groupList safeObjectAtIndex:0];

        UIImageView *header1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(header.frame)+PAdaptation_x(10), contentView.frame.size.height/2 - PAaptation_y(58)/2, PAdaptation_x(58), PAaptation_y(58))];
        header1.layer.cornerRadius = PAaptation_y(58)/2;
        header1.layer.masksToBounds = YES;
        [header1 sd_setImageWithURL:[NSURL URLWithString:student1.avatar]];
        header1.contentMode = UIViewContentModeScaleAspectFit;
        [contentView addSubview:header1];
        
        UIView *numBgView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(header1.frame)+PAdaptation_x(5), 0, contentView.frame.size.width/4, contentView.frame.size.height)];
        [contentView addSubview:numBgView];
        
        UIImageView *numView = [[UIImageView alloc] initWithFrame:CGRectMake(0, numBgView.frame.size.height/2 - PAaptation_y(40)/2, PAdaptation_x(46), PAaptation_y(40))];
        [numView setImage:[UIImage imageNamed:@"num_bus.png"]];
        numView.contentMode = UIViewContentModeScaleAspectFit;
        [numBgView addSubview:numView];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, numView.frame.size.height/2 - PAaptation_y(25)/2, numView.frame.size.width, PAaptation_y(25))];
        countLabel.backgroundColor = [UIColor clearColor];
        countLabel.textColor = [UIColor whiteColor];
        countLabel.font = [UIFont boldSystemFontOfSize:16.0];
        countLabel.text = [NSString stringWithFormat:@"+%ld",groupList.count - 1];
        countLabel.textAlignment = NSTextAlignmentCenter;
        
        [numView addSubview:countLabel];
        
    }
    return self;
}

@end
