//
//  MyLoadGMGameController.m
//  Game789
//
//  Created by Maiyou on 2019/6/11.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyLoadGMGameController.h"
#import "PayViewController.h"

@interface MyLoadGMGameController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cp_channelid_top;
@property (weak, nonatomic) IBOutlet UITextField *cp_channelid;
@property (weak, nonatomic) IBOutlet UITextField *cp_gameid;

@end

@implementation MyLoadGMGameController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"测试GM游戏";
    self.cp_channelid_top.constant = kStatusBarAndNavigationBarHeight + 20;
}

- (IBAction)sureClick:(id)sender
{
    if (self.cp_channelid.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入cp渠道ID" toView:self.view];
        return;
    }
    if (self.cp_gameid.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入cp游戏ID" toView:self.view];
        return;
    }
    NSString * userName = [YYToolModel getUserdefultforKey:@"user_name"];
    NSString * xh_username   = self.xh_username;
    NSString * cp_channel_id = self.cp_channelid.text;
    NSString * cp_game_id    = self.cp_gameid.text;
    
    NSString * sign = [NSString stringWithFormat:@"%@.%@.%@.%@", xh_username, cp_game_id, cp_channel_id, @"CnTTvUVITuMEtmge3asAqRiDKbG2ieRe"];
    NSString * url = [NSString stringWithFormat:@"http://h5.zyttx.com/gmapi/center.html?user_id=%@&username=%@&game_id=%@&channel_id=%@&sign=%@", xh_username, userName, cp_game_id, cp_channel_id, [sign md5HashToLower32Bit]];
    
    [self jxt_showAlertWithTitle:@"温馨提示" message:@"如果cp那边要复制url,点击复制\n要测试GM游戏点击继续" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"复制").addActionDestructiveTitle(@"继续");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 0)
        {
            UIPasteboard * paste = [UIPasteboard generalPasteboard];
            paste.string = url;
            [MBProgressHUD showToast:@"已复制到粘贴板" toView:self.view];
        }
        else
        {
            PayViewController * webview = [PayViewController new];
            webview.requestStr = url;
            webview.gameid = self.maiyou_gameid;
            webview.xh_username = xh_username;
            [self.navigationController pushViewController:webview animated:YES];
        }
    }];
}


@end
