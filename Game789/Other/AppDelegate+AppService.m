//
//  AppDelegate+AppService.m
//  Game789
//
//  Created by Maiyou on 2019/4/24.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import <UIKit/UIKit.h>
/**  jspatch  */
#import "MyJSPatchTool.h"
#import "SegmentTypeApi.h"
#import "MyGetVoucherStateApi.h"
#import "SwpNetworking.h"
#import "NetworkHelper.h"
#import "WebSocketManager.h"
#import "AVPlayerManager.h"

#import "UserPayGoldViewController.h"
#import "ProductDetailsViewController.h"
#import "MyRebateCenterController.h"
#import "TransactionViewController.h"
#import <UMLink/MobClickLink.h>
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import "WWKApi.h"
#import "WXApi.h"

@class GetActivityApi;

@implementation AppDelegate (AppService)

- (void)requestTrackingAuthorization
{
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            NSLog(@"app追踪权限：%lu",(unsigned long)status);
            switch (status) {
                case ATTrackingManagerAuthorizationStatusDenied:
                    MYLog(@"追踪权限用户拒绝");
                    break;
                case ATTrackingManagerAuthorizationStatusAuthorized:
                    MYLog(@"追踪权限用户允许");
                    [DeviceInfo shareInstance].deviceIdfa = [ASIdentifierManager.sharedManager advertisingIdentifier].UUIDString;
                    NSLog(@"deviceIdfa=%@",[DeviceInfo shareInstance].deviceIdfa);
                    break;
                case ATTrackingManagerAuthorizationStatusNotDetermined:
                    MYLog(@"追踪权限用户未做选择或未弹窗");
                    break;
                default:
                    break;
            }
        }];
    }
    else {
        [DeviceInfo shareInstance].deviceIdfa = [ASIdentifierManager.sharedManager advertisingIdentifier].UUIDString;
        NSLog(@"deviceIdfa=%@",[DeviceInfo shareInstance].deviceIdfa);
    }
}

#pragma mark - 初始化jspatch
- (void)initJspatch
{
//    if ([YYToolModel islogin])
//    {
        [[MyJSPatchTool shareJSPatch] getJspatchData];
//    }
}

- (void)initOcpcSdk
{
//    if (@available(iOS 14, *)) {
//        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//            NSString * ffudid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//            MYLog(@"===========idfa:%@", ffudid);
//            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//            NSString * baiduId  = infoDictionary[@"BaiduOcpcId"];
//            NSString * baidukey = infoDictionary[@"BaiduOcpcKey"];
//            [BaiduAction init:baiduId secretKey:baidukey];
//        }];
//    } else {
//        NSString * ffudid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//        MYLog(@"===========idfa:%@", ffudid);
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        NSString * baiduId  = infoDictionary[@"BaiduOcpcId"];
//        NSString * baidukey = infoDictionary[@"BaiduOcpcKey"];
//        [BaiduAction init:baiduId secretKey:baidukey];
//    }
}

- (void)configUM
{
    NSString * appKey = @"";
//    if ([DeviceInfo shareInstance].deviceUDID.length > 0)
//    {
//        if ([DeviceInfo shareInstance].channelTag.integerValue == 0)
//        {
//            appKey = @"5d3ac7de570df31370000aad";
//        }
//        else if ([DeviceInfo shareInstance].channelTag.integerValue == 1)
//        {
//            appKey = @"59e81144677baa73640008ea";
//        }
//        else if ([DeviceInfo shareInstance].channelTag.integerValue == 3)
//        {
//            appKey = @"5d3ac834570df3135b000982";
//        }
//    }
//    else
//    {
        appKey = [DeviceInfo shareInstance].umAppkey;
//    }
    //一键登录初始化
    [UMCommonLogManager setUpUMCommonLogManager];
    [MobClick setAutoPageEnabled:YES];
//    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:appKey channel:[DeviceInfo shareInstance].umchannel];
}

