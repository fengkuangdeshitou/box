//
//  MBProgressHUD+QNExtension.h
//  jinsuibao
//
//  Created by QNMac on 16/4/21.
//  Copyright © 2016年 yiqiniu. All rights reserved.
//
/**
 *  注意：该分类如果需要使用showSuccess或者showError
 *  则需要自己手动添加success.png与error.png图片
 *  否则效果将和showToast一样没有图片展示
 */
#import "MBProgressHUD.h"

@interface MBProgressHUD (QNExtension)

/**  弹出进度框  */

+ (MBProgressHUD *_Nullable)showProgress:(NSString * _Nonnull)text toView:(UIView * _Nullable)view;

/**
 *  弹出Toast框
 *
 *  @param toast 要显示的内容
 *  @param view  显示的HUD放在哪个View上面
 */
+ (MBProgressHUD * _Nullable)showToast:(NSString * _Nonnull)toast toView:(UIView * _Nullable)view;
+ (MBProgressHUD * _Nullable)showToast:(NSString * _Nonnull)toast;
/**
 *  弹出成功框（Toast类型）
 *
 *  @param success 要显示的内容
 *  @param view    显示的HUD放在哪个View上面
 */
+ (MBProgressHUD * _Nullable)showSuccess:(NSString * _Nonnull)success toView:(UIView * _Nullable)view;
+ (MBProgressHUD * _Nullable)showSuccess:(NSString * _Nonnull)success;
/**
 *  弹出失败框（Toast类型）
 *
 *  @param error 要显示的内容
 *  @param view  显示的HUD放在哪个View上面
 */
+ (MBProgressHUD * _Nullable)showError:(NSString * _Nonnull)error toView:(UIView * _Nullable)view;
+ (MBProgressHUD * _Nullable)showError:(NSString * _Nonnull)error;
/**
 *  正在加载数据框
 *
 *  @param message 要显示的内容
 *  @param view    显示的HUD放在哪个View上面
 */
+ (MBProgressHUD * _Nullable)showMessage:(NSString * _Nonnull)message toView:(UIView * _Nullable)view;
+ (MBProgressHUD * _Nullable)showMessage:(NSString * _Nonnull)message;

/**
 *  隐藏MB框
 *  @param view    显示的HUD放在哪个View上面
 */
+ (void)hideHUDForView:(UIView * _Nullable)view;
+ (void)hideHUD;

@end
