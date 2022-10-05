//
//  HSmallCardView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickCardView)(void);

@interface HSmallCardView : UIView
@property (nonatomic, strong) UILabel *safeLabel;
@property (nonatomic, strong) UILabel *dangerLabel;
@property (nonatomic, copy) clickCardView clickBlock;

- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