#pragma mark - 初始化第三方分享
- (void)setShareAppKey
{
    [[UMSocialManager defaultManager] openLog:YES];
    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"https://app.milu.com/"};
    //9917wan
    if ([DeviceInfo shareInstance].channelTag.integerValue == 3)
    {
        if ([DeviceInfo shareInstance].isGameVip) {//至尊版
            /* 设置微信的appKey和appSecret */
            [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession | UMSocialPlatformType_WechatTimeLine appKey:@"wxb939825b696f1f76" appSecret:@"1276dfe6e04a61f7ed8caff482516929" redirectURL:@"https://app.milu.com/"];

            /* 设置分享到QQ互联的appID */
            [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ | UMSocialPlatformType_Qzone appKey:@"1109698030" appSecret:@"wj3eA7SKj7BK7Efw" redirectURL:@"https://app.milu.com/"];
        }
        else//普通版
        {
            /* 设置微信的appKey和appSecret */
            [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession | UMSocialPlatformType_WechatTimeLine appKey:@"wxec5723daf005496c" appSecret:@"5a0eb75d379470c982bae2ebdb8ac03f" redirectURL:@"https://app.milu.com/"];

            /* 设置分享到QQ互联的appID */
            [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ | UMSocialPlatformType_Qzone appKey:@"1107881937" appSecret:@"aoLEl9i1kOnmLS4H" redirectURL:@"https://app.milu.com/"];
        }
     }
    else if ([DeviceInfo shareInstance].channelTag.integerValue == 2)//嘿咕游戏
    {
        /* 设置微信的appKey和appSecret */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession | UMSocialPlatformType_WechatTimeLine appKey:@"wx35d2f0b9d930e0b8" appSecret:@"28b4022cd519cd47895fc09fc6970bd0" redirectURL:@"https://app.milu.com/"];

        /* 设置分享到QQ互联的appID */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ | UMSocialPlatformType_Qzone appKey:@"102010714" appSecret:@"kQt9C1d1CBwTmqgI" redirectURL:@"https://app.milu.com/"];
    }
     else
     {//咪噜游戏
         if ([DeviceInfo shareInstance].isGameVip)
         {//至尊版
             /* 设置微信的appKey和appSecret */
             [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession | UMSocialPlatformType_WechatTimeLine appKey:@"wxc8c0a5daeb0e1f32" appSecret:@"0d418c1a1f4e783aed191098e883f311" redirectURL:@"https://app.milu.com/"];

             /* 设置分享到QQ互联的appID */
             [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ | UMSocialPlatformType_Qzone appKey:@"1109653204" appSecret:@"zJAJsC4n3wQL2wTD" redirectURL:@"https://app.milu.com/"];
             
             [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString * _Nonnull log) {
                 NSLog(@"WeChatSDK: %@", log);
             }];
//             [WWKApi registerAppID:@"wxc8c0a5daeb0e1f32" schema:@"miluVip"];
//             [WWKApi registerApp:@"wxc8c0a5daeb0e1f32" corpId:@"wwecef3a9edd6e2a8f" agentId:@"wxc8c0a5daeb0e1f32"];
             [WXApi registerApp:@"wxc8c0a5daeb0e1f32" universalLink:@"https://app.milu.com/"];
         }
         else//普通版
         {
             /* 设置微信的appKey和appSecret */
//             [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxbbc482d3fdefe21d" appSecret:@"bf41a7cc432bebbb0774acfd39a4fd38" redirectURL:nil];

            if ([DeviceInfo shareInstance].isTFSigin)//tf签专用
            {
                 [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxbe4eee1f352aefab" appSecret:@"772276661635baca22612aa8b6242090" redirectURL:nil];

                /* 设置分享到QQ互联的appID */
                [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ | UMSocialPlatformType_Qzone appKey:@"1106657456" appSecret:@"KEYKbO2qzp2Kv2mzhxu" redirectURL:@"https://app.milu.com/"];
            }
            else
            {
                [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx7f003fb242814197" appSecret:@"65c55bf25f279966b23c611bb308308c" redirectURL:nil];

               /* 设置分享到QQ互联的appID */
               [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ | UMSocialPlatformType_Qzone appKey:@"1106485944" appSecret:@"18CGsuaytNOAE2Hq" redirectURL:@"https://app.milu.com/"];
            }
         }
     }
}

#pragma mark - 初始化键盘
- (void)initKeyBoardManager
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = NO; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:15]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 8.0f; // 输入框距离键盘的距离
}

