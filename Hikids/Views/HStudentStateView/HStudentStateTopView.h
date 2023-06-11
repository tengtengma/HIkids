//
//  HStudentStateTopView.h
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum _TYPE
{
    TYPE_WALK = 0,
    TYPE_SLEEP = 1,

}TYPE;

typedef void(^expandBlockAction)(void);

@interface HStudentStateTopView : UIView
@property (nonatomic, copy) expandBlockAction expandBlock;
@property (nonatomic, strong) NSArray *studentList;
@property (nonatomic, strong) UIButton *expandBtn;
@property (nonatomic, assign) TYPE type;
@property (nonatomic, strong) UILabel *dangerTimeLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *numberBg;


- (void)loadSafeStyle;
- (void)loadDangerStyle;
- (void)loadWalkDangerReportStyle;


@end

NS_ASSUME_NONNULL_END
