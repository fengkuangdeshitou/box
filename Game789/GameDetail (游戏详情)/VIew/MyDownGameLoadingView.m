//
//  MyDownGameLoadingView.m
//  Game789
//
//  Created by Maiyou on 2019/7/24.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyDownGameLoadingView.h"
#import <UIImage+GIF.h>
#import "MyDownloadVipGameApi.h"
@class MyNewDownloadVipGameApi;

@implementation MyDownGameLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyDownGameLoadingView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];

        self.imageView1.image = [UIImage hx_animatedGIFWithData:[self dataWithImage]];
        self.resginCount = 0;
    }
    return self;
}

- (void)setGameid:(NSString *)gameid
{
    _gameid = gameid;
  
    if ([gameid isEqualToString:@"152"] || self.downType == 2)
    {
        [self.resginTimer fire];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
//        [self getDownloadUrl];
        [self getNewDownloadUrl];
    });
}

- (NSData *)dataWithImage
{
    NSString * path = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"load1.gif" ofType:nil];
    NSData * data = [NSData dataWithContentsOfFile:path];
    return data;
}

//个签需要的时间进度
- (NSTimer *)resginTimer
{
    if (nil == _resginTimer)
    {
        _resginTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(showResginTimer) userInfo:nil repeats:YES];
        NSRunLoop *curRun = [NSRunLoop currentRunLoop];
        [curRun addTimer:_resginTimer forMode:NSRunLoopCommonModes];
    }
    return _resginTimer;
}

- (void)showResginTimer
{
//    if (self.resginCount % 3 == 0 && !self.isSuccess)
//    {
//        [self getDownloadUrl];
//    }
    
    self.resginCount ++;
    if (self.resginCount % 10 == 0)
    {
        self.resginCount = 0;
        self.stepNum ++;
    }
    
    if (self.stepNum == 0)
    {
        self.showStatus1.text = @"打包中";
        self.imageView1.image = [UIImage hx_animatedGIFWithData:[self dataWithImage]];
    }
    else if (self.stepNum == 1)
    {
        self.showStatus1.text = @"打包完成";
        self.imageView1.image = [UIImage hx_animatedGIFWithData:[self dataWithImage]];
    }
    else if (self.stepNum == 2)
    {
        self.showStatus2.text = @"签名中";
        self.imageView1.image = [UIImage imageNamed:@"success_selected"];
        self.imageView2.image = [UIImage hx_animatedGIFWithData:[self dataWithImage]];
    }
    else if (self.stepNum == 3)
    {
        self.showStatus2.text = @"签名完成";
        self.imageView1.image = [UIImage imageNamed:@"success_selected"];
        self.imageView2.image = [UIImage hx_animatedGIFWithData:[self dataWithImage]];
    }
    else
    {
        self.showStatus3.text = @"正在下载";
        self.imageView1.image = [UIImage imageNamed:@"success_selected"];
        self.imageView2.image = [UIImage imageNamed:@"success_selected"];
        self.imageView3.image = [UIImage hx_animatedGIFWithData:[self dataWithImage]];
    }
}

- (void)removewView
{
    self.isSuccess = YES;
    [_resginTimer setFireDate:[NSDate distantFuture]];
    [_resginTimer invalidate];
    _resginTimer = nil;
    [self removeFromSuperview];
}

- (void)getNewDownloadUrl
{
    MyNewDownloadVipGameApi * api = [[MyNewDownloadVipGameApi alloc] init];
    api.gameid = self.gameid;
    api.isToastErrorDesc = YES;
    api.requestTimeOutInterval = 600;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        NSInteger code = [request.data[@"code"] integerValue];
        NSString * url = request.data[@"url"];
        NSString * msg = request.data[@"msg"];
        if (code == 0)
        {
            if (url)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self.isSuccess)
                    {
                        //盒子更新下载
                        if (self.gameid.integerValue == 152 || self.downType == 2)
                        {
                            [MBProgressHUD showMessage:@"加载中" toView:[UIApplication sharedApplication].delegate.window];
                            NSURL* nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", url]];
                            [[UIApplication sharedApplication] openURL:nsUrl options:@{} completionHandler:nil];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window];
                            });
                            if (self.gameid.integerValue == 152)
                            {
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    exit(0);
                                });
                            }
                        }
                        //回传下载地址
                        if (self.GetVipGameDownUrl)
                        {
                            NSString * urlStr = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", url];
                            self.GetVipGameDownUrl(code, urlStr);
                        }
                    }
                    [self removewView];
                });
            }
        }
        else if (code == 1)
        {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    [self getNewDownloadUrl];
//                });
//            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (msg)
                {
                    [MBProgressHUD showToast:msg toView:[UIApplication sharedApplication].delegate.window];
                }
                [self removewView];
                self.GetVipGameDownUrl(code, @"");
            });
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        MYLog(@"%@----%@", request.error, request.error_desc);
//        if (self.requestCount == 0)
//        {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    [self getNewDownloadUrl];
//                    self.resginCount ++;
//                });
//            });
//        }
//        else
//        {
            [self removewView];
//        }
    }];
}

- (void)getDownloadUrl
{
    MyDownloadVipGameApi * api = [[MyDownloadVipGameApi alloc] init];
    api.gameid = self.gameid;
    api.isToastErrorDesc = YES;
    api.requestTimeOutInterval = 60;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
//        NSInteger code = [request.data[@"code"] integerValue];
//        NSString * url = request.data[@"url"];
        NSInteger code = 1;
        NSString * url = @"https%3A%2F%2Fiosd.milu.com%2F152%2F3rfs%2Fmanifest%3FosVersion%3D14.5.1";
        NSString * msg = request.data[@"msg"];
        if (code == 1)
        {
            if (url)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self.isSuccess)
                    {
                        //盒子更新下载
                        if (self.gameid.integerValue == 152 || self.downType == 2)
                        {
                            [MBProgressHUD showMessage:@"加载中" toView:[UIApplication sharedApplication].delegate.window];
                            NSURL* nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", [url URLEncodedString]]];
                            [[UIApplication sharedApplication] openURL:nsUrl];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window];
                            });
                            if (self.gameid.integerValue == 152)
                            {
                                exit(0);
                            }
                        }
                        
                        //回传下载地址
                        if (self.GetVipGameDownUrl)
                        {
                            NSString * urlStr = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", url];
                            self.GetVipGameDownUrl(code, urlStr);
                        }
                    }
                    [self removewView];
                });
            }
        }
        else if (code < 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (msg)
                {
                    [MBProgressHUD showToast:msg toView:[UIApplication sharedApplication].delegate.window];
                }
                else
                {
                    NSString * str = [NSString stringWithFormat:@"%@%ld%@", @"下载文件失败".localized, (long)code, @"，请稍后重试".localized];
                    [MBProgressHUD showToast:str toView:[UIApplication sharedApplication].delegate.window];
                }
                [self removewView];
                self.GetVipGameDownUrl(code, @"");
            });
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self getDownloadUrl];
                });
            });
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self getDownloadUrl];
            });
        });
    }];
}

@end