//下载管理
- (void)setUpDownload:(UIApplication *)application
{
    //注册通知
//    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    path = [path stringByAppendingPathComponent:@"download"];
    YCDConfig *config = [YCDConfig new];
    config.saveRootPath = path;
    config.uid = @"100006";
    config.maxTaskCount = 3;
    config.taskCachekMode = YCDownloadTaskCacheModeKeep;
    config.launchAutoResumeDownload = true;
    [YCDownloadManager mgrWithConfig:config];
    [YCDownloadManager allowsCellularAccess:YES];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskFinishedNoti:) name:kDownloadTaskFinishedNoti object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadAllTaskFinished) name:kDownloadTaskAllFinishedNoti object:nil];
}

#pragma mark notificaton

- (void)downloadAllTaskFinished{
    [self localPushWithTitle:@"YCDownloadSession" detail:@"所有的下载任务已完成！"];
}

- (void)downloadTaskFinishedNoti:(NSNotification *)noti{
    YCDownloadItem *item = noti.object;
    if (item) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:item.extraData options:0 error:nil];
        NSString *detail = [NSString stringWithFormat:@"%@，已经下载完成！", dict[@"game_name"]];
        [self localPushWithTitle:@"YCDownloadSession" detail:detail];
    }
}

#pragma mark local push
- (void)localPushWithTitle:(NSString *)title detail:(NSString *)body  {
    
    if (title.length == 0) return;
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:3.0];
    localNote.alertBody = body;
    localNote.alertAction = @"滑动来解锁";
    localNote.hasAction = NO;
    localNote.soundName = UILocalNotificationDefaultSoundName;
    localNote.userInfo = @{@"type" : @"down", @"sound" : @""};
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

- (void)networkState
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [DeviceInfo shareInstance].networkState = status;
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    
    // 3.开始监控
    [manager startMonitoring];
}

