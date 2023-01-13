//
//  HBaseMenuView.h
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum _CellType
{
    CellType_Safe = 0,
    CellType_Danger = 1,
    CellType_Lost = 2,
    CellType_Charge = 3
}CellType;

typedef void(^openReportBlock)(void);
typedef void(^clickGpsAction)(void);

@interface HBaseMenuView : UITableView
@property (nonatomic, assign) CellType type;
@property (nonatomic, copy) openReportBlock openReport;
@property (nonatomic, copy) clickGpsAction gpsBlock;
@property (nonatomic, strong) UIButton *gpsButton;
@property (nonatomic, strong) NSArray *safeList;
@property (nonatomic, strong) NSArray *exceptList;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)scrollToMiddle;
@end

NS_ASSUME_NONNULL_END
