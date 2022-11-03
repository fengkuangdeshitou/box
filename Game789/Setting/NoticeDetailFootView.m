//
//  NoticeDetailFootView.m
//  Game789
//
//  Created by xinpenghui on 2017/9/10.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "NoticeDetailFootView.h"
#import "XHStarRateView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GameDownLoadApi.h"
#import "UIColor+HexString.h"
#import "MBProgressHUD.h"
#import "DeviceInfo.h"
@interface NoticeDetailFootView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet XHStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (strong, nonatomic) NSString *downLoadUrl;
@property (strong, nonatomic) NSString *gameID;
@property (strong, nonatomic) NSString *downLoadURL;
@property (strong, nonatomic) NSString *routeURL;
@property (nonatomic, strong) NSDictionary * data;

@end

@implementation NoticeDetailFootView

- (void)setModelDic:(NSDictionary *)dic
{
    self.data = dic;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[dic[@"image"] objectForKey:@"source"]] placeholderImage:MYGetImage(@"game_icon")];
    NSString *ios_url = [dic[@"download_url"] objectForKey:@"ios_url"];
    if ([ios_url isEqual:[NSNull null]]) {
        ios_url = @"";
    }
    self.routeURL = ios_url;
    self.nameLabel.text = dic[@"name"];
    self.gameID = dic[@"game_id"];
    self.detailLabel.text = [NSString stringWithFormat:@"%@%@|%@M", dic[@"downloadcount"], @"下载".localized, dic[@"size"]];
    XHStarRateView *view = [[XHStarRateView alloc] initWithFrame:CGRectMake(self.starRateView.frame.origin.x, self.starRateView.frame.origin.y, self.starRateView.frame.size.width, self.starRateView.frame.size.height) numberOfStars:5 rateStyle:0 isAnination:YES delegate:nil];
    self.starRateView = view;
    self.starRateView.currentScore = 5;
    self.downLoadUrl = ios_url;
//    self.downLoadUrl = @"22";

    [self.detailBtn.layer setCornerRadius:22];
//    self.detailBtn.backgroundColor = [UIColor redColor];
    if (self.downLoadUrl.length == 0) {
        //预告
        [self.detailBtn.layer setBorderColor:[UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0].CGColor];
        self.detailBtn.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
        [self.detailBtn setTitle:@"预告".localized forState:UIControlStateNormal];
        self.detailBtn.enabled = YES;
        [self.detailBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }
    else {
        //下载
        [self.detailBtn.layer setBorderColor:[UIColor colorWithRed:224.0/255 green:166.0/255 blue:168.0/255 alpha:1.0].CGColor];
        [self.detailBtn setTitle:@"下载".localized forState:UIControlStateNormal];
        self.detailBtn.enabled = NO;
        self.detailBtn.backgroundColor = [UIColor colorWithHexString:@"#f5842d"];

        [self.detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchView:)]];

    }
}
- (void)getMessageApiRequest {

    GameDownLoadApi *api = [[GameDownLoadApi alloc] init];
    //    WEAKSELF
    api.requestTimeOutInterval = 60;
    api.urls = self.routeURL;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handle1NoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handle1NoticeSuccess:(GameDownLoadApi *)api {
    if (api.success == 1) {
        self.downLoadURL = api.data[@"url"];
        NSURL* nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.downLoadURL]];
        [[UIApplication sharedApplication] openURL:nsUrl];
    }
    else {
        [MBProgressHUD showToast:[api.error_desc isKindOfClass:[NSNull class]] ? @"下载失败".localized : api.error_desc];
    }
}


- (IBAction)downLoadPress:(id)sender
{
    if ([self.data[@"game_species_type"] integerValue] == 3)
    {
        if (![YYToolModel islogin])
        {
            [self.currentVC.navigationController pushViewController:[LoginViewController new] animated:YES];
            return;
        }
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
        LoadGameViewController * game = [[LoadGameViewController alloc] init];
        game.load_url = [NSString stringWithFormat:@"%@&username=%@", self.data[@"gama_url"][@"ios_url"], userName];
        game.hidesBottomBarWhenPushed = YES;
        game.hiddenNavBar = YES;
        [self.currentVC.navigationController pushViewController:game animated:YES];
    }
    else
    {
        NSString * url = self.routeURL;
        if ([url hasPrefix:Down_Game_Url])
        {
            NSURL* nsUrl = [NSURL URLWithString:self.routeURL];
            [[UIApplication sharedApplication] openURL:nsUrl];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"GameDownloadList" object:nil];
        }
        else
        {
            [self getMessageApiRequest];
        }
    }

}

- (void)touchView:(UITapGestureRecognizer *)tap
{
    [self.delegate footViewPress:self.gameID];
//    [self getMessageApiRequest];
//    NSURL* nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",self.downLoadUrl]];
//    [[UIApplication sharedApplication] openURL:nsUrl];
}

@end
