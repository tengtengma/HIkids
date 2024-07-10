//
//  HBaseMenuView.h
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HSmallCardView;

typedef enum _CellType
{
    CellType_Safe = 0,
    CellType_Danger = 1,
    CellType_Lost = 2,
    CellType_Charge = 3
}CellType;

typedef void(^openReportBlock)(void);
typedef void(^clickBusAction)(void);
typedef void(^clickGpsAction)(void);
typedef void(^toTopAction)(void);
typedef void(^toBottomAction)(void);

@interface HBaseMenuView : UIView
@property (nonatomic, assign) CellType type;
@property (nonatomic, copy) openReportBlock openReport;
@property (nonatomic, copy) clickGpsAction gpsBlock;
@property (nonatomic, copy) clickBusAction busBlock;
@property (nonatomic, copy) toTopAction toTopBlock;
@property (nonatomic, copy) toBottomAction toBottomBlock;

@property (nonatomic, strong) UIButton *gpsButton;
@property (nonatomic, strong) UIButton *busOrWalkButton;
@property (nonatomic, strong) NSArray *safeList;
@property (nonatomic, strong) NSArray *exceptList;
@property (nonatomic, strong) HSmallCardView *smallView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,assign) float topH;//上滑后距离顶部的距离


- (instancetype)initWithFrame:(CGRect)frame;

- (void)goTop;

- (void)goCenter;
@end

NS_ASSUME_NONNULL_END
