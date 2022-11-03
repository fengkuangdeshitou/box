//
//  MyLikeButton.h
//  Game789
//
//  Created by Maiyou001 on 2022/6/30.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YYViewAnimateEffectStyle) {
    YYViewAnimateEffectStyleDefault = 0, ///默认没有效果
    YYViewAnimateEffectStyleFlash,       ///点赞闪动
    YYViewAnimateEffectStyleZoom         ///缩放效果
};

@interface MyLikeButton : UIButton

@property (nonatomic, assign) YYViewAnimateEffectStyle animateStyle;

- (void)buttonAnimationWithZoom;

- (void)likeButtonAnimationWithMark:(NSInteger)mark;

- (void)feedbackGenerator;

@end

NS_ASSUME_NONNULL_END
