//
//  HHomeStateCell.h
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
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

@interface HHomeStateCell : UITableViewCell

- (void)setupCellWithModel:(id)model withStyle:(CellType)cellType;

@end

NS_ASSUME_NONNULL_END
