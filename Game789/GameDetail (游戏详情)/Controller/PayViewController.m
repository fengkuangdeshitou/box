//
//  PayViewController.m
//  TuuDemo
//
//  Created by 张鸿 on 16/3/7.
//  Copyright © 2016年 张鸿. All rights reserved.
//
#define duTime 0.3


#import "PayViewController.h"
#import "UIView+Extension.h"
#import "NSObject+TUPayAPI.h"
#import "NSString+URLEncode.h"
#import "PayPlug.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+SPUtilsExtras.h"
#import "WXUtil.h"
#import "WMDragView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "WebView.h"


//首先创建一个实现了JSExport协议的协议
@protocol JSObjectProtocol <JSExport>

//此处我们测试几种参数的情况
- (void)viewClose;

- (void)reLoadLogin;
- (void)showAlert:(NSString *)message;

@end


@interface PayViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,JSObjectProtocol>

@property (weak, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSString *UUPayMoney;

@property (strong, nonatomic) NSArray *listArray;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableArray *values;


@property (nonatomic, copy) NSString *payUrl;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, assign) BOOL isFirst;

@property (nonatomic, strong) WebView *webView;


@end

static void(^_successBlock)(NSString *,NSString *);
static void(^_failedBlock)(NSString *, NSString *, NSString *);
static PayViewController * s_instance_dj_manager = nil ;

@implementation PayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"GM权限助手";
    //当前在支付宝状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewClose) name:@"MaiYouAlipayReturnFinish" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadPayWebView:self.requestStr];
    
    self.isFirst = YES;
}

- (void) loadPayWebView:(NSString *)urlString
{
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    WebView *webViews = [[WebView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight)];
    webViews.scrollView.bounces = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    webViews.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webViews];
    self.webView = webViews;
    
    request = [self loadHeaderRequest:request];
    self.webView.urlString = request.URL.absoluteString;
    
    WEAKSELF
    [self.navBar setOnClickLeftButton:^{
        if (weakSelf.webView.canGoBack)
        {
            [weakSelf.webView goBack];
        }
        else
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (NSURLRequest *)loadHeaderRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *agent = [DeviceInfo shareInstance].channel;
    NSString *deviceType = [ShareVale sharedInstance].phoneType;
    NSString *version = [ShareVale sharedInstance].version;
    if (!agent ||agent.length == 0) {
        agent = @"";
    }
    NSLog(@"manager post开始 agent= %@",NSStringFromClass([agent class]));
    if (!self.gameid ||self.gameid.length == 0) {
        self.gameid = @"";
    }
    NSLog(@"manager post开始 gameid= %@",NSStringFromClass([self.gameid class]));
    [mutableRequest setValue:agent forHTTPHeaderField:@"agent"];
    [mutableRequest setValue:self.gameid forHTTPHeaderField:@"gameid"];
    [mutableRequest setValue:self.xh_username forHTTPHeaderField:@"xh-username"];
    [mutableRequest setValue:[ShareVale sharedInstance].token forHTTPHeaderField:@"token"];
    [mutableRequest setValue:@"ios" forHTTPHeaderField:@"clienttype"];
    [mutableRequest setValue:@"" forHTTPHeaderField:@"appid"];
    [mutableRequest setValue:deviceType forHTTPHeaderField:@"device-type"];
    [mutableRequest setValue:[ShareVale sharedInstance].sdkVersion forHTTPHeaderField:@"sdk-version"];
    [mutableRequest setValue:@"http://www.wakaifu.com" forHTTPHeaderField:@"Referer"];
    [mutableRequest setValue:@"box" forHTTPHeaderField:@"origin"];
    [mutableRequest setValue:[DeviceInfo shareInstance].appVersion forHTTPHeaderField:@"sdkversion"];
    request = [mutableRequest copy];
    return request;
}

- (void)dealloc {
    NSLog(@"dealloc s");
    self.webView = nil;
}

-(void)viewClose
{
    [self.webView stopLoading];
    self.webView = nil;
    [self.webView removeFromSuperview];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - md5 16位加密 （大写）
-(NSString *)md5:(NSString *)str {

    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);

    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}





@end
