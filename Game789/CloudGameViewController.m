//
//  CloudGameViewController.m
//  Game789
//
//  Created by maiyou on 2021/6/18.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "CloudGameViewController.h"
#import <WebKit/WebKit.h>
#import "PayPlug.h"
#import "CloudGameSuspensionView.h"

@interface CloudGameViewController ()<WKScriptMessageHandler,WKUIDelegate,WKUIDelegate,CloudGameSuspensionViewDelegate>

@property (strong, nonatomic) WKWebView * webView;

@end

@implementation CloudGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *encodedString = [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
//    request = [YYToolModel requestHeaderAddParas:request];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CloudGameSuspensionView * suspensionView = [[CloudGameSuspensionView alloc] initWithFrame:CGRectMake(kScreenW-150, kStatusBarAndNavigationBarHeight+44, 150, 36)];
//        suspensionView.delegate = self;
//        [self.webView addSubview:suspensionView];
//    });
}
 
- (void)onImageQualityAction{
    NSString *jsString = [NSString stringWithFormat:@"onQualitySetting()"];
    [self.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"result=%@,error=%@",result,error);
    }];
}

- (void)onExitAction{
    NSString *jsString = [NSString stringWithFormat:@"onExitGame()"];
    [self.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"result=%@,error=%@",result,error);
    }];
}

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.requiresUserActionForMediaPlayback = NO;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //这个类主要用来做native与JavaScript的交互管理
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        //注册一个js方法
        [wkUController addScriptMessageHandler:self  name:@"sdkPay"];
        [wkUController addScriptMessageHandler:self  name:@"sdkExit"];
        config.userContentController = wkUController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)configuration:config];
        _webView.allowsBackForwardNavigationGestures = NO;
        _webView.UIDelegate = self;
        _webView.scrollView.bounces = false;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"message=%@",message);
    completionHandler();
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"===%@",message.body);
    if ([message.name isEqualToString:@"sdkPay"]) {
        NSString * url = message.body;
        if ([url hasPrefix:@"alipay"]) {
            PayPlug *pay =  [PayPlug sharedInstance];
            NSLog(@"payorder:{%@}",url);
            [pay h5ToNativePay:url];
        }else{
            if ([url hasPrefix:@"weixin"]) {
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:url]];
            }
        }
    }
    else if ([message.name isEqualToString:@"sdkExit"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [MBProgressHUD showToast:@"退出了游戏" toView:[UIApplication sharedApplication].keyWindow];
        }];
    }
}

- (void)dealloc
{
    WKUserContentController *userCC = self.webView.configuration.userContentController;
    [userCC removeScriptMessageHandlerForName:@"sdkPay"];
}

@end
