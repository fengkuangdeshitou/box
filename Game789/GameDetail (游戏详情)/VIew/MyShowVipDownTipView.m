//
//  MyShowVipDownTipView.m
//  Game789
//
//  Created by Maiyou001 on 2021/6/10.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyShowVipDownTipView.h"
#import "UserPayGoldViewController.h"
#import "PayAlertView.h"
@interface MyShowVipDownTipView ()


@end

@implementation MyShowVipDownTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyShowVipDownTipView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tap];
        
        self.bgImgaeView_width.constant = 865 * (kScreenW - 40) / 747;
    }
    return self;
}

- (void)setIsUserVip:(BOOL)isUserVip
{
    _isUserVip = isUserVip;
    
    if (!isUserVip)
    {
        self.bgImgaeView_width.constant = 865 * (kScreenW - 100) / 747;
    }
    [self.downloadBtn setTitle:!isUserVip ? @"领取福利>" : @"下载" forState:0];
    self.backView.hidden = !isUserVip;
    self.downloadBtn.hidden = isUserVip;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:!isUserVip ? [DeviceInfo shareInstance].getUdidAlert : [DeviceInfo shareInstance].udidAlertBuy]];
}

- (IBAction)downBtnClick:(id)sender
{
    [self removeFromSuperview];
    
    UIButton * button = sender;
    if (button.tag == 100)
    {
        if (!self.isUserVip)
        {
            PayAlertView * webView = [[PayAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
            webView.url = self.supremePayUrl;
            [UIApplication.sharedApplication.keyWindow addSubview:webView];
        }
        else
        {
            NSString * udid = [DeviceInfo shareInstance].deviceUDID;
            if (udid == NULL)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[DeviceInfo shareInstance].getUdidUrl]];
            }
            else
            {
                if (self.vipAppInstallBlock) {
                    self.vipAppInstallBlock();
                }
            }
        }
    }
    else if (button.tag == 101)
    {
        if (self.vipAppInstallBlock) {
            self.vipAppInstallBlock();
        }
    }
    else if (button.tag == 102)
    {
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"https://app.milu.com/?a=%@", [DeviceInfo shareInstance].channel]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)tapClick
{
    [self removeFromSuperview];
}

@end
