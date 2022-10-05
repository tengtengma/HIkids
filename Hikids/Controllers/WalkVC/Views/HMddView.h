//
//  HMddView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickMddViewAction)(NSString *mId);

@interface HMddView : UIView
@property (nonatomic, copy) clickMddViewAction clickMddBlock;

- (void)setupWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
