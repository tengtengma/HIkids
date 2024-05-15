//
//  HSetAlertCell.h
//  Hikids
//
//  Created by 马腾 on 2024/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^selectItemBlock)(NSString *soundId,NSString *soundName);

@interface HSetAlertView : UIView
@property (nonatomic, strong) NSString *soundId;
@property (nonatomic, copy) selectItemBlock selectBlock;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;



- (instancetype)init;
- (void)selectStyle;
- (void)selectNomalStyle;
@end

NS_ASSUME_NONNULL_END