- (void)getActivityInfo
{
    GetActivityApi * api = [[GetActivityApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [DeviceInfo shareInstance].activityDic = request.data;
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)SDKToAppOpenUrl:(NSURL *)url
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
//        MYLog(@"%@，%@，%@", url.absoluteString, url.scheme, url.host);
        NSString * actionType = @"HomePage";
        if ([url.host containsString:@"udid="])
        {
            NSString * udid = [url.host stringByReplacingOccurrencesOfString:@"udid=" withString:@""];
            [YYToolModel saveUserdefultValue:udid forKey:@"MiluDeviceUdid"];
            if ([DeviceInfo shareInstance].getUDIDSuccessBlock) {
                [DeviceInfo shareInstance].getUDIDSuccessBlock(udid);
            }
//            MYLog(@"获取udid == %@", udid);
        }
        else if ([url.host containsString:@"gameId"])
        {//游戏详情
            NSRange range = [url.host rangeOfString:@"-"];
            NSString * gameid = [url.host substringFromIndex:range.location + 1];
            GameDetailInfoController *vc = [[GameDetailInfoController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.maiyou_gameid = gameid;
            [nav pushViewController:vc animated:YES];
        }
        else if ([url.host containsString:@"tradeId"])
        {//交易详情
            if ([url.host containsString:@"-"])
            {
                actionType = @"TradingDetailPage";
                NSRange range = [url.host rangeOfString:@"-"];
                NSString * tradeId = [url.host substringFromIndex:range.location + 1];
                ProductDetailsViewController *vc = [[ProductDetailsViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.trade_id = tradeId;
                [nav pushViewController:vc animated:YES];
            }
            else
            {
                actionType = @"TradingCenterPage";
//                    TransactionViewController * transaction = [TransactionViewController new];
//                    transaction.hidesBottomBarWhenPushed = YES;
//                    [nav pushViewController:transaction animated:YES];
                [self switchTabbarIndex:3];
            }
        }
        else if ([YYToolModel isAlreadyLogin])
        {
            if ([[url host] isEqualToString:@"memberRecharge"])
            {//会员充值
                actionType = @"MemberCenterPage";
                [self pushToRecharge:2];
            }
            else if ([[url host] isEqualToString:@"doTask"])
            {//任务页面
                actionType = @"TaskCenterPage";
                [self switchTabbarIndex:2];
            }
            else if ([[url host] isEqualToString:@"submitRebate"])
            {//提交返利
                actionType = @"SubmitRebatesPage";
                MyRebateCenterController *rebate = [[MyRebateCenterController alloc]init];
                rebate.hidesBottomBarWhenPushed = YES;
                [nav pushViewController:rebate animated:YES];
            }
            else if ([[url host] isEqualToString:@"onlineRecharge"])
            {//在线充值
                actionType = @"PlatformCoinPage";
                [self pushToRecharge:1];
            }
            else if ([[url host] isEqualToString:@"monthCard"])
            {//月卡充值
                actionType = @"MonthlyCardPage";
                [self pushToRecharge:3];
            }
            else if ([[url host] containsString:@"url="])
            {//加载活动地址
                NSArray * array = [url.absoluteString componentsSeparatedByString:@"url="];
                [self pushToActivityPage:array[1]];
            }
            else if ([url.host containsString:@"quickLogin"])
            {//SDK快速登录
                if ([url.host containsString:@"-"])
                {
                    [self openToSDk:url];
                }
            }
        }
        else
        {//没有登录
            if ([url.host containsString:@"quickLogin"])
            {//SDK快速登录
                if ([url.host containsString:@"-"])
                {
                    LoginViewController *VC = [[LoginViewController alloc] init];
                    VC.hidesBottomBarWhenPushed = YES;
                    VC.quickLoginBlock = ^{
                        [self openToSDk:url];
                    };
                    [nav pushViewController:VC animated:YES];
                }
            }
        }
        //统计从SDK的跳转
        [MyAOPManager relateStatistic:@"FromSdkToMiluApp" Info:@{@"LandingPage":actionType}];
    });
}

- (void)openToSDk:(NSURL *)url
{
    NSArray * array = [url.absoluteString componentsSeparatedByString:@"-"];
    
    NSString * urlSchemes = [NSString stringWithFormat:@"MYAliPayScheme%@", array[1]];
    NSString * token = [YYToolModel getUserdefultforKey:TOKEN];
    NSString * userid = [YYToolModel getUserdefultforKey:USERID];
    NSString * username = [YYToolModel getUserdefultforKey:@"user_name"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://quickLogin/%@/%@/%@", urlSchemes, token, userid, username]]];
}

//跳转到指定活动页面
- (void)pushToActivityPage:(NSString *)str
{
    UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
    NSString * url = [NSString stringWithFormat:@"%@%@username=%@&token=%@", str, [str containsString:@"?"] ? @"&" : @"?", [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
    //web详情
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.hidesBottomBarWhenPushed = YES;
    webVC.urlString = url;
    [nav pushViewController:webVC animated:YES];
}

//跳转到任务页面
- (void)pushToTask
{
    UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
    MyTaskViewController *coinsVC = [[MyTaskViewController alloc]init];
    coinsVC.hidesBottomBarWhenPushed = YES;
    coinsVC.isPush = YES;
    [nav pushViewController:coinsVC animated:YES];
}

//切换tabbar
- (void)switchTabbarIndex:(NSInteger)index
{
    UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
    [nav.tabBarController setSelectedIndex:index];
}

//跳转到充值页面
// 1 充值 2 会员 3 月卡
- (void)pushToRecharge:(NSInteger)type
{
    [self switchTabbarIndex:4];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD showToast:@"请核对游戏和盒子登录账号是否一致，避免充错账号！"];
    });
    
    UINavigationController *nav = [YYToolModel getCurrentVC].navigationController;
    if (type == 1)
    {
        UserPayGoldViewController * pay = [UserPayGoldViewController new];
        pay.isRecharge = YES;
        pay.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:pay animated:YES];
    }
    else
    {
        SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
        payVC.selectedIndex = type == 2 ? 1 : 0;
        payVC.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:payVC animated:YES];
    }
}

- (void)initGameVideo
{
    [NetworkHelper startListening];
//    [[WebSocketManager shareManager] connect];
//    [AVPlayerManager setAudioMode];
    
//    [self requestPermission];
}

- (void)requestPermission {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        //process photo library request status.
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    CGPoint touchLocation = [[[event allTouches] anyObject] locationInView:self.window];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if (CGRectContainsPoint(statusBarFrame, touchLocation)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusBarTouchBeginNotification" object:nil];
    }
}

- (void)uploadActivationData
{
    [SwpNetworking swpPOST:@"getAnnounceMents" parameters:@{@"idfa":[DeviceInfo shareInstance].ffOpenUDID, @"os":@"3", @"agent":[DeviceInfo shareInstance].channel} swpNetworkingSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull resultObject) {
        MYLog(@"%@", resultObject);
    } swpNetworkingError:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
        
    } ShowHud:NO];
}

@end
