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
@property (nonatomic, strong) UIImageView *stateImageView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *updateTimeLabel;

- (instancetype)init;

- (void)defautInfomation;


@end

NS_ASSUME_NONNULL_END
