//
//  HWalkDownTimeView.h
//  Hikids
//
//  Created by 马腾 on 2023/6/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^sure)(void);


@interface HWalkDownTimeView : UIView
@property (nonatomic, copy) sure sureBlock;

- (instancetype)initWithContent:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
