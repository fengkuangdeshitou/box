
//
//  AppDelegate.m
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "AppDelegate+AppService.h"
#import "UIApplication+Visible.h"
#import "GameDownLoadApi.h"
#import "HomeTypeApi.h"
#import "SegmentTypeApi.h"
#import "GetUnreadMgsApi.h"
#import "MyGetHomePageMaterialApi.h"

#import "getLanchImageApi.h"
#import "GetVersionApi.h"
#import "MySelectGameTypeController.h"

#import "PayPlug.h"
#import "TUAlerterView.h"
#import "MyAppUpdateView.h"
#import "MyUserAgreementView.h"

//搭建本地服务器
#import "BGLocationConfig.h"
#import "BackgroundTask.h"
#import <UMLink/MobClickLink.h>
#import "WebView.h"

@interface AppDelegate ()<MobClickLinkDelegate>
{
    NSTimer * _timer;
    BackgroundTask * bgTask;
}
@property (strong, nonatomic) MyAppUpdateView *updateView;
@property (strong, nonatomic) NSDictionary *versionDic;
@property (strong, nonatomic) NSDictionary *lanchDic;
@property (copy, nonatomic) NSString *localNotId;

@property (nonatomic, strong) NSTimer * serverTimer;
/** 计算后台运行的时间 */
@property (nonatomic, assign) NSInteger bgTime;
/** 后台运行时是否刷新首页 */
@property (nonatomic, assign) BOOL isFreshMain;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if (![YYToolModel getUserdefultforKey:@"HomeGuidePageView"]) {
        UIViewController * vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = UIColor.whiteColor;
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
        [self delayLoadImageWithApplication:application options:launchOptions];
    }else{
        [self initRootViewControllerWithApplication:application options:launchOptions];
    }
    return YES;
}

- (void)initRootViewControllerWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions{
    
    [self requestTrackingAuthorization];
    
    [self networkState];
    
    [self getTopButtonCount];
    
    [self getActivityInfo];
    
    [self configUM];
    
    [self setShareAppKey];
        
    //诸葛io
//    [self zhugeTrack:launchOptions];
    
    [self initKeyBoardManager];
    
    [self getUnreadMgsCount];
    
    [self getMemberInfo];
    //下载管理
    [self setUpDownload:application];
    
    [self initJspatch];
    
    [self setHttpServer];
     
    [self initGameVideo];
    
//    [self initOcpcSdk];
    
//    [self uploadActivationData];
    
    bgTask = [[BackgroundTask alloc] init];
    
    [self selectLikeGameTypeWithApplication:application options:launchOptions];
}

- (void)selectLikeGameTypeWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions
{
//    NSString * str = [YYToolModel getUserdefultforKey:@"MyLikeGameType"];
//    if (str == NULL)
//    {
//        self.window.rootViewController = [MySelectGameTypeController new];
//        [self.window makeKeyAndVisible];
//
//        [self delayLoadImage];
//    }
//    else
//    {
        [YYToolModel initTabbarRootVC];
    
    [self delayLoadImageWithApplication:application options:launchOptions];
//    }
}

#pragma mark ——— 加载图片延时两秒
- (void)delayLoadImageWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.tag = 8888;
    imageView.image = [self getLaunchImage];
    [self.window addSubview:imageView];
    
    NSString * userCenter = [YYToolModel getUserdefultforKey:@"HomeGuidePageView"];
    if (userCenter == NULL)
    {
        MyUserAgreementView * userView = [[MyUserAgreementView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        userView.tag = 9999;
        userView.agreeBtnClickBlock = ^{
            [YYToolModel saveUserdefultValue:@"1" forKey:@"HomeGuidePageView"];
            [self initRootViewControllerWithApplication:application options:launchOptions];
            [UIView transitionWithView:_window duration:0.8 options:UIViewAnimationOptionTransitionNone animations:^{
                imageView.alpha = 0;
            } completion:^(BOOL finished) {
                [imageView removeFromSuperview];
                if (finished) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"firstInstallPushNotification" object:nil];
                    });
                }
            }];
        };
        [self.window addSubview:userView];
    }
    else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView transitionWithView:_window duration:0.8 options:UIViewAnimationOptionTransitionNone animations:^{
                imageView.alpha = 0;
            } completion:^(BOOL finished) {
                [imageView removeFromSuperview];
            }];
        });
    }
}

