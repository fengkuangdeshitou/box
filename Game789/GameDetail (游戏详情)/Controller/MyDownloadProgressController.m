//
//  MyDownloadProgressController.m
//  Game789
//
//  Created by Maiyou001 on 2022/4/28.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyDownloadProgressController.h"
#import "BTCoverVerticalTransition.h"
#import "MyDownloadVipGameApi.h"
@class MyNewDownloadVipGameApi;

@interface MyDownloadProgressController ()
{
    NSTimer * _resginTimer;
}
@property (nonatomic, assign) CGFloat resginCount;
@property (nonatomic, assign) CGFloat cutdownTime;
@property (nonatomic, assign) BOOL isSuccess;
@property(nonatomic,strong) BTCoverVerticalTransition * transition;
@property(nonatomic,strong) NSDictionary * gameInfo;
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *showProgress;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameImage;
@property (weak, nonatomic) IBOutlet UILabel *showUdid;

@end

@implementation MyDownloadProgressController

- (instancetype)initWithGameInfo:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.transition = [[BTCoverVerticalTransition alloc] initPresentViewController:self withRragDismissEnabal:NO];
        self.transitioningDelegate = self.transition;
        self.gameInfo = dic;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateCollection:self.traitCollection];
    [self.serviceBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5.5];
    
    self.showUdid.text = [NSString stringWithFormat:@"UDID：%@", [DeviceInfo shareInstance].deviceUDID];
    NSDictionary * dic = self.gameInfo[@"game_info"];
    self.gameName.text = dic[@"game_name"];
    [self.gameImage yy_setImageWithURL:[NSURL URLWithString:dic[@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    
    NSString * ios_size = dic[@"game_size"][@"ios_size"];
    if ([ios_size containsString:@"GB"])
    {
        self.cutdownTime = 90 / ([ios_size floatValue] * 1024 / 6 * 2) + 0.01;
    }
    else
    {
        self.cutdownTime = 90 / ([ios_size floatValue] / 3 * 2) + 0.01;
    }
    
    self.isSuccess = NO;
    self.resginCount = 0;
    [self.resginTimer fire];
    
    [self getNewDownloadUrl];
}

- (void)updateCollection:(UITraitCollection *)traitcollection{
    self.preferredContentSize = CGSizeMake(ScreenWidth, 280);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, 280) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
}

//个签需要的时间进度
- (NSTimer *)resginTimer
{
    if (nil == _resginTimer)
    {
        _resginTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(showResginTimer) userInfo:nil repeats:YES];
        NSRunLoop *curRun = [NSRunLoop currentRunLoop];
        [curRun addTimer:_resginTimer forMode:NSRunLoopCommonModes];
    }
    return _resginTimer;
}

- (void)showResginTimer
{
    NSString * ios_size = self.gameInfo[@"game_info"][@"game_size"][@"ios_size"];
    CGFloat time = 0;
    NSLog(@"=========%@---%f---%f---%f", [NSDate getNowTimeTimestamp], self.cutdownTime, self.resginCount, [ios_size floatValue]);
    if ([ios_size containsString:@"GB"])
    {
         time = 90 / ([ios_size floatValue] * 1024 / 6 * 2) + 0.01;
    }
    else
    {
        time = 90 / ([ios_size floatValue] / 3 * 2) + 0.01;
    }
//    if (!self.isSuccess)
//    {
        if (self.resginCount <= 99)
        {
            if (self.resginCount <= 30)
            {
                self.cutdownTime = time * [ios_size floatValue] < 100 ? 7.8 : 8.8;
            }
            else if (self.resginCount <= 60)
            {
                self.cutdownTime = time * [ios_size floatValue] < 100 ? 4.8 : 6.2;
            }
            else if (self.resginCount <= 90)
            {
                self.cutdownTime = time * [ios_size floatValue] < 100 ? 1.8 : 4.3;
            }
            else if (self.resginCount <= 99)
            {
                self.cutdownTime = time * 0.51;
            }
            self.resginCount = self.resginCount + self.cutdownTime;
            self.progressView.progress = self.resginCount / 100;
            self.showProgress.text = [NSString stringWithFormat:@"下载中，勿退出%.2f%%", self.progressView.progress * 100];
        }
//    }
//    else
//    {
//        self.showProgress.text = [NSString stringWithFormat:@"下载中，勿退出%.2f%%", self.resginCount < 100 ?: 100.00];
//    }
}

- (void)getNewDownloadUrl
{
    WEAKSELF
    NSString * gameid = self.gameInfo[@"game_info"][@"maiyou_gameid"];
    MyNewDownloadVipGameApi * api = [[MyNewDownloadVipGameApi alloc] init];
    api.gameid = gameid;
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
                    
                    if (!weakSelf.isCancle)
                    {
                        NSURL* nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", url]];
                        [[UIApplication sharedApplication] openURL:nsUrl options:@{} completionHandler:nil];
                    }
                    
                    weakSelf.isSuccess = YES;
//                    self.cutdownTime = (1 - self.progressView.progress) / 4;
                    [_resginTimer setFireDate:[NSDate distantFuture]];
                    [_resginTimer invalidate];
                    _resginTimer = nil;
                    
                    [UIView animateWithDuration:1.0 animations:^{
                        weakSelf.progressView.progress = 1;
                        weakSelf.showProgress.text = [NSString stringWithFormat:@"下载中，勿退出%.2f%%", 100.00];
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    });
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
                [self removewView];
            });
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        MYLog(@"%@----%@", request.error, request.error_desc);
        [self removewView];
    }];
}

- (void)removewView
{
    self.isSuccess = YES;
    [_resginTimer setFireDate:[NSDate distantFuture]];
    [_resginTimer invalidate];
    _resginTimer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)contactServiceClick:(id)sender
{
    WEAKSELF
    [self jxt_showAlertWithTitle:@"温馨提示" message:@"您确定要退出游戏下载吗？" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"确定").addActionDefaultTitle(@"继续等待");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 0) {
            weakSelf.isCancle = YES;
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                [_resginTimer setFireDate:[NSDate distantFuture]];
                [_resginTimer invalidate];
                _resginTimer = nil;
            }];
        }
    }];
}

- (IBAction)pasteBtnClick:(id)sender
{
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = [DeviceInfo shareInstance].deviceUDID;
    
    [MBProgressHUD showToast:@"复制成功" toView:self.view];
}

@end
