//
//  MyActivityDetailController.m
//  Game789
//
//  Created by Maiyou001 on 2021/11/23.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyActivityDetailController.h"
#import "AutoScrollLabel.h"
#import "WebView.h"
#import "GameTableViewCell.h"
#import "NoticeDetailApi.h"
#import <WebKit/WebKit.h>

@interface MyActivityDetailController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameView_top;
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation MyActivityDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gameView_top.constant = kStatusBarAndNavigationBarHeight + 10;
    self.view.backgroundColor = BackColor;
    self.showTitle.text = [self.type integerValue] == 2 ? @"攻略内容" : @"活动内容";
    
    [self getNoticeDetail];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.gameInfo];
    NSString * str = @"";
    for (NSDictionary * data in dic[@"game_classify_name"])
    {
        str = [str isEqualToString:@""] ? data[@"tagname"] : [NSString stringWithFormat:@"%@ %@", str, data[@"tagname"]];
    }
    [dic setValue:str forKey:@"game_classify_type"];
    GameTableViewCell * cell = [[NSBundle mainBundle] loadNibNamed:@"GameTableViewCell" owner:self options:nil].firstObject;
    cell.frame = CGRectMake(0, 0, kScreenW, self.gameView.height);
    cell.radiusView.layer.cornerRadius = 13;
    cell.radiusView.layer.masksToBounds = YES;
    [cell setModelDic:dic];
    [self.gameView addSubview:cell];
}

- (WKWebView *)webView
{
    if (!_webView)
    {
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) configuration:config];
        _webView.backgroundColor = [UIColor clearColor];
//        _webView.allowsInlineMediaPlayback = YES;
//        _webView.mediaPlaybackRequiresUserAction=NO;
        [self.contentView addSubview:_webView];
    }
    return _webView;
}

- (void)getNoticeDetail
{
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
        NSDictionary *dataDic = [[NSDictionary alloc] initWithDictionary:api.data];
        NSString *text = [dataDic[@"news_info"] objectForKey:@"title"];
        if (text.length > 15) {
            AutoScrollLabel *autoScrollLabel = [[AutoScrollLabel alloc]initWithFrame:CGRectMake(50, kStatusBarHeight, kScreen_width - 100, 44)];
            autoScrollLabel.text = text;
            autoScrollLabel.textColor = [UIColor blackColor];
            [self.navBar addSubview:autoScrollLabel];
        }
        else {
            self.navBar.title = text;
        }
        
        
        [self.webView loadHTMLString:[dataDic[@"news_info"] objectForKey:@"content"] baseURL:nil];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

@end
