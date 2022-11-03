//
//  UserPayGoldViewController.m
//  Game789
//
//  Created by Maiyou on 2018/6/20.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "UserPayGoldViewController.h"

#import "ShareVale.h"
#import "WXUtil.h"
#import "TuuHUD.h"
#import "PayPlug.h"
#import "WMDragView.h"
#import <AliPaySDK/AlipaySDK.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WebView.h"

//首先创建一个实现了JSExport协议的协议
@protocol JSObjectProtocol <JSExport>

- (void)viewClose;

@end

@interface UserPayGoldViewController ()<UIAlertViewDelegate, JSObjectProtocol, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, copy) NSString *payUrl;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) WebView *webView;
@property (nonatomic, copy) NSString *showTitle;
/** 是否要返回上一级   */
@property (nonatomic, assign) BOOL isBackLevel;

@end
/*
 5. 点击支付按钮拉起支付面板后，左侧列表菜单需要默认选中在第一个上
 6. 支付宝支付完成后，仍然保留在支付宝界面，手动返回DEMO后，停留在”等待付款中“界面，付款成功需要自动关闭这个界面
 7. 微信支付完成后，跳到了safari中弹出“等待付款中“界面
 
 */
/***用户参数**/
static NSString * userNames;
//static NSString * userToken;
static void(^_successBlock)(NSString *,NSString *);
static void(^_failedBlock)(NSString *, NSString *, NSString *);
static UserPayGoldViewController * s_instance_dj_manager = nil ;

@implementation UserPayGoldViewController

+ (UserPayGoldViewController *)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (s_instance_dj_manager == nil) {
            s_instance_dj_manager = [[UserPayGoldViewController alloc] init];
        }
    });
    return (UserPayGoldViewController *)s_instance_dj_manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewClose) name:@"MaiYouAlipayReturnFinish" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCurrentPage) name:@"PayRefreshCurrentPage" object:nil];
    
    self.isFirst = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self JoiningTogether];
    
    WEAKSELF
    [self.navBar setOnClickLeftButton:^{
        if (weakSelf.isBackLevel)
        {
            if (weakSelf.webView.canGoBack)
                [weakSelf.webView goBack];
        }
        else
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    //通顶显示
    if (self.isFullScreen)
    {
        self.navBar.backgroundColor = UIColor.clearColor;
        self.navBar.titleLable.textColor = ColorWhite;
        [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back-1")];
        self.navBar.lineView.hidden = YES;
    }
}

- (void)refreshCurrentPage
{
    [self.webView reload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isRecharge)
    {
        //记录充值的事件
        [MyAOPManager relateStatistic:@"PlatformCoinViewAppear" Info:@{}];
    }
    else if (self.isMember)
    {
        //记录会员充值的事件
        [MyAOPManager relateStatistic:@"MemberCenterViewAppear" Info:@{}];
    }
    else if (self.isMonthCard)
    {
        //记录月卡充值的事件
        [MyAOPManager relateStatistic:@"BrowseMonthlyCardPage" Info:@{}];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.isNewWelfare)
    {
        //为了刷新首页的新人福利状态
        AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appd getTopButtonCount];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.webView canGoBack])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.webView goBack];
        });
        return NO;
    }
    return YES;
}

#pragma mark 获取当前所需的字段
- (void)JoiningTogether
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    NSMutableDictionary * dict  = [NSMutableDictionary dictionary];
    [dict  setObject:userName?:@"0" forKey:@"username"];
    [dict  setObject:token?:@"0" forKey:@"token"];
    [dict  setObject:[DeviceInfo shareInstance].appVersion forKey:@"sdkversion"];

    if (self.trade_id && !self.isRecharge)
    {
        [dict setObject:self.trade_id forKey:@"id"];
    }
    NSString * url = [self makeSignUrl:dict];
    [self loadPayWebView:url];
}

#pragma mark 拼接url
- (NSString *)makeSignUrl:(NSMutableDictionary *)dict
{
    NSArray *allKeyArray = [dict allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //通过排列的key值获取value
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        [valueArray addObject:valueString];
        NSLog(@"valueString:{%@ %@}",valueString,sortsing);
    }
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0 ; i < afterSortKeyArray.count; i++) {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",afterSortKeyArray[i],valueArray[i]];
        [signArray addObject:keyValue];
    }
    //signString用于签名的原始参数集合
    NSString * signString = @"";
    for (NSString * string in signArray)
    {
        signString = [signString stringByAppendingString:[NSString stringWithFormat:@"&%@",string]];
    }
