//
//  LoadGameViewController.m
//  Game789
//
//  Created by Maiyou on 2018/8/4.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "LoadGameViewController.h"
#import "CloudGameSuspensionView.h"
#import "WMDragView.h"
#import "WebView.h"

@interface LoadGameViewController ()<UIAlertViewDelegate, CloudGameSuspensionViewDelegate>
//需要充值的人名币
@property (strong, nonatomic) NSString *payMoneyValue;

@property (strong, nonatomic) UIView *btnBackView;

@property (strong, nonatomic) NSArray *listArray;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableArray *values;

@property (nonatomic, copy) NSString *payUrl;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) WebView *webView;
@property (nonatomic, copy) NSString *requestStr;
@property (nonatomic, assign) BOOL isAgain;
@end
/*
 5. 点击支付按钮拉起支付面板后，左侧列表菜单需要默认选中在第一个上
 6. 支付宝支付完成后，仍然保留在支付宝界面，手动返回DEMO后，停留在”等待付款中“界面，付款成功需要自动关闭这个界面
 7. 微信支付完成后，跳到了safari中弹出“等待付款中“界面
 
 */
/***用户参数**/
static NSString * userNames;
//static NSString * userToken;
static NSString *requestStr;
static void(^_successBlock)(NSString *,NSString *);
static void(^_failedBlock)(NSString *, NSString *, NSString *);
static LoadGameViewController * s_instance_dj_manager = nil ;
//-(void)viewClose;
@implementation LoadGameViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

+ (LoadGameViewController *)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (s_instance_dj_manager == nil) {
            s_instance_dj_manager = [[LoadGameViewController alloc] init];
        }
    });
    return (LoadGameViewController *)s_instance_dj_manager;
}
#pragma mark 获取当前所需的字段
-(void)JoiningTogether{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
    NSMutableDictionary * dict  = [NSMutableDictionary dictionary];
    [dict  setObject:userName?:@"0" forKey:@"username"];
    [dict  setObject:token?:@"0" forKey:@"token"];
    [self loadPayWebView:self.load_url];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    UIActivityIndicatorView* aiv = (UIActivityIndicatorView*)[self.view viewWithTag:110];
    [aiv stopAnimating];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    self.webView = nil;
}

#pragma mark 进入支付列表页面
-(void) loadPayWebView:(NSString *)urlString
{
    urlString= [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WebView *webViews = [[WebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    webViews.scrollView.bounces = NO;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.view addSubview:webViews];
    self.webView = webViews;
    request = [YYToolModel requestHeaderAddParas:request];
    [self.webView loadRequest:request];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CloudGameSuspensionView * suspensionView = [[CloudGameSuspensionView alloc] initWithFrame:CGRectMake(kScreenW-100, kStatusBarAndNavigationBarHeight+44, 100, 36)];
        suspensionView.delegate = self;
        [self.webView addSubview:suspensionView];
    });
}

- (void)onExitAction
{
    [self jxt_showAlertWithTitle:@"温馨提示" message:@"是否退出当前游戏！" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.
        addActionCancelTitle(@"取消").
        addActionDefaultTitle(@"确定");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewClose) name:@"MaiYouAlipayReturnFinish" object:nil];
    self.isFirst = YES;
    self.hiddenNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.navBar aboveSubview:self.view];
    [self JoiningTogether];
    [MBProgressHUD showToast:@"请稍后..." toView:self.view];
    
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];  
}

- (void)viewClose
{
    NSLog(@"js 混合开发=====OC");
    NSLog(@"self.webview retaicout=%@",self.webView);
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self dismissViewControllerAnimated:YES completion:^{
    //            UIActivityIndicatorView* aiv = (UIActivityIndicatorView*)[self.view viewWithTag:110];
    //            [aiv stopAnimating];
    //            WMDragView *helper = nil;
    //            for (id view in [UIApplication sharedApplication].keyWindow.subviews)
    //            {
    //                if ([view isKindOfClass:[WMDragView class]]) {
    //                    WMDragView *helper=view;
    //                    helper.hidden=NO;
    //                    break;
    //                }
    //            }
    //            if (helper == nil) {
    //
    //            }
    //        }];
    //
    //    });
    NSLog(@"self.webview retaicout=%@",self.webView);
}

-(void)alertWX
{
    UIAlertController * alertWX = [UIAlertController alertControllerWithTitle:@"提示".localized message:@"点击确认前往AppStore下载微信".localized preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"前往".localized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E5%BE%AE%E4%BF%A1/id414478124?mt=8"];
        
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }];
    [alertWX addAction:defaultAction];
    [alertWX addAction:cancelAction];
    [self presentViewController:alertWX animated:YES completion:nil];
}

//获取当前时间戳
+(NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (void)dealloc {
    NSLog(@"dealloc s");
    self.webView = nil;
}

- (void)exitApp
{
    [self cancelLocalNotification];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginExitNotice object:nil];
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    
    [self removeFromParentViewController];
}
// 取消本地推送通知
- (void)cancelLocalNotification {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

@end