- (UIImage *)getLaunchImage {
    // 如果方法不存在直接返回
    if (![UIScreen instancesRespondToSelector:@selector(currentMode)]) return nil;
    // 当前屏幕像素
    CGSize viewSize = [UIScreen mainScreen].currentMode.size;
    // 竖屏
    NSString *viewOrientation = @"Portrait";
    // 获取所有启动图信息
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    // 遍历的启动图信息
    for (NSDictionary* dict in imagesDict) {
        if ([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            // 获取图片名称
            NSString *imageName = dict[@"UILaunchImageName"];
            // 生成图片
            UIImage *image = [UIImage imageNamed:imageName];
            // 获取图片比例
            CGFloat scale = image.scale;
            // 获取图片真实像素
            CGSize imageSize = CGSizeMake(image.size.width * scale, image.size.height * scale);
            // 对比图片像素与屏幕像素, 如果一致, 返回图片
            if (CGSizeEqualToSize(imageSize, viewSize)) {
                return image;
            }
        }
    }
    return nil;
}

#pragma mark - 获取消息未读数量
- (void)getUnreadMgsCount
{
    if ([YYToolModel getUserdefultforKey:USERID] == NULL) return;
    
    GetUnreadMgsApi *api = [[GetUnreadMgsApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if ([api.data isKindOfClass:[NSNull class]])
        {
            NSString * count = api.data[@"message_unread_num"];
            //设置taBbar角标
            UITabBarController *tabBarVC = (UITabBarController*)self.window.rootViewController;
            //获取指定item
            UITabBarItem *item = [[[tabBarVC tabBar] items] objectAtIndex:3];
            //设置item角标数字
            if (count.integerValue > 0)
            {
                item.badgeValue = count;
            }
            else
            {
                item.badgeValue = nil;
            }
        }
        
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}
#pragma mark - 获取用户信息
- (void)getMemberInfo
{
//    [YYToolModel getUserInfoApiRequest:^(NSDictionary *dic) {
//        
//        NSInteger ios_down_style = [dic[@"ios_down_style"] integerValue];
//        if ([DeviceInfo shareInstance].isGameVip) {
//            ios_down_style = 0;
//        }
//        [YYToolModel saveUserdefultValue:[NSString stringWithFormat:@"%ld", (long)ios_down_style] forKey:DOWN_STYLE];
//        
//    }];
}

#pragma mark - 获取首页navBare和tabbar图片
- (void)getHomePageMaterial
{
    MyGetHomePageMaterialApi * api = [[MyGetHomePageMaterialApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        
        NSDictionary * dic = request.data;
        if ([dic isKindOfClass:[NSNull class]] || [dic allKeys].count == 0)
        {
            [MyNewMaterialInfo shareInstance].isShowMaterial = NO;
        }
        else
        {
            NSInteger code = [dic[@"code"] integerValue];
            NSInteger oldCode = [MyNewMaterialInfo shareInstance].materialOldCode.integerValue;
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            BOOL bRet = [fileMgr fileExistsAtPath:[MyNewMaterialInfo shareInstance].filePath];
            //如果当前版本号一致则显示当前路径下的素材,线上版本大于当前的版本号则下载新的素材包
            if (code == oldCode) {
                if (bRet) {
                    [MyNewMaterialInfo shareInstance].isShowMaterial = YES;
                    [MyNewMaterialInfo shareInstance].font_normal_color = dic[@"font_color"][@"font_normal_color"];
                    [MyNewMaterialInfo shareInstance].font_press_color = dic[@"font_color"][@"font_press_color"];
                }else{
                    [MyNewMaterialInfo shareInstance].isShowMaterial = NO;
                }
            }else if (code > oldCode){
                if (bRet) {
                    //删除zip和解压后文件
                    [fileMgr removeItemAtPath:[NSString stringWithFormat:@"%@.zip", [MyNewMaterialInfo shareInstance].zipPath] error:nil];
                    [fileMgr removeItemAtPath:[MyNewMaterialInfo shareInstance].zipPath error:nil];
                }
                else
                {
                    [MyNewMaterialInfo shareInstance].isShowMaterial = NO;
                }
                [self unzipFileMaterial:request.data];
            }
            else
            {
                [MyNewMaterialInfo shareInstance].isShowMaterial = NO;
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetMaterialUI" object:nil];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

//下载zip并解压文件
- (void)unzipFileMaterial:(NSDictionary *)dic
{
    NSString * url = dic[@"material"][@"ios_material"];
    if ([YYToolModel isBlankString:url]) {
        [MyNewMaterialInfo shareInstance].isShowMaterial = NO;
        return;
    }
    [SwpNetworking swpDownloadFile:url swpDownloadProgress:^(SwpDownloadProgress swpDownloadProgress) {
        NSLog(@"swpDownloadProgress -> %lld", swpDownloadProgress.swpCompletedUnitCount);
    } swpCompletionHandler:^(NSString * _Nonnull filePath, NSString * _Nonnull fileName, NSString * _Nonnull error) {
        NSLog(@"%@---%@", filePath, fileName);
        
        if (fileName && filePath)
        {
            NSString * zipPath = [filePath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@", fileName] withString:@""];
            //开始解压.zip
            [SSZipArchive unzipFileAtPath:filePath toDestination:zipPath progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                
            } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                NSLog(@">>>>------%@", path);
                if (path)
                {
                    //存储当前版本号
                    [YYToolModel saveUserdefultValue:dic[@"code"] forKey:@"materialOldCode"];
                }
            }];
        }
    }];
}

#pragma mark - 获取顶部segment的状态
- (void)getTopButtonCount
{
    //先加载本地数据
    NSData * homeData = [YYToolModel getUserdefultforKey:MiluConfigDataCache];
    if (homeData != NULL)
    {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:homeData options:NSJSONReadingMutableContainers error:nil];
        [self parmasConfigData:dic];
    }
    
    //获取折扣和BT显示状态
    SegmentTypeApi * api = [[SegmentTypeApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        NSDictionary * dic = [request.data deleteAllNullValue];
        [self parmasConfigData:dic];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [DeviceInfo shareInstance].navList = @[];
    }];
}

- (void)parmasConfigData:(NSDictionary *)dic
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //存储下载游戏
        NSData * data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingFragmentsAllowed error:nil];
        [YYToolModel saveUserdefultValue:data forKey:MiluConfigDataCache];
    });
    
    
    if ([DeviceInfo shareInstance].isGameVip)
    {
        [YYToolModel saveUserdefultValue:[NSString stringWithFormat:@"%d", 0] forKey:DOWN_STYLE];
    }
    else
    {
//            if ([YYToolModel getUserdefultforKey:USERID] == NULL && [YYToolModel getUserdefultforKey:@"NoLoginDownStyle"] == NULL)
//            {
            NSInteger ios_down_style = [dic[@"ios_down_style"] integerValue];
            [YYToolModel saveUserdefultValue:[NSString stringWithFormat:@"%ld", (long)ios_down_style] forKey:DOWN_STYLE];
//            }
    }
    [YYToolModel saveUserdefultValue:dic[@"is_new_ui"] forKey:NEW_TABBAR_UI];
    [YYToolModel saveUserdefultValue:dic[@"is_close_trade"] forKey:IS_CLOSE_TRADE];
    [YYToolModel saveUserdefultValue:dic[@"is_activity"] forKey:IS_ACTIVITY];
    //是否有新的素材需要下载
    if ([dic[@"is_new_ui"] integerValue] == 1)
    {
//            [self getHomePageMaterial];
    }
    //至尊版下载地址
    if (dic[@"vip_app_url"])
    {
        [YYToolModel saveUserdefultValue:dic[@"vip_app_url"] forKey:@"vip_app_url"];
    }
    //是否打开至尊版通道
    [DeviceInfo shareInstance].isVipPassage = [dic[@"is_vip_passage"] boolValue];
    //是否开启视频介绍
    [DeviceInfo shareInstance].intro_video_url = dic[@"intro_video_url"];
    [DeviceInfo shareInstance].isOpenIntro = [dic[@"is_open_intro"] boolValue];
    //首页右下角的图片
    [DeviceInfo shareInstance].activity_img = dic[@"activity_thumb"];
    //搜索框默认游戏名称
    [DeviceInfo shareInstance].homeSearchDefaultTitleList = dic[@"app_home_search_default_title_list"];
    //月卡显示活动描述
    [DeviceInfo shareInstance].monthCardDesc = dic[@"app_my_tips"];
    //获取udid的加载地址
    [DeviceInfo shareInstance].getUdidUrl = dic[@"udidUrl"];
    //获取点击vip的图片地址
    [DeviceInfo shareInstance].getUdidAlert = dic[@"udidAlert"];
    [DeviceInfo shareInstance].udidAlertBuy = dic[@"udidAlertBuy"];
    //将配置保存
    [DeviceInfo shareInstance].data = dic;
    //是否显示节假日本地图片
    [MyNewMaterialInfo shareInstance].isNewShowMaterial = [dic[@"is_new_material"] boolValue];
    //新人福利显示
    [DeviceInfo shareInstance].timeout = [dic[@"novice_fuli_v2101_expire_time"] integerValue];
    [DeviceInfo shareInstance].novice_fuli_v2101_expire_time = [dic[@"novice_fuli_v2101_expire_time"] integerValue];
    [DeviceInfo shareInstance].novice_fuli_v2101_show = [dic[@"novice_fuli_v2101_show"] integerValue];
    //首页一级菜单新增
    [DeviceInfo shareInstance].menu_items = dic[@"index_menu_items"];
    [DeviceInfo shareInstance].cloudappIndexUrl = dic[@"cloudappIndexUrl"];
    [DeviceInfo shareInstance].cloudappCheckAvailableUrl = dic[@"cloudappCheckAvailableUrl"];
    
    [DeviceInfo shareInstance].navList = dic[@"navList"];
    //TF签名友盟一键登录动态的key
    [DeviceInfo shareInstance].TFSiginVerifyKey = dic[@"qqkey"];
    [DeviceInfo shareInstance].trade_goods_cover = dic[@"trade_goods_cover"];
    [DeviceInfo shareInstance].vipsignLifeTimeDesc = dic[@"vipsignLifeTimeDesc"];
    [DeviceInfo shareInstance].boxBranch = dic[@"boxBranch"];
    [DeviceInfo shareInstance].authConfirmTopTips = dic[@"authConfirmTopTips"];
    [DeviceInfo shareInstance].authConfirmBottomTips = dic[@"authConfirmBottomTips"];
    [DeviceInfo shareInstance].vip_desc = dic[@"vip_desc"];
    [DeviceInfo shareInstance].month_card_desc = dic[@"month_card_desc"];
}

- (void)showStartAppPage
{
    if (![YYToolModel isFirstLoad])
    {
        [YYToolModel initTabbarRootVC];
    }
    else
    {
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                    objectForKey:@"CFBundleShortVersionString"];
        [YYToolModel saveUserdefultValue:currentVersion forKey:LAST_RUN_VERSION_KEY];
    }
}

- (void)localPush:(NSDictionary *)dic {
    NSLog(@"local push = %@",dic);
    if (dic)
    {
        GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
        detailVC.gameID = dic[@"gameId"];
        detailVC.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
        [nav pushViewController:detailVC animated:YES];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
}

// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"noti:%@",notification);

    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSLog(@"not notification.userInfo = %@",notification.userInfo);
    
    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    NSLog(@"not mess = %@",notMess);
    self.localNotId = [notification.userInfo objectForKey:@"kaifuid"];
    if (self.localNotId)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:notMess delegate:self cancelButtonTitle:@"查看" otherButtonTitles:@"取消", nil];
        alert.tag = 590;
        [alert show];
    }
    // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;

    // 在不需要再推送时，可以取消推送
