//
//  WebView.m
//  Game789
//
//  Created by maiyou on 2021/7/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WebView.h"
#import "PayPlug.h"
#import "AuthAlertView.h"
#import "AdultAlertView.h"

@interface WebView ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate,AuthAlertViewDelegate>

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation WebView

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.x, ScreenWidth, 1)];
        _progressView.progressTintColor = self.progressColor ? self.progressColor : MAIN_COLOR;
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 0.5f);
        _progressView.transform = transform;
    }
    return _progressView;
}

- (void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
    NSString *encodedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
    [request setValue:[DeviceInfo shareInstance].deviceType forHTTPHeaderField:@"device-type"];
    [request setValue:[DeviceInfo shareInstance].channel forHTTPHeaderField:@"channel"];
    [request setValue:[ShareVale sharedInstance].sdkVersion forHTTPHeaderField:@"sdk-version"];
    [self loadRequest:request];
}

- (void)setHtmlString:(NSString *)htmlString{
    _htmlString = htmlString;
    [self loadHTMLString:self.htmlString baseURL:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    
        self = [[WebView alloc] initWithFrame:frame configuration:config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(nonnull WKWebViewConfiguration *)configuration
{
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        
        [configuration.userContentController addScriptMessageHandler:self name:@"skipAPPView"];
        [configuration.userContentController addScriptMessageHandler:self name:@"maiyouPay"];
        [configuration.userContentController addScriptMessageHandler:self name:@"alipayapp"];
        [configuration.userContentController addScriptMessageHandler:self name:@"closev"];
        [configuration.userContentController addScriptMessageHandler:self name:@"share"];
        [configuration.userContentController addScriptMessageHandler:self name:@"logout"];
        [configuration.userContentController addScriptMessageHandler:self name:@"exitApp"];
        [configuration.userContentController addScriptMessageHandler:self name:@"openwebview"];
        [configuration.userContentController addScriptMessageHandler:self name:@"popRealNameAuth"];
        
        [self addSubview:self.progressView];
        self.navigationDelegate = self;
        self.UIDelegate = self;
        self.allowsBackForwardNavigationGestures = YES;
        self.scrollView.bounces = false;
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior= UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)onAuthSuccess{
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"message.body===%@===%@",message.body, message.name);
    if ([message.name isEqualToString:@"popRealNameAuth"]) {
        NSDictionary * dict = message.body;
        int type = [dict[@"type"] intValue];
        if (type == 1){
            [AuthAlertView showAuthAlertViewWithDelegate:self];
            return;
        }else if(type == 2){
            [AdultAlertView showAdultAlertView];
            return;
        }
    }
    if ([message.name isEqualToString:@"maiyouPay"]) {
        NSDictionary * item = message.body;
        NSString * payType = item[@"payType"];
        NSString * data = item[@"data"];
        if ([payType isEqualToString:@"alipayapp"]) {
            if (self.weachatBlock){
                self.weachatBlock();
            };
            PayPlug *pay =  [PayPlug sharedInstance];
            [pay h5ToNativePay:data];
        }
    }
    if ([message.name isEqualToString:@"skipAPPView"]) {
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            NSDictionary * item = message.body;
            if ([item objectForKey:@"name"] && [item objectForKey:@"value"]) {
                NSString * name = [item objectForKey:@"name"];
                NSString * value = [item objectForKey:@"value"];
                [[YYToolModel shareInstance] showUIFortype:name Parmas:value];
            }else if([item objectForKey:@"name"]){
                NSString * name = [item objectForKey:@"name"];
                [[YYToolModel shareInstance] showUIFortype:name Parmas:@""];
            }
        }
    }
    if ([message.name isEqualToString:@"closev"]) {
        [self closeView];
    }
    if ([message.name isEqualToString:@"share"]) {
        [self showShareView:message.body[@"value"]];
    }
    if ([message.name isEqualToString:@"logout"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginExitNotice object:nil];
        [[YYToolModel getCurrentVC].navigationController pushViewController:[LoginViewController new] animated:YES];
        
        [[YYToolModel getCurrentVC] removeFromParentViewController];
    }
    if ([message.name isEqualToString:@"openwebview"]) {
        NSDictionary * item = message.body;
        if ([item objectForKey:@"openwebview"]) {
            NSString * url = item[@"value"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
        }
    }
}

- (void)closeView
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[YYToolModel getCurrentVC].navigationController popViewControllerAnimated:YES];
//    });

//    [self stopLoading];
//    [self removeFromSuperview];
}

