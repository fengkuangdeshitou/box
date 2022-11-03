//
//  UIView+Animation.m
//  Game789
//
//  Created by maiyou on 2022/6/30.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "UIView+Animation.h"
#import <objc/runtime.h>

@implementation UIView (Animation)

- (void)setAlertController:(TYAlertController *)alertController{
    objc_setAssociatedObject(self, @selector(alertController), alertController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TYAlertController *)alertController{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)showAnimationWithSpace:(CGFloat)space{
    self.width = ScreenWidth-space*2;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.alertController = [TYAlertController alertControllerWithAlertView:self];
    self.alertController.backgoundTapDismissEnable = true;
    [[YYToolModel getCurrentVC] presentViewController:self.alertController animated:YES completion:nil];
}

- (void)dismissAnimation{
    [self.alertController dismissViewControllerAnimated:true];
}

@end
