//
//  YJProgressHUD.m
//  PictureHouseKeeper
//
//  Created by 李亚军 on 16/8/19.
//  Copyright © 2016年 zyyj. All rights reserved.
//

#import "YJProgressHUD.h"

@implementation YJProgressHUD

+(instancetype)shareinstance{
    
    static YJProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YJProgressHUD alloc] init];
    });
    
    return instance;
    
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(YJProgressMode)myMode{
    [self show:msg inView:view mode:myMode customImgView:nil];
}

+(void)show:(NSString *)msg inView:(UIView *)view mode:(YJProgressMode)myMode customImgView:(UIImageView *)customImgView{
    //如果已有弹框，先消失
    
    if ([YJProgressHUD shareinstance].hud != nil) {
//        [[YJProgressHUD shareinstance].hud hideAnimated:YES];
//        [YJProgressHUD shareinstance].hud = nil;
        return;
    }
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        //4\4s屏幕避免键盘存在时遮挡
        if ([UIScreen mainScreen].bounds.size.height == 480) {
            [view endEditing:YES];
        }
        
        [YJProgressHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        
        //这里设置是否显示遮罩层
        //[YJProgressHUD shareinstance].hud.dimBackground = YES;    //是否显示透明背景
        
        //是否设置黑色背景，这两句配合使用
        [YJProgressHUD shareinstance].hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        [YJProgressHUD shareinstance].hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [YJProgressHUD shareinstance].hud.contentColor = [UIColor whiteColor];
        [YJProgressHUD shareinstance].hud.margin = 22;
        [YJProgressHUD shareinstance].hud.detailsLabel.text = [NSString stringWithFormat:@"%@  ",msg];
        [YJProgressHUD shareinstance].hud.removeFromSuperViewOnHide = true;
        [YJProgressHUD shareinstance].hud.bezelView.layer.cornerRadius = 14;
//        [[YJProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.5];
        [YJProgressHUD shareinstance].hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        switch (myMode) {
            case YJProgressModeOnlyText:
                [YJProgressHUD shareinstance].hud.mode = MBProgressHUDModeText;
                break;

            case YJProgressModeLoading:
                [YJProgressHUD shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
                break;

            case YJProgressModeCircle:{
                [YJProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
                UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
                CABasicAnimation *animation= [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                animation.toValue = [NSNumber numberWithFloat:M_PI*2];
                animation.duration = 1.5;
                animation.repeatCount = 100;
                [img.layer addAnimation:animation forKey:nil];
                [YJProgressHUD shareinstance].hud.customView = img;
                
                
                break;
            }
            case YJProgressModeCustomerImage:
                [YJProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
                [YJProgressHUD shareinstance].hud.customView = customImgView;
                break;

            case YJProgressModeCustomAnimation:
                //这里设置动画的背景色
                [YJProgressHUD shareinstance].hud.bezelView.color = [UIColor clearColor];
                
                
                [YJProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
                [YJProgressHUD shareinstance].hud.customView = customImgView;
                
                break;

            case YJProgressModeSuccess:
                [YJProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
                [YJProgressHUD shareinstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_success"]];
                break;

            default:
                break;
        }
    
//    });
    
}
    

+(void)hide{
    if ([YJProgressHUD shareinstance].hud != nil) {
        [[YJProgressHUD shareinstance].hud hideAnimated:YES];
        [YJProgressHUD shareinstance].hud = nil;
    }
}


+(void)showMessage:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:YJProgressModeOnlyText];
    [[YJProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.5];
}



+(void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg inView:view mode:YJProgressModeOnlyText];
    [[YJProgressHUD shareinstance].hud hideAnimated:YES afterDelay:delay];
}

+(void)showSuccess:(NSString *)msg inview:(UIView *)view{
    [self show:msg inView:view mode:YJProgressModeSuccess];
    [[YJProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.5];
    
}

+(void)showMessage:(NSString *)msg imageName:(NSString *)imageName inview:(UIView *)view{
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [self show:msg inView:view mode:YJProgressModeCustomerImage customImgView:img];
    [[YJProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.5];
}


+(void)showProgress:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:YJProgressModeLoading];
}

+(MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.detailsLabel.text = msg;
    return hud;
    
    
}

+(void)showProgressCircleNoValue:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:YJProgressModeCircle];
    
}


+(void)showMsgWithoutView:(NSString *)msg{
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [self show:msg inView:view mode:YJProgressModeOnlyText];
    [[YJProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.5];
    
}

+(void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view{
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:1.2];
    [showImageView startAnimating];
    
    [self show:msg inView:view mode:YJProgressModeCustomAnimation customImgView:showImageView];
}

@end
