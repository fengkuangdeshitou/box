//
//  MBProgressHUD+QNExtension.m
//  jinsuibao
//
//  Created by QNMac on 16/4/21.
//  Copyright © 2016年 yiqiniu. All rights reserved.
//

#import "MBProgressHUD+QNExtension.h"

@implementation MBProgressHUD (QNExtension)

+ (MBProgressHUD *)showProgress:(NSString *)text toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // 再设置模式
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = text;
    
    return hud;
}

#pragma mark - 显示Toast普通消息
+ (MBProgressHUD *)showToast:(NSString * _Nonnull)toast{
    return [self show:toast.localized icon:nil view:nil];
}
+ (MBProgressHUD *)showToast:(NSString * _Nonnull)toast toView:(UIView * _Nullable)view{
    return [self show:toast.localized icon:nil view:view];
}
#pragma mark - 显示Toast成功消息
+ (MBProgressHUD *)showSuccess:(NSString *)success{
    return [self showSuccess:success.localized toView:nil];
}
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view{
    return [self show:success.localized icon:@"mb_success.png" view:view];
}
#pragma mark - 显示Toast错误消息
+ (MBProgressHUD *)showError:(NSString *)error{
    return [self showError:error toView:nil];
}
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view{
    return [self show:error icon:@"mb_error.png" view:view];
}
#pragma mark - 隐藏信息
+ (void)hideHUD{
    [self hideHUDForView:nil];
}
+ (void)hideHUDForView:(UIView *)view{
    [self hideHUDForView:view animated:YES];
}
#pragma mark - 数据加载显示框
+ (MBProgressHUD *)showMessage:(NSString *)message{
    return [self showMessage:message toView:nil];
}
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (!message || message.length == 0) {
        hud.label.text = nil;
    }else{
        hud.label.text = message.localized;
    }
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

#pragma mark - 显示信息
+ (MBProgressHUD *)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    [self hideHUDForView:view];
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.font = [UIFont systemFontOfSize:16.f];
    hud.userInteractionEnabled = NO;
    hud.detailsLabel.text = text;
    // 设置图片
    if (icon) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    }
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 2秒之后再消失
    [hud hideAnimated:YES afterDelay:2];
    return hud;
}
@end