//    [HomeViewController cancelLocalNotificationWithKey:@"key"];
}

- (void)gameContentTableCellBtn:(NSDictionary *)dic {

    GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
    detailVC.gameID = dic[@"game_id"];
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        [nav pushViewController:detailVC animated:YES];

    }
}

// 取消本地推送通知
- (void)cancelLocalNotification {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;

    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
//            // 根据设置通知参数时指定的key来获取通知参数
//            NSString *info = userInfo[key];
//
//            // 如果找到需要取消的通知，则取消
//            if (info != nil) {
//                [[UIApplication sharedApplication] cancelLocalNotification:notification];
//                break;0
//            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //开启后台运行
//    [[XKBGRunManager sharedManager] startBGRun];
    [bgTask startBackgroundTasks:2 target:self selector:@selector(backgroundCallback:)];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    //关闭后台运行
//    [[XKBGRunManager sharedManager] stopBGRun];
    [bgTask stopBackgroundTask];
    //后台计时恢复到0
    self.bgTime = 0;
    self.isFreshMain = NO;
}

- (void) backgroundCallback:(id)info
{
//    NSLog(@"###### BG TASK RUNNING");
    self.bgTime += 2;
//    MYLog(@"----%ld", (long)self.bgTime);
    if (self.bgTime > 1 * 60 * 60 && self.bgTime < 2 * 60 * 60)
    {
        if (!self.isFreshMain)
        {
            self.isFreshMain = YES;
            
            UITabBarController * tabar = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            tabar.selectedIndex = 0;
        }
    }
    else if (self.bgTime > 2 * 60 * 60)
    {
        exit(0);
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //获取当前版本号
//    if (!self.updateView)
//    {
//        [self getVersionApiRequest];
//    }
}

// Availability : iOS (9.0 and later)
-(BOOL)application:(UIApplication*)application continueUserActivity:(nonnull NSUserActivity*)userActivity restorationHandler:(nonnull void(^)(NSArray<id<UIUserActivityRestoring>>*_Nullable))restorationHandler
{
    if([MobClickLink handleUniversalLink:userActivity delegate:self])
    {
        return YES;
    }
    //此处添加以下代码
//    BOOL handledByDeepShare = [Zhuge continueUserActivity:userActivity];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

#pragma mark - 获取当前版本号
- (void)getVersionApiRequest
{
    GetVersionApi *api = [[GetVersionApi alloc] init];
    //    WEAKSELF
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleVersionSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {

    }];
}

- (void)handleVersionSuccess:(GetVersionApi *)api {
    if (api.success == 1)
    {
        self.versionDic = api.data;
        NSInteger step = [self compareVersion:[DeviceInfo shareInstance].appVersion to:self.versionDic[@"version_code"]];
        if (step == -1)
        {
            self.updateView.dataDic = self.versionDic;
        }
    }
}

- (MyAppUpdateView *)updateView
{
    if (_updateView == nil)
    {
        _updateView = [[MyAppUpdateView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [self.window addSubview:_updateView];
    }
    return _updateView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 590)
    {
        if (buttonIndex == 0)
        {
            [self gameContentTableCellBtn:@{@"game_id":self.localNotId}];
        }
        return;
    }
    [self.updateView removeFromSuperview];
    if (buttonIndex == 0) {
        NSURL* nsUrl = [NSURL URLWithString:self.versionDic[@"down_url"]];
        [[UIApplication sharedApplication] openURL:nsUrl];
    }
}

- (void)getMessageApiRequest
{
    GameDownLoadApi *api = [[GameDownLoadApi alloc] init];
    //    WEAKSELF
    api.requestTimeOutInterval = 60;
    api.urls = self.versionDic[@"down_url"];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {

        [self handle2NoticeSuccess:api];

    } failureBlock:^(BaseRequest * _Nonnull request) {

        //        [hud hide:YES];
    }];
}

- (void)handle2NoticeSuccess:(GameDownLoadApi *)api
{
    if (api.success == 1)
    {
        NSURL* nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",api.data[@"url"]]];
        [[UIApplication sharedApplication] openURL:nsUrl];

    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.labelText = [api.error_desc isKindOfClass:[NSNull class]] ? @"下载失败" : api.error_desc;
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.0];
    }
    [self.updateView removeFromSuperview];
}

