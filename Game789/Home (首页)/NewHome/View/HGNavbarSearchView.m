//
//  HGNavbarSearchView.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/19.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGNavbarSearchView.h"

#import "MyMainSearchViewController.h"
#import "MyCustomerServiceController.h"

@implementation HGNavbarSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"HGNavbarSearchView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

- (void)setIsGameDetail:(BOOL)isGameDetail
{
    _isGameDetail = isGameDetail;
    
    [self.showBtn1 setImage:MYGetImage(@"home_service_icon") forState:0];
    [self.showBtn2 setImage:MYGetImage(@"home_search_icon") forState:0];
}

- (void)setIsCollected:(BOOL)isCollected
{
    _isCollected = isCollected;
    
    [self.showBtn1 setImage:isCollected ? MYGetImage(@"detail_collected_icon") : MYGetImage(@"detail_collect_icon") forState:0];
}

- (void)setIsVideo:(BOOL)isVideo
{
    _isVideo = isVideo;
    
    [self.showBtn1 setImage:MYGetImage(@"home_service_icon") forState:0];
    
    if (isVideo)
    {
        [self.showBtn2 setImage:MYGetImage(@"home_video_Type_icon") forState:0];
    }
    else
    {
//        [self.showBtn1 setImage:MYGetImage(@"home_download_icon") forState:0];
        [self.showBtn2 setImage:MYGetImage(@"home_search_icon") forState:0];
//        self.showBtn1.hidden = NO;
    }
}

- (IBAction)downloadBtnClick:(id)sender
{
    MyCustomerServiceController * service = [MyCustomerServiceController new];
    [[YYToolModel getCurrentVC].navigationController pushViewController:service animated:YES];
}

- (IBAction)searchBtnClick:(id)sender
{
    if (self.isGameDetail)
    {//分享
        if ([YYToolModel islogin])
        {
//            HGActivityDetailController * detail = [HGActivityDetailController new];
//            detail.hidesBottomBarWhenPushed = YES;
//            detail.loadUrl = [NSURL URLWithString:HGInviteFriendUrl];
//            [[YYToolModel getCurrentVC].navigationController pushViewController:detail animated:YES];
        }
    }
    else if (self.isVideo)
    {//视频
        if (self.SearchBtnClick)
        {
            self.SearchBtnClick(self.isVideo);
        }
    }
    else
    {//搜索
        MyMainSearchViewController * search = [MyMainSearchViewController new];
        search.hidesBottomBarWhenPushed = YES;
        search.isHome = self.isHome;
        [self.currentVC.navigationController pushViewController:search animated:YES];
    }
}

- (void)collectGame
{
    if (!self.gameId) return;
    
    if ([YYToolModel islogin])
    {
//        [YYBaseApi yy_Post:self.isCollected ? CancelCollectedGame : CollectGame parameters:@{@"id":self.gameId} swpNetworkingSuccess:^(id  _Nonnull resultObject) {
//            self.isCollected = !self.isCollected;
//            [YJProgressHUD showMessage:self.isCollected ? @"收藏成功" : @"已取消收藏" inView:self.currentVC.view];
//        } swpNetworkingError:^(NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
//            
//        } Hud:YES];
    }
}

@end
