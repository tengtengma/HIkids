//
//  HCustomNavigationView.h
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickHeaderBlock)(void);

@interface HCustomNavigationView : UIView
@property (nonatomic, copy) clickHeaderBlock clickHeader;

- (instancetype)init;

- (void)defautInfomation;



@end

NS_ASSUME_NONNULL_END
