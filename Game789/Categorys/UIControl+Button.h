//
//  UIControl+Button.h
//  Game789
//
//  Created by Maiyou on 2018/8/17.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// 创建block
typedef void (^ActionBlock)(UIControl *control);

@interface UIControl (Button)

// 封装button的点击方法
- (void)addMethodBlock:(ActionBlock)actionBlock WithEvents:(UIControlEvents)controlEvents;

// 快速创建button并执行block中的点击方法
+ (UIButton *)creatButtonWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor title:(NSString *)title titleFont:(UIFont *)font actionBlock:(ActionBlock)actionBlock;


@end
