//
//  SendFirstChargeCoverView.m
//  Game789
//
//  Created by Maiyou on 2018/11/30.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "SendFirstChargeCoverView.h"
#import "UserPayGoldViewController.h"

@implementation SendFirstChargeCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"SendFirstChargeCoverView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveFirstChargeAction:)];
        [self.showImageView addGestureRecognizer:tap];
    }
    return self;
}

- (void)setIsNoviceFuli:(BOOL)isNoviceFuli
{
    _isNoviceFuli = isNoviceFuli;
    
    if (isNoviceFuli)
    {
        self.showImageView.image = MYGetImage(@"home_novice_bg_image");
        [self.getButton setImage:MYGetImage(@"home_novice_btn_image") forState:0];
        self.imageView_width.constant = SCREEN_WIDTH - 30;
        self.imageView_height.constant = (SCREEN_WIDTH - 30) * 481 / 658;
    }
    else
    {
        if (self.isActivity)
        {
            self.btn_top.constant = 0;
            self.btn_height.constant = 0;
            self.getButton.hidden = YES;
            NSDictionary * dic = [DeviceInfo shareInstance].activityDic;
            self.showImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.imageView_width.constant = SCREEN_WIDTH - 100;
            self.imageView_height.constant = (SCREEN_WIDTH - 100) * 1.6;
            [self.showImageView yy_setImageWithURL:dic[@"img"] placeholder:MYGetImage(@"opening_notice_placeholder") options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                self.imageView_height.constant = (SCREEN_WIDTH - 100) * image.size.height / image.size.width;
            }];
        }
        else
        {
            self.imageView_width.constant  = SCREEN_WIDTH - 100;
            self.imageView_height.constant = SCREEN_WIDTH - 100;
            self.showImageView.image = MYGetImage(@"Send_first_charge_view");
        }
    }
}

- (void)setNovice_fuli_eight_time:(BOOL)novice_fuli_eight_time{
    _novice_fuli_eight_time = novice_fuli_eight_time;
    self.imageView_width.constant  = 534/2;
    self.imageView_height.constant = 300;
    self.showImageView.image = MYGetImage(@"home_novice_8_bg");
    self.getButton.hidden = YES;
    self.btn_height.constant = 0;
}

- (void)setNovice_fuli_thirty_time:(BOOL)novice_fuli_thirty_time{
    _novice_fuli_thirty_time = novice_fuli_thirty_time;
    self.imageView_width.constant  = 627/2;
    self.imageView_height.constant = 400;
    self.showImageView.image = MYGetImage(@"home_novice_30_bg");
    self.getButton.hidden = YES;
    self.btn_height.constant = 0;
}

//开屏通知的数据加载
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.btn_top.constant = 0;
    self.btn_height.constant = 0;
    self.getButton.hidden = YES;
    self.showImageView.contentMode = UIViewContentModeScaleAspectFit;

    self.imageView_width.constant = SCREEN_WIDTH - 100;
    self.imageView_height.constant = (SCREEN_WIDTH - 100) * 1.6;
    //image
    [self.showImageView yy_setImageWithURL:dataDic[@"img"] placeholder:MYGetImage(@"opening_notice_placeholder") options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        self.imageView_height.constant = (SCREEN_WIDTH - 100) * image.size.height / image.size.width;
    }];
}

- (IBAction)receiveFirstChargeAction:(id)sender
{
    [self removeFromSuperview];
    
    //开屏通知
    if (self.dataDic)
    {
//        [[YYToolModel shareInstance] showUIFortype:self.dataDic[@"link_info"][@"link_route"] Parmas:self.dataDic[@"link_info"][@"link_value"]];
        
        //如果是跳转到外部浏览器，不隐藏弹窗
        if (![self.dataDic[@"jumpType"] isEqualToString:@"outer_web"])
        {
            if (self.ClickActionBlock) {
                self.ClickActionBlock();
            }
        }
        [[YYToolModel shareInstance] showUIFortype:self.dataDic[@"jumpType"] Parmas:self.dataDic[@"value"]];
        return;
    }
    
    if (self.ClickActionBlock) {
        self.ClickActionBlock();
    }
    
    if (![YYToolModel islogin])
    {
        LoginViewController * login = [LoginViewController new];
        login.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:login animated:YES];
        return;
    }
    //是否在活动期间显示活动
    NSString * url = @"";
    if (self.isActivity)
    {
        NSString * userName = [YYToolModel getUserdefultforKey:@"user_name"];
        NSString * token = [YYToolModel getUserdefultforKey:TOKEN];
        NSDictionary * dic = [DeviceInfo shareInstance].activityDic;
        url = [dic[@"url"] urlAddCompnentForValue:userName key:@"username"];
        url = [url urlAddCompnentForValue:token key:@"token"];
        WebViewController * coin = [WebViewController new];
        coin.urlString = url;
        coin.hidesBottomBarWhenPushed  = YES;
        [self.currentVC.navigationController pushViewController:coin animated:YES];
        
        [MyAOPManager relateStatistic:@"ClickPop-upAds" Info:@{@"type":@"huodong"}];
    }
    else
    {
        if (self.isNoviceFuli || self.novice_fuli_eight_time == 1)
        {
            [MyAOPManager relateStatistic:@"ClickPop-upAds" Info:@{@"type":self.isNoviceFuli ? @"7" : @"8"}];
            UserPayGoldViewController * pay = [[UserPayGoldViewController alloc] init];
            pay.isNewWelfare = [DeviceInfo shareInstance].novice_fuli_v2101_show || [DeviceInfo shareInstance].novice_fuli_eight_time;
            pay.isFullScreen = YES;
            pay.hidesBottomBarWhenPushed = YES;
            [[YYToolModel getCurrentVC].navigationController pushViewController:pay animated:YES];
        }
        else if (self.novice_fuli_thirty_time == 1)
        {
            [MyAOPManager relateStatistic:@"ClickPop-upAds" Info:@{@"type":@"30"}];
            UserPayGoldViewController * pay = [[UserPayGoldViewController alloc] init];
            pay.reg_gt_30day_url = YES;
//            pay.isFullScreen = YES;
            pay.hidesBottomBarWhenPushed = YES;
            [[YYToolModel getCurrentVC].navigationController pushViewController:pay animated:YES];
        }
        else
        {
            [MyAOPManager relateStatistic:@"ClickPop-upAds" Info:@{@"type":@"shouchong"}];
            
            UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
            [nav.tabBarController setSelectedIndex:2];
        }
    }
}

- (IBAction)closeCoverView:(id)sender
{
    [self removeFromSuperview];
}

@end
