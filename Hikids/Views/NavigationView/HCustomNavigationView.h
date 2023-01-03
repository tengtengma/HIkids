//
//  HCustomNavigationView.h
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCustomNavigationView : UIView

- (instancetype)init;

- (void)defautInfomation;

- (void)safeStyleWithName:(NSString *)typeName;
- (void)dangerStyleWithName:(NSString *)typeName;


@end

NS_ASSUME_NONNULL_END
