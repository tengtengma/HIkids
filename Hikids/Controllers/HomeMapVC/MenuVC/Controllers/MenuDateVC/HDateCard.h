//
//  HDateCard.h
//  Hikids
//
//  Created by 马腾 on 2023/1/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HDateCard;

typedef void(^clickCardAction)(HDateCard *cardView);

@interface HDateCard : UIView
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, copy) clickCardAction clickBlock;


@end

NS_ASSUME_NONNULL_END