/**
 比较两个版本号的大小

 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
- (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }

    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }

    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }

    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;

    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }

        // 版本相等，继续循环。
    }

    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}


#pragma mark 提供返回标识
-(BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options {
    
    //SDK相应的跳转
    [self SDKToAppOpenUrl:url];
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (result) {
        return result;
    }
    else if ([url.scheme isEqualToString:[ShareVale sharedInstance].wxappID]) {
        [WXApi handleOpenURL:url delegate:[PayPlug sharedInstance]];
    }else if ([url.scheme isEqualToString:AlipayScheme]){
        //跳转支付宝钱包进行支付，处理支付结果
        //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback: ^(NSDictionary *resultDic) {
                NSLog(@"###222safepay info = %@",resultDic);
                //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方理跟 callback 一样的逻辑】 NSLog(@"result = %@",resultDic);
                NSString *statuCode = resultDic[@"resultStatus"];
                
                if ([statuCode isEqualToString:@"9000"]) {
                    [MBProgressHUD showToast:@"支付宝支付成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MaiYouAlipayReturnFinish" object:nil];
                    
                    NSLog(@"支付宝支付成功");
                }else if([statuCode isEqualToString:@"6001"]){
                    [MBProgressHUD showToast:@"支付宝支付失败,用户取消支付"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MaiYouAlipayReturnFinish" object:nil];
                    NSLog(@"支付宝支付失败,用户取消支付");
                } else{
                    [MBProgressHUD showToast:@"支付宝支付失败"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MaiYouAlipayReturnFinish" object:nil];
                    
                    NSLog(@"支付宝支付失败");
                }
            }];
        }
    }
    else if ([MobClickLink handleLinkURL:url delegate:self])
    {
       return YES;
    }
    else if ([MobClick handleUrl:url]) {
        return YES;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //SDK相应的跳转
    [self SDKToAppOpenUrl:url];
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (result)
    {
        return result;
    }
    else if ([url.scheme isEqualToString:[ShareVale sharedInstance].wxappID])
    {
        [WXApi handleOpenURL:url delegate:[PayPlug sharedInstance]];
    }
    else if ([url.scheme isEqualToString:AlipayScheme])
    {
        //跳转支付宝钱包进行支付，处理支付结果
        //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback: ^(NSDictionary *resultDic) {
                NSLog(@"###safepay info = %@",resultDic);
                //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方理跟 callback 一样的逻辑】 NSLog(@"result = %@",resultDic);
            }];
        }
    }
    else if ([MobClickLink handleLinkURL:url delegate:self])
    {
       return YES;
    }
    
    return YES;
}

- (void)getLinkPath:(NSString *)path params:(NSDictionary *)params
{
    NSLog(@"path=%@,params=%@", path, params);
    if ([params objectForKey:@"b"])
    {
        NSString * gameId = [params objectForKey:@"b"];
        if (gameId.length > 0)
        {
            UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
            GameDetailInfoController *vc = [[GameDetailInfoController alloc] init];
            if ([params objectForKey:@"c"]) {
                vc.c = [params objectForKey:@"c"];
            }
            vc.hidesBottomBarWhenPushed = YES;
            vc.gameID = params[@"b"];
            [nav pushViewController:vc animated:YES];
        }
    }
    //保存渠道
    if ([params objectForKey:@"a"])
    {
        [YYToolModel saveUserdefultValue:params[@"a"] forKey:@"UMLinkGetAgent"];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //SDK相应的跳转
    [self SDKToAppOpenUrl:url];
    
    if ([url.scheme isEqualToString:[ShareVale sharedInstance].wxappID])
    {
        [WXApi handleOpenURL:url delegate:[PayPlug sharedInstance]];
        
    }else if ([url.scheme isEqualToString:AlipayScheme]){
        //跳转支付宝钱包进行支付，处理支付结果
        //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
        if ([url.host isEqualToString:@"safepay"]) {
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback: ^(NSDictionary *resultDic) {
                //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方理跟 callback 一样的逻辑】 NSLog(@"result = %@",resultDic);
            }];
        }
    }
    else if ([MobClickLink handleLinkURL:url delegate:self])
    {
       return YES;
    }
    
    return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler{
    [[YCDownloader downloader] addCompletionHandler:completionHandler identifier:identifier];
}

- (void)setHttpServer
{
//    [self performSelector:@selector(configLocalHttpServer) withObject:nil afterDelay:1];
    //[self configLocalHttpServer];
    
    // 注意打开Xcode工程里的后台定位和后台刷新功能哦~ 不然会crash
//    [BGLocationConfig starBGLocation];
//    [self.serverTimer fire];
}

#pragma mark -- 本地服务器 --
#pragma mark -服务器
#pragma mark - 搭建本地服务器 并且启动
- (void)configLocalHttpServer
{
    _localHttpServer = [[HTTPServer alloc] init];
    [_localHttpServer setType:@"_http.tcp"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/download/100006/video"];
    MYLog(@">>>>[WebFilePath:]%@",path);
    
    if (![fileManager fileExistsAtPath:path]){
        MYLog(@">>>> File path error!");
        if ([fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil])
        {
            [_localHttpServer setDocumentRoot:path];
            MYLog(@">>webLocalPath:%@", path);
            [self startServer];
        }
    }
    else
    {
        NSString *webLocalPath = path;
        [_localHttpServer setDocumentRoot:webLocalPath];
        MYLog(@">>webLocalPath:%@", webLocalPath);
        [self startServer];
    }
}

- (void)startServer
{
    NSError *error;
    if([_localHttpServer start:&error]){
        MYLog(@"Started HTTP Server on port %hu", [_localHttpServer listeningPort]);
        self.port = [NSString stringWithFormat:@"%d", [_localHttpServer listeningPort]];
    }
    else{
        MYLog(@"Error starting HTTP Server: %@", error);
    }
}

- (NSTimer *)serverTimer
{
    if (nil == _serverTimer)
    {
        _serverTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(showServerLoading) userInfo:nil repeats:YES];
        NSRunLoop *curRun = [NSRunLoop currentRunLoop];
        [curRun addTimer:_serverTimer forMode:NSRunLoopCommonModes];
    }
    return _serverTimer;
}

- (void)showServerLoading
{
    MYLog(@"运行ing");
}

@end
