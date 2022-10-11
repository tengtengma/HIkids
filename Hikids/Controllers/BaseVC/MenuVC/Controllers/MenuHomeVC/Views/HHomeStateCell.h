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

typedef void(^expandAction)(void);

@interface HHomeStateCell : UITableViewCell
@property (nonatomic, copy) expandAction expandBlock;
@property (nonatomic, strong) NSArray *exceptArray;
@property (nonatomic, strong) NSArray *nomalArray;

- (void)setupCellwithStyle:(CellType)cellType;
- (void)setupCellWithExpandWithModel:(id)model withIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
