//
//  HNomalGroupStudentView.m
//  Hikids
//
//  Created by 马腾 on 2023/11/7.
//

#import "HNomalGroupStudentView.h"
#import "HStudent.h"

@implementation HNomalGroupStudentView

- (instancetype)initWithFrame:(CGRect)frame withGroupList:(NSArray *)groupList
{
    if(self = [super initWithFrame:frame]){
        
        if(groupList.count == 2){
            
            UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [bgView setImage:[UIImage imageNamed:@"pin2.png"]];
            [self addSubview:bgView];
            
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(PAdaptation_x(10),0, bgView.frame.size.width - PAdaptation_x(20), bgView.frame.size.height)];
            [bgView addSubview:contentView];
            
            UIView *tempView = nil;
            for (HStudent *student in groupList) {
                UIView *headerBg = [[UIView alloc] initWithFrame:CGRectMake(tempView.frame.size.width, 0, contentView.frame.size.width/2, contentView.frame.size.height)];
                headerBg.layer.cornerRadius = contentView.frame.size.height/2;
                headerBg.layer.masksToBounds = YES;
                [contentView addSubview:headerBg];
                
                UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(headerBg.frame.size.width/2 - PAdaptation_x(58)/2, headerBg.frame.size.height/2 - PAaptation_y(58)/2, PAdaptation_x(58), PAaptation_y(58))];
                [header sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
                [headerBg addSubview:header];
                
                tempView = headerBg;
            }
            
        }else if (groupList.count == 3){
            
            UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [bgView setImage:[UIImage imageNamed:@"pin3.png"]];
            [self addSubview:bgView];
            
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(PAdaptation_x(10),0, bgView.frame.size.width - PAdaptation_x(20), bgView.frame.size.height)];
            [bgView addSubview:contentView];
            
            UIView *tempView = nil;
            for (HStudent *student in groupList) {
                UIView *headerBg = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tempView.frame), 0, contentView.frame.size.width/3, contentView.frame.size.height)];
                headerBg.layer.cornerRadius = contentView.frame.size.height/2;
                headerBg.layer.masksToBounds = YES;
                [contentView addSubview:headerBg];
                
                UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(headerBg.frame.size.width/2 - PAdaptation_x(58)/2, headerBg.frame.size.height/2 - PAaptation_y(58)/2, PAdaptation_x(58), PAaptation_y(58))];
                [header sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
                [headerBg addSubview:header];
                
                tempView = headerBg;
            }
            
        }else{
            UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [bgView setImage:[UIImage imageNamed:@"pin3.png"]];
            [self addSubview:bgView];
            
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(PAdaptation_x(10),0, bgView.frame.size.width - PAdaptation_x(20), bgView.frame.size.height)];
            contentView.backgroundColor = [UIColor redColor];
            [bgView addSubview:contentView];
            
            HStudent *student = [groupList safeObjectAtIndex:0];

            
            UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height/2 - PAaptation_y(58)/2, PAdaptation_x(58), PAaptation_y(58))];
            header.layer.cornerRadius = PAaptation_y(58)/2;
            header.layer.masksToBounds = YES;
            header.backgroundColor = [UIColor yellowColor];
            [header sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
            [contentView addSubview:header];
            
            HStudent *student1 = [groupList safeObjectAtIndex:1];

            UIImageView *header1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(header.frame)+PAdaptation_x(10), contentView.frame.size.height/2 - PAaptation_y(58)/2, PAdaptation_x(58), PAaptation_y(58))];
            header1.layer.cornerRadius = PAaptation_y(58)/2;
            header1.layer.masksToBounds = YES;
            [header1 sd_setImageWithURL:[NSURL URLWithString:student1.avatar]];
            header1.backgroundColor = [UIColor yellowColor];
            [contentView addSubview:header1];
            
            UIView *numBgView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(header1.frame)+PAdaptation_x(5), 0, contentView.frame.size.width/3, contentView.frame.size.height)];
            [contentView addSubview:numBgView];
            
            UIImageView *numView = [[UIImageView alloc] initWithFrame:CGRectMake(0, numBgView.frame.size.height/2 - PAaptation_y(40)/2, PAdaptation_x(46), PAaptation_y(40))];
            [numView setImage:[UIImage imageNamed:@"num.png"]];
            [numBgView addSubview:numView];
            
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, numView.frame.size.height/2 - PAaptation_y(25)/2, numView.frame.size.width, PAaptation_y(25))];
            countLabel.backgroundColor = [UIColor clearColor];
            countLabel.textColor = [UIColor whiteColor];
            countLabel.font = [UIFont boldSystemFontOfSize:16.0];
            countLabel.text = [NSString stringWithFormat:@"+%ld",groupList.count - 2];
            countLabel.textAlignment = NSTextAlignmentCenter;
            [numView addSubview:countLabel];
            
            
        }
        
    }
    return self;
}

@end
