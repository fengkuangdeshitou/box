//
//  MyGameGiftDetailView.m
//  Game789
//
//  Created by Maiyou on 2021/1/19.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyGameGiftDetailView.h"
#import "QueryGameAccountAPI.h"
#import "GetGiftApi.h"

@implementation MyGameGiftDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyGameGiftDetailView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:dataDic[@"new_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    
    self.showTime.text = [NSString stringWithFormat:@"有效期：%@", [NSDate dateWithFormat:@"yyyy-MM-dd" WithTS:[dataDic[@"gift_dealine"] doubleValue]]];
    
    self.showGiftName.text = dataDic[@"gift_name"];
    
    self.showGiftContent.text = dataDic[@"gift_desc"];
    
    self.showGiftDesc.text = dataDic[@"gift_introduce"];
    
    self.receiveBtn.hidden = !self.isReceived;
}

- (IBAction)closeBtnClick:(id)sender
{
    [[YYToolModel getCurrentVC] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)receiveBtnClick:(id)sender
{
    [self receiveGift];
}

- (void)receiveGift
{
    if (![YYToolModel islogin])
    {
        [[YYToolModel getCurrentVC] dismissViewControllerAnimated:YES completion:^{
            [[YYToolModel getCurrentVC].navigationController pushViewController:[[LoginViewController alloc] init] animated:true];
        }];
        return;
    }
    
    QueryGameAccountAPI * api = [[QueryGameAccountAPI alloc] init];
    api.maiyou_gameid = self.dataDic[@"maiyou_gameid"];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            BOOL isExists = [request.data[@"isExists"] boolValue];
            if (isExists) {
                [self handGif];
            }else{
                [JXTAlertView showAlertViewWithTitle:@"温馨提示" message:@"您游戏中还未创建小号，暂时无法领取此礼包" cancelButtonTitle:@"稍后再领" otherButtonTitle:[self.dataDic[@"game_type"] intValue] == 3 ? @"进入游戏" : @"下载游戏" cancelButtonBlock:^(NSInteger buttonIndex) {
                    if ([self.vc isKindOfClass:[GameDetailInfoController class]]) {
                        [MyAOPManager relateStatistic:@"CancelDownloadOfGameDetailGift" Info:@{@"giftname":self.dataDic[@"gift_name"],@"gameName":self.dataDic[@"game_name"]}];
                    }else if ([self.vc isKindOfClass:NSClassFromString(@"WelfareCentreViewController")]){
                        [MyAOPManager relateStatistic:@"CancelDownloadOfWelfareCenterGift" Info:@{@"giftname":self.dataDic[@"gift_name"],@"gameName":self.dataDic[@"game_name"]}];
                    }else if ([self.vc isKindOfClass:NSClassFromString(@"MyProjectGameController")]){
                        [MyAOPManager relateStatistic:@"CancelDownloadOfProjectGift" Info:@{@"giftname":self.dataDic[@"gift_name"],@"gameName":self.dataDic[@"game_name"]}];
                    }else if ([self.vc isKindOfClass:NSClassFromString(@"RecommendViewController")]){
                        [MyAOPManager relateStatistic:@"CancelDownloadOfOneGametGift" Info:@{@"giftname":self.dataDic[@"gift_name"],@"gameName":self.dataDic[@"game_name"]}];
                    }
                } otherButtonBlock:^(NSInteger buttonIndex) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self download];
                    });
                }];
            }
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)download{
    if (![self.vc isKindOfClass:[GameDetailInfoController class]]) {
        if ([self.vc isKindOfClass:NSClassFromString(@"WelfareCentreViewController")]){
            [MyAOPManager relateStatistic:@"DownloadGameOfWelfareCenterGift" Info:@{@"giftname":self.dataDic[@"gift_name"],@"gameName":self.dataDic[@"game_name"]}];
        }else if ([self.vc isKindOfClass:NSClassFromString(@"MyProjectGameController")]){
            [MyAOPManager relateStatistic:@"DownloadGameOfProjectGift" Info:@{@"giftname":self.dataDic[@"gift_name"],@"gameName":self.dataDic[@"game_name"]}];
        }else if ([self.vc isKindOfClass:NSClassFromString(@"RecommendViewController")]){
            [MyAOPManager relateStatistic:@"DownloadGameOfOneGameGift" Info:@{@"giftname":self.dataDic[@"gift_name"],@"gameName":self.dataDic[@"game_name"]}];
        }
        [[YYToolModel getCurrentVC] dismissViewControllerAnimated:YES completion:^{
            GameDetailInfoController * detail = [[GameDetailInfoController alloc] init];
            detail.maiyou_gameid = self.dataDic[@"maiyou_gameid"];
            detail.c = @"1";
            [[YYToolModel getCurrentVC].navigationController pushViewController:detail animated:true];
        }];
        return;
    }else{
        [MyAOPManager relateStatistic:@"DownloadGameOfGameDetailGift" Info:@{@"giftname":self.dataDic[@"gift_name"],@"gameName":self.dataDic[@"game_name"]}];
        
        if (self.receivedGiftCodeBlock) {
            self.receivedGiftCodeBlock();
        }
        
        [[YYToolModel getCurrentVC] dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

- (void)handGif{
    GetGiftApi *api = [[GetGiftApi alloc] init];
    api.gift_id = self.gift_id;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleGiftSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {

    }];
}

- (void)handleGiftSuccess:(GetGiftApi *)api
{
    [[YYToolModel getCurrentVC] dismissViewControllerAnimated:YES completion:^{
        
    
    if (api.success == 1)
    {
        //领取成功
//        if (self.receivedGiftCodeBlock) {
//            self.receivedGiftCodeBlock();
//        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveGiftSuccess" object:self.gift_id];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refrefshGiftNotification" object:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString * code = [NSString stringWithFormat:@"礼包码为：%@", api.data[@"data"]];
            [[YYToolModel getCurrentVC] jxt_showAlertWithTitle:@"领取成功" message:code appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.
                addActionDefaultTitle(@"取消".localized).
                addActionDestructiveTitle(@"复制".localized);
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                if (buttonIndex == 1) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = api.data[@"data"];
                    [MBProgressHUD showToast:@"已复制到粘贴板"];
                }
            }];
        });
    }
    else
    {
        NSDictionary * data = api.responseObject;
        if (![data[@"status"][@"error_code"] isEqual:[NSNull null]] && [data[@"status"][@"error_code"] intValue] == 2001){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MyAlertConfigure * configure = [MyAlertConfigure new];
                configure.btnTitleColors = @[ColorWhite];
                configure.btnBackColors = @[MAIN_COLOR];
                configure.btnTitles = @[@"开通会员"];
                configure.content = api.error_desc;
                [MyAlertView alertViewWithConfigure:configure buttonBlock:^(NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
                        payVC.selectedIndex = 1;
                        payVC.hidesBottomBarWhenPushed = YES;
                        [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
                    }
                }];
            });
        }else{
            [MBProgressHUD showToast:api.error_desc toView:[YYToolModel getCurrentVC].view];
        }
    }
    }];
}

@end
