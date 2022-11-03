//
//  UIView+Animation.h
//  Game789
//
//  Created by maiyou on 2022/6/30.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+TYAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Animation)

@property(nonatomic,strong)TYAlertController * alertController;

- (void)showAnimationWithSpace:(CGFloat)space;

- (void)dismissAnimation;

@end

NS_ASSUME_NONNULL_END
