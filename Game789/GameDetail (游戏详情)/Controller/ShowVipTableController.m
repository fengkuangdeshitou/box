//
//  ShowVipTableController.m
//  Game789
//
//  Created by Maiyou on 2018/12/4.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "ShowVipTableController.h"
#import "WebView.h"

@interface ShowVipTableController ()

@property (strong, nonatomic) WebView *webView;

@end

@implementation ShowVipTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
}

- (void)prepareBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[WebView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight)];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    //加载进度条
//    self.webView.dk_progressLayer = [[DKProgressLayer alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight - 4, DK_DEVICE_WIDTH, 4)];
//    self.webView.dk_progressLayer.progressColor = ORANGE_COLOR;
//    self.webView.dk_progressLayer.progressStyle = DKProgressStyle_Noraml;
//    [self.navBar.layer addSublayer:self.webView.dk_progressLayer];
    self.webView.htmlString = self.showText;
}

@end
