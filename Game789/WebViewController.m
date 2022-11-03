//
//  WebViewController.m
//  Game789
//
//  Created by maiyou on 2021/7/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WebViewController.h"
#import "PayPlug.h"
#import "AutoScrollLabel.h"

@interface WebViewController () <WKScriptMessageHandler, WKUIDelegate, WKUIDelegate>

@property (nonatomic, strong) AutoScrollLabel *autoScrollLabel;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.urlString) {
        self.webView.urlString = self.urlString;
    }
    if (self.htmlString) {
        self.webView.htmlString = self.htmlString;
    }
    [self.view addSubview:self.webView];
    
    AutoScrollLabel *autoScrollLabel = [[AutoScrollLabel alloc]initWithFrame:CGRectMake(50, kStatusBarHeight, kScreen_width - 100, 44)];
    autoScrollLabel.textColor = [UIColor blackColor];
    autoScrollLabel.text = self.webTitle;
    autoScrollLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [self.navBar addSubview:autoScrollLabel];
    self.autoScrollLabel = autoScrollLabel;
    
    WEAKSELF
    [self.navBar setOnClickLeftButton:^{
        if ([weakSelf.webView canGoBack])
        {
            [weakSelf.webView goBack];
        }
        else
        {
            weakSelf.isDismiss ? [weakSelf dismissViewControllerAnimated:YES completion:nil] : [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    //通顶显示
    if (self.isFullScreen)
    {
        self.navBar.backgroundColor = UIColor.clearColor;
        self.navBar.titleLable.textColor = ColorWhite;
        self.autoScrollLabel.textColor = ColorWhite;
        [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back-1")];
        self.navBar.lineView.hidden = YES;
    }
}

- (void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
    self.webView.urlString = urlString;
}

- (WebView *)webView
{
    if (!_webView)
    {
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
        config.mediaTypesRequiringUserActionForPlayback = NO;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //这个类主要用来做native与JavaScript的交互管理
        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
        //注册一个js方法
        [wkUController addScriptMessageHandler:self  name:@"sdkPay"];
        [wkUController addScriptMessageHandler:self  name:@"sdkExit"];
        config.userContentController = wkUController;
        
        _webView = [[WebView alloc] initWithFrame:CGRectMake(0, self.isFullScreen ? 0 : kStatusBarAndNavigationBarHeight, kScreen_width, self.isFullScreen ? kScreen_height : kScreen_height - kStatusBarAndNavigationBarHeight)configuration:config];
        _webView.allowsBackForwardNavigationGestures = NO;
        _webView.UIDelegate = self;
        _webView.scrollView.bounces = false;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
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
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
            }
        }
    }
    else if ([message.name isEqualToString:@"sdkExit"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [MBProgressHUD showToast:@"退出了游戏" toView:[UIApplication sharedApplication].keyWindow];
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual: @"title"]) {
        self.autoScrollLabel.text = self.webTitle?:self.webView.title;
    }
}

- (void)dealloc
{
    WKUserContentController *userCC = self.webView.configuration.userContentController;
    [userCC removeScriptMessageHandlerForName:@"sdkPay"];
    [self.webView removeObserver:self forKeyPath:@"progress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
