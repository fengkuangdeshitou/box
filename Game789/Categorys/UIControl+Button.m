//
//  UIControl+Button.m
//  Game789
//
//  Created by Maiyou on 2018/8/17.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "UIControl+Button.h"

@implementation UIControl (Button)

// 静态变量
static char overview = 'a';

- (void)addMethodBlock:(ActionBlock)actionBlock WithEvents:(UIControlEvents)controlEvents{
    ///id object, const void *key, id value, objc_AssociationPolicy policy
    objc_setAssociatedObject(self, &overview, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(myAction) forControlEvents:controlEvents];
    
}

- (void)myAction{
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overview);
    if (block) {
        block(self);
    }
}

+ (UIButton *)creatButtonWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor title:(NSString *)title titleFont:(UIFont *)font actionBlock:(ActionBlock)actionBlock
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundColor:backgroundColor];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button addMethodBlock:actionBlock WithEvents:UIControlEventTouchUpInside];
    return button;
}

@end