/** 分享 */
- (void)showShareView:(NSString *)string
{
    string = [self URLDecodedString:string];
    NSString * content = @"";
    NSString * title = @"";
    NSString * url = @"";
    NSString * imageUrl = @"";
    
    NSArray * array = [string componentsSeparatedByString:@"&"];
    for (NSString * shareStr in array)
    {
        NSString * string1 = @"";
        if ([shareStr containsString:@"="])
        {
            NSRange range = [shareStr rangeOfString:@"="];
            string1 = [shareStr substringFromIndex:range.location + 1];
        }
        if ([shareStr containsString:@"title"])
        {
            title = string1;
        }
        else if ([shareStr containsString:@"content"])
        {
            content = string1;
        }
        else if ([shareStr containsString:@"url"])
        {
            url = string1;
        }
        else if ([shareStr containsString:@"icon"])
        {
            imageUrl = string1;
        }
    }
    
    NSDictionary * dic = @{@"title":title,
                           @"img":imageUrl,
                           @"desc":content,
                           @"url":url};
    [self shareBtnClick:dic];
    
//    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//    [shareParams SSDKSetupShareParamsByText:content
//                                     images:[NSURL URLWithString:imageUrl]
//                                        url:[NSURL URLWithString:url]
//                                      title:title
//                                       type:SSDKContentTypeWebPage];
//    //2、分享（可以弹出我们的分享菜单和编辑界面）
//    [ShareSDK showShareActionSheet:nil customItems:@[@(SSDKPlatformSubTypeWechatSession), @(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)] shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)  {
//
//           switch (state) {
//               case SSDKResponseStateSuccess:
//               {
//                   [MBProgressHUD showToast:@"分享成功" toView:self.view];
//                   break;
//               }
//               case SSDKResponseStateFail:
//               {
//                   [MBProgressHUD showToast:@"分享失败" toView:self.view];
//                   break;
//               }
//               default:
//                   break;
//           }
//       }];
}

/**  解码  */
-(NSString*)URLDecodedString:(NSString*)str
{
    NSString *encodedString = str;
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
    
}

- (void)shareBtnClick:(NSDictionary *)params
{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
         [self shareWebPageToPlatformType:platformType Params:params];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType Params:(NSDictionary *)params
{
    NSString * title = [params[@"title"] URLDecodedString];
    NSString * img = [params[@"img"] URLDecodedString];
    NSString * description = [params[@"desc"] URLDecodedString];
    NSString * url = [params[@"url"] URLDecodedString];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:description thumImage:[NSData dataWithContentsOfURL:[NSURL URLWithString:img]]];
    //设置网页地址
    shareObject.webpageUrl = url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********", error);
            [MBProgressHUD showToast:@"分享失败" toView:self];
        }
        else
        {
            [YJProgressHUD showSuccess:@"分享成功" inview:self];
            
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }
            else
            {
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString* reqUrl = navigationAction.request.URL.absoluteString;
    NSLog(@"reqUrl=%@", reqUrl);
    WEAKSELF;
    if ([reqUrl hasPrefix:@"weixin://"] || [reqUrl hasPrefix:@"alipays://"] || [reqUrl hasPrefix:@"alipay://"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:reqUrl]]) {
            if(weakSelf.weachatBlock){
                weakSelf.weachatBlock();
            };
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:reqUrl] options:@{} completionHandler:^(BOOL success) {
                [weakSelf closeView];
            }];
        }else{
            [MBProgressHUD showToast:@"该设备暂未安装该支付App"];
        }
    }
    else if ([reqUrl containsString:@"wxaurl.cn"] || [reqUrl containsString:@"qr.alipay.com"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(weakSelf.weachatBlock){
                weakSelf.weachatBlock();
            };
            [weakSelf closeView];
        });
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual: @"estimatedProgress"]) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.estimatedProgress animated:YES];
        if(self.estimatedProgress >= 1.0f){
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    completionHandler();
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
