//
//  TuuHUD.m
//  test
//
//  Created by 张鸿 on 16/9/2.
//  Copyright © 2016年 张鸿. All rights reserved.
//

#import "TuuHUD.h"
#import "JGProgressHUD.h"
#import "TUAlerterView.h"

@implementation TuuHUD
//+ (void)showSuccessWithStr:(NSString *)str afterDelay:(CGFloat)time 

+ (void)showSuccessWithStr:(NSString *)str
{
    
    
    [self setHUDViewClass:[JGProgressHUDSuccessIndicatorView class] message:str];
}


+ (void)showErrorWithStr:(NSString *)str
{
    [self setHUDViewClass:[JGProgressHUDErrorIndicatorView class] message:str];
    
}

+ (void)showmessage:(NSString *)str
{
    TUAlerterView *alert =  [TUAlerterView sharedInstance];
    [alert showWithTitle:str];
}

+ (void)setHUDViewClass:(Class)class message:(NSString *)mess
{
    
    
    UIView *kewin = [UIApplication sharedApplication].keyWindow;
    
    JGProgressHUD *HUD =  [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    
    HUD.textLabel.text = mess;
    
    HUD.indicatorView =  [[class alloc] init];
    
    HUD.square = YES;
    
    [HUD showInView:kewin];
    
    [HUD dismissAfterDelay:1.5];
}
@end
