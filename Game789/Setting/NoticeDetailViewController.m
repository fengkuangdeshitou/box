//
//  NoticeDetailViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/9/10.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "NoticeDetailApi.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NoticeDetailFootView.h"
#import "AutoScrollLabel.h"
#import "MyGameActivityFooterView.h"
#import "WebView.h"

@interface NoticeDetailViewController ()<NoticeDetailFootViewDelegate>

@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) UILabel   *titleLabel;
@property (strong, nonatomic) UILabel   *timeLabel;

@property (strong, nonatomic) WebView *webView;

@property (strong, nonatomic) UIImageView *bannerImageView;

@property (strong, nonatomic) NoticeDetailFootView *footView;

@property (nonatomic, strong) MyGameActivityFooterView *gameFooterView;

@end

@implementation NoticeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.footView];
    [self.view addSubview:self.webView];
    
    [self getNoticeDetailApiRequest];
}

- (void)getNoticeDetailApiRequest {
    
    NoticeDetailApi *api = [[NoticeDetailApi alloc] init];
    api.pageNumber = self.pageNumber;
    api.news_id = self.news_id;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleNoticeSuccess:(NoticeDetailApi *)api {
    if (api.success == 1) {
        self.dataDic = [[NSDictionary alloc] initWithDictionary:api.data];
        NSString *text = [self.dataDic[@"news_info"] objectForKey:@"title"];
        if (text.length > 15) {
            AutoScrollLabel *autoScrollLabel = [[AutoScrollLabel alloc]initWithFrame:CGRectMake(50, kStatusBarHeight, kScreen_width - 100, 44)];
            autoScrollLabel.text = text;
            autoScrollLabel.textColor = [UIColor blackColor];
            [self.navBar addSubview:autoScrollLabel];
        }
        else {
            self.navBar.title = text;
        }
        
        self.timeLabel.text = [self timeWithTimeIntervalString:[self.dataDic[@"news_info"] objectForKey:@"creat_date"]];
        self.webView.htmlString = [self.dataDic[@"news_info"] objectForKey:@"content"];
        //显示游戏信息
        if (self.gameInfo)
        {
            self.gameFooterView.dataDic = self.gameInfo;
            self.webView.height = kScreen_height - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin - 70;
        }
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = api.error_desc;
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.0];
    }
}

- (void)footViewPress:(NSString *)string {
    if (string.length > 0) {
        GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
        detailVC.gameID = string;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

#pragma mark - 懒加载
- (MyGameActivityFooterView *)gameFooterView
{
    if (!_gameFooterView)
    {
        _gameFooterView = [[MyGameActivityFooterView alloc] initWithFrame:CGRectMake(0, kScreenH - kTabbarSafeBottomMargin - 70, kScreenW, 70)];
        _gameFooterView.hidden = !self.gameInfo;
        [self.view addSubview:_gameFooterView];
    }
    return _gameFooterView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10+64, kScreen_width, 21)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        //        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35+64, kScreen_width, 15)];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10+kStatusBarAndNavigationBarHeight, kScreen_width, 15)];
        
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }
    return _timeLabel;
}

- (WebView *)webView
{
    if (!_webView)
    {
        _webView = [[WebView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreen_width, kScreen_height - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin)];
        _webView.backgroundColor = [UIColor clearColor];
//        _webView.allowsInlineMediaPlayback = YES;
//        _webView.mediaPlaybackRequiresUserAction=NO;
    }
    return _webView;
}

- (UIImageView *)bannerImageView {
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.timeLabel.frame.origin.y+self.timeLabel.frame.size.height, kScreen_width, 144)];
    }
    return _bannerImageView;
}

- (NoticeDetailFootView *)footView {
    if (!_footView) {
        _footView = [self createBallView];
        _footView.frame = CGRectMake(0, kScreen_height-80, kScreen_width, 80);
        _footView.delegate = self;
        if (IS_IPhoneX_All) {
            _footView.frame = CGRectMake(0, kScreen_height-90, kScreen_width, 90);
        }
    }
    return _footView;
}

- (NoticeDetailFootView *)createBallView {
    NoticeDetailFootView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoticeDetailFootView class]) owner:nil options:nil] firstObject];
    view.currentVC = self;
    return view;
}

@end