//    NSString * tokenString = [NSString stringWithFormat:@"&%@",signArray[0]];
//    NSString * nameString = [NSString stringWithFormat:@"%@",signArray[1]];
//    NSString *signString = [nameString stringByAppendingString:tokenString];
    NSString *url = [NSString stringWithFormat:@"%@", signString];
    if (self.loadUrl)
    {
        url = self.loadUrl;
    }
    else if (self.isRecharge)
    {
        self.navBar.title = @"充值平台币";
        url = [NSString stringWithFormat:@"%@home/recharge?%@&sdkversion=%@", UserPay, url,[DeviceInfo shareInstance].appVersion];
    }
    else if (self.isMember)
    {
//        url = [NSString stringWithFormat:@"%@home/vip?%@&version=2.5", UserPay, url];
        url = [NSString stringWithFormat:@"%@home/vip/index/version/2101?%@%@", UserPay, url, @"&mc=2103"];
    }
    else if (self.isRecycle)
    {
        url = [NSString stringWithFormat:@"%@%@", self.redeemUrl, url];
    }
    else if (self.isMonthCard)
    {
//        url = [NSString stringWithFormat:@"%@home/monthCard/index_v2101?%@%@", UserPay, url, self.isHome ? @"&auto=1" : @""];
        url = [NSString stringWithFormat:@"%@home/monthCard/index_v2103?%@%@", UserPay, url, self.isHome ? @"&auto=1" : @""];
    }
    else if (self.isWelfare)
    {
        url = [NSString stringWithFormat:@"%@home/novicefuli/index?%@", UserPay, url];
    }
    else if (self.isNewWelfare)
    {
        NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
        url = [NSString stringWithFormat:@"%@?%@", dic[@"novice_fuli_v2101_url"], url];
    }
    else if (self.reg_gt_30day_url)
    {
        NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
        url = [NSString stringWithFormat:@"%@?%@", dic[@"reg_gt_30day_url"], url];
    }
    else
    {
        if (self.trade_id)
        {
            url = [NSString stringWithFormat:@"%@home/trade?%@", UserPay, url];
        }
    }
    return url;
}
#pragma mark 进入支付列表页面
-(void) loadPayWebView:(NSString *)urlString
{
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    CGFloat webview_top = self.isFullScreen ? 0 : kStatusBarAndNavigationBarHeight;
    WebView *webViews = [[WebView alloc] initWithFrame:CGRectMake(0, webview_top, kScreenW, kScreenH - webview_top - kTabbarSafeBottomMargin)];
    webViews.scrollView.bounces = NO;
    webViews.backgroundColor = [UIColor whiteColor];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    webViews.scrollView.delegate = self;
    [self.view insertSubview:webViews belowSubview:self.navBar];
    self.webView = webViews;
    if (@available(iOS 11.0, *))
    {
        webViews.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    request = [YYToolModel requestHeaderAddParas:request];
    webViews.urlString = request.URL.absoluteString;
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)showAlert:(NSString *)message
{
    [TuuHUD showmessage:message];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString* url = navigationAction.request.URL.absoluteString;
//    if ([reqUrl hasPrefix:@"weixin://"]) {
//        NSLog(@"reqUrl=%@",reqUrl);
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:reqUrl]]) {
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:reqUrl]];
//        }else{
//            [MBProgressHUD showToast:@"该设备暂未安装微信"];
//        }
//    }
    if ([url containsString:@"home/vip/summary"] || [url containsString:@"home/month_card/records"])
    {
        self.isBackLevel = YES;
        self.navBar.backgroundColor = MAIN_COLOR;
        self.navBar.titleLable.textColor = ColorWhite;
    }
    else if(self.reg_gt_30day_url){
        self.navBar.backgroundColor = MAIN_COLOR;
        self.navBar.titleLable.textColor = ColorWhite;
        [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back-1")];
    }
    else
    {
        self.isBackLevel = NO;
        self.navBar.backgroundColor = UIColor.clearColor;
        self.navBar.titleLable.textColor = ColorWhite;
    }
    decisionHandler(YES);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isFullScreen) return;
    
    if (scrollView.contentOffset.y > 0)
    {
        self.navBar.backgroundColor = [MAIN_COLOR colorWithAlphaComponent:scrollView.contentOffset.y / 44.f];
        if (self.isNewWelfare)
        {
            self.navBar.title = self.showTitle;
        }
    }
    else
    {
        self.navBar.backgroundColor = UIColor.clearColor;
        if (self.isNewWelfare)
        {
            self.navBar.title = @"";
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual: @"title"])
    {
        self.showTitle = self.webView.title;
        MYLog(@"========%@", self.webView.title);
    }
}

- (void)viewClose
{
    [self.webView stopLoading];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeFromSuperview];
    self.webView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
//    NSLog(@"dealloc s");
//    self.webView = nil;
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"closev"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
