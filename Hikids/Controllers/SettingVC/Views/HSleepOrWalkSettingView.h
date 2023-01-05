//
//  HSleepOrWalkSettingView.h
//  Hikids
//
//  Created by 马腾 on 2023/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum _Type
{
    type_Sleep = 0,
    type_Walk = 1,
}Type;

typedef void(^closeSWViewBlock)(void);
@interface HSleepOrWalkSettingView : UIView
@property (nonatomic, copy) closeSWViewBlock closeSwBlock;

- initWithType:(Type)type;
@end

NS_ASSUME_NONNULL_END
