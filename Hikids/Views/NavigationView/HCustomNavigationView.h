//
//  HCustomNavigationView.h
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCustomNavigationView : UIView
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *markImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
