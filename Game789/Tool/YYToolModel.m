//
//  YYToolModel.m
//  Game789
//
//  Created by Maiyou on 2018/8/6.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "YYToolModel.h"
#import <UIKit/UIKit.h>

#import "dlfcn.h"
#import <objc/runtime.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "LoginViewController.h"
#import "DWTabBarController.h"
#import "NoticeDetailViewController.h"
#import "MyJSPatchApi.h"

#import "MyDownGameLoadingView.h"
#import "MyReplyRebateDetailController.h"
#import "ProductDetailsViewController.h"
#import "UserPayGoldViewController.h"
#import "ModifyNameViewController.h"
#import "ModifyPwdViewController.h"
#import "BindMobileViewController.h"
#import "BindVerifyViewController.h"
#import "SecureViewController.h"
#import "GameDetailInfoController.h"
#import "TransactionViewController.h"
#import "DWTabBarController.h"
#import "UserPayGoldViewController.h"
#import "MyGameHallSubsectionController.h"
#import "MyTaskViewController.h"
#import "MyHomeCouponCenterController.h"
#import "MyVoucherListViewController.h"
#import "MyGiftViewController.h"
#import "MyTransferViewController.h"
#import "MyProjectGameController.h"
#import "MyGetMuliVipCoinsView.h"
#import "MyNoviceTaskController.h"
#import "MyGoldMallViewController.h"
#import "MyTradeFliterViewController.h"
#define MyClient_id @"87913743"
#define MYClient_secret @"2%!8(&*49)_6+!#^&*"
#define MYNoncestr @"^V8&d#6@(B9V@#(@*e"

@implementation YYToolModel

static YYToolModel* _instance = nil;
+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[YYToolModel alloc] init] ;
    });
    return _instance ;
}

+ (NSArray *)replaceArray{
    return @[@"banner_home_top",@"banner_photo_corner",@"banner_photo",@"game_shotscreen_bg",@"opening_notice_placeholder",@"game_icon"];
}

+ (UIImage *)loadImageWithImageName:(NSString *)name{
    if ([[self replaceArray] containsObject:name] && [[DeviceInfo.shareInstance getFileContent:@"TUUChannel"] isEqualToString:@"ue70"]) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"52_%@",name]];
    }
    return [UIImage imageNamed:name];
}

+ (BOOL) isFirstLoad
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
//        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
//        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    return NO;
}

#pragma mark 获取个人信息
+ (void)getUserInfoApiRequest:(void(^)(NSDictionary * dic))respondData
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (userId && userId.length > 0) {
        GetUserInfoApi *api = [[GetUserInfoApi alloc] init];
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            
            if (api.success == 1)
            {
                NSDictionary * dic = api.data[@"member_info"] ;
                dic = [dic deleteAllNullValue];
                [YYToolModel saveUserdefultValue:dic[@"member_name"] forKey:@"user_name"];
                [YYToolModel saveUserdefultValue:dic forKey:@"member_info"];
                //新人福利显示
                [DeviceInfo shareInstance].timeout = [dic[@"novice_fuli_v2101_expire_time"] integerValue];
                [DeviceInfo shareInstance].novice_fuli_v2101_expire_time = [dic[@"novice_fuli_v2101_expire_time"] integerValue];
                [DeviceInfo shareInstance].novice_fuli_v2101_show = [dic[@"novice_fuli_v2101_show"] integerValue];
                [DeviceInfo shareInstance].novice_fuli_eight_time = [dic[@"is_show_reg_between_8day_30day"] integerValue];
                [DeviceInfo shareInstance].novice_fuli_thirty_time = [dic[@"is_show_reg_gt_30day"] integerValue];
                [DeviceInfo shareInstance].reg_gt_30day_url = dic[@"reg_gt_30day_url"];
                
                respondData(dic);
            }
            else
            {
                [YYToolModel deleteUserdefultforKey:USERID];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
}

+ (void)initTabbarRootVC
{
    DWTabBarController *tabBarC = [[DWTabBarController alloc] init];
    tabBarC.selectedIndex = 0;
    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    window.rootViewController = tabBarC;
    [window makeKeyAndVisible];
}

+ (UIViewController *)jsd_getRootViewController{

    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (UIViewController *)getCurrentVC {
    
    UIViewController* currentViewController = [self jsd_getRootViewController];

    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    return currentViewController;
}

+ (void)setGradientColor:(UIView *)view CornerRadius:(CGFloat)radius ColorArray:(NSArray *)colorArray
{
    if (colorArray == nil || colorArray.count == 0)
    {
        colorArray = [NSArray arrayWithObjects:(id)MYColor(255, 138, 28).CGColor,(id)MYColor(255, 205, 90).CGColor, nil];
    }
    //设置渐变色背景
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = colorArray;
    [view.layer addSublayer:gradient];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1.0, 0);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = radius;
}

+ (BOOL)islogin
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (!userId || userId == NULL)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (BOOL)isAlreadyLogin
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (!userId || userId == NULL)
    {
        LoginViewController *VC = [[LoginViewController alloc] init];
        VC.hidesBottomBarWhenPushed = YES;
        [[self getCurrentVC].navigationController pushViewController:VC animated:YES];
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (NSString *)getShareIconName
{
    NSString * channelTag = [DeviceInfo shareInstance].channelTag;
    if (channelTag.integerValue == 2 || channelTag.integerValue == 3)
    {
        return [NSString stringWithFormat:@"icon_share%@", channelTag];
    }
    return @"icon_share0";
}

/** 本地存储 */
+ (void)saveUserdefultValue:(id)value forKey:(NSString *)fileName
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    [userDefults setObject:value forKey:fileName];
    [userDefults synchronize];
    
}
/** 本地取值 */
+ (id)getUserdefultforKey:(NSString *)fileName{
    
    NSUserDefaults *userDefults =[NSUserDefaults standardUserDefaults];
    
    NSString *valueString = [userDefults objectForKey:fileName];
    
    return valueString;
}

/** 本地删除 */
+(void)deleteUserdefultforKey:(NSString *)fileName{
    
    NSUserDefaults *userDefults =[NSUserDefaults standardUserDefaults];
    
    [userDefults removeObjectForKey:fileName];
}


//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGSize)sizeWithText:(NSString *)text size:(CGSize)size font:(UIFont *)font
{
    
    CGRect rect = [text boundingRectWithSize:size
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    return rect.size;
}

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

/**
 *  通过 Quartz 2D 在 UIImageView 绘制虚线
 *
 *  param imageView 传入要绘制成虚线的imageView
 *  return
 */

+ (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView
{
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {5,5};
    
    CGContextSetStrokeColorWithColor(line, [UIColor greenColor].CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 2);
    
    CGContextMoveToPoint(line, 0.0, 2.0);
    
    CGContextAddLineToPoint(line, 300, 2.0);
    
    CGContextStrokePath(line);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return image;
}

//判断字符是否为空
+ (BOOL)isBlankString:(NSString *)aStr
{
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

//通过图片Data数据第一个字节 来获取图片扩展名
+ (NSString *)contentTypeForImageData:(NSString *)path {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

/// 通过 bundle identifier 跳转到其他App
+ (BOOL)openApp:(NSString *)bundleId
{
    return NO;
}

+ (BOOL)isInstalled:(NSString *)BundleID IsList:(BOOL)isList
{
    return NO;
}

+ (NSString *)getIpaDownloadStatus:(YCDownloadItem *)item
{
    NSDictionary * downDic = [NSJSONSerialization JSONObjectWithData:item.extraData options:0 error:nil];
    switch (item.downloadStatus) {
        case YCDownloadStatusPaused:
        return @"暂停";
        break;
        case YCDownloadStatusDownloading:
        return @"下载中";
        break;
        case YCDownloadStatusFinished:
        {
            NSString * bundleid = downDic[@"my_ios_bundleid"];
            if ([YYToolModel isInstalled:bundleid IsList:YES]) {
                return @"打开";
            }
            else
            {
                return @"安装";
            }
        }
        break;
        
        default:
        break;
    }
    return @"下载";
}

+ (void)installAppForItem:(YCDownloadItem *)item
{
    AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *port = appd.port;
    if (nil == port) {
        MYLog(@">>> Error:端口不存在");
        [appd configLocalHttpServer];
        return;
    }
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:item.extraData options:0 error:nil];
    NSString * plist = [NSString stringWithFormat:@"https://plist.wakaifu.com/install/appplist/game_id/%@/port/%@/app.plist", dic[@"my_ios_gameid"], port];
    NSString * url = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", plist];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    hud.label.text = @"请稍后...";
    [hud hideAnimated:YES afterDelay:1.5];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)getIpaDownloadUrl:(NSString *)str Data:(NSDictionary *)dic Vc:(UIViewController *)vc IsPackage:(BOOL)isPackage
{
    NSString * bundleid = @"";
    NSString * url = @"";
    if ([str containsString:@"url="])
    {
        NSRange range = [str rangeOfString:@"url="];
        NSString * plistUrl = [str substringFromIndex:range.location + 4];
        NSDictionary * metaDic = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:plistUrl]];
        url = metaDic[@"items"][0][@"assets"][0][@"url"];
        bundleid = metaDic[@"items"][0][@"metadata"][@"bundle-identifier"];
    }
    
    NSString * maiyou_gameid = dic[@"maiyou_gameid"];
    
    NSMutableDictionary * gameData = [NSMutableDictionary dictionaryWithDictionary:dic];
    [gameData setValue:maiyou_gameid forKey:@"my_ios_gameid"];
    [gameData setValue:bundleid forKey:@"my_ios_bundleid"];
    [gameData setValue:dic[@"game_id"] forKey:@"my_gameid"];
    
    YCDownloadItem *item = nil;
    if (maiyou_gameid) {
        item = [YCDownloadManager itemWithFileId:maiyou_gameid];
    }
    if (!item) {
        item = [YCDownloadItem itemWithUrl:url fileId:maiyou_gameid];
        item.extraData = [NSJSONSerialization dataWithJSONObject:gameData options:0 error:nil];
        item.saveRootPath = @"ipa";
        item.enableSpeed = YES;
        [YCDownloadManager startDownloadWithItem:item];
    }
//    if (!isPackage)
//    {
//        DownLoadManageController *download = [[DownLoadManageController alloc] init];
//        download.hidesBottomBarWhenPushed = YES;
//        [vc.navigationController pushViewController:download animated:true];
//    }
}

+ (void)loadIpaUrl:(UIViewController *)vc Url:(NSString *)url
{
    if ([DeviceInfo shareInstance].networkState == 1)
    {
        [vc jxt_showAlertWithTitle:@"温馨提示" message:@"由于ios系统限制，超过100M的文件可能无法在2G/3G/4G网络环境下安装，建议使用WIFI或者个人热点进行安装" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.addActionCancelTitle(@"取消".localized).addActionDestructiveTitle(@"继续".localized);
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex == 1)
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
                hud.label.text = @"请稍后...".localized;
                [hud hideAnimated:YES afterDelay:1.5];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
        hud.label.text = @"请稍后...".localized;
        [hud hideAnimated:YES afterDelay:1.5];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

+ (NSMutableURLRequest *)requestHeaderAddParas:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *agent = [DeviceInfo shareInstance].channel;
    NSString *gameid = [ShareVale sharedInstance].gameID;
    NSString *deviceType = [ShareVale sharedInstance].phoneType;
    NSString *appid = [ShareVale sharedInstance].appID;
    NSString *deviceName = [DeviceInfo shareInstance].deviceModel;
    if (!agent || agent.length == 0) {
        agent = @"";
    }
    if (!gameid ||gameid.length == 0) {
        gameid = @"";
    }
    if (!appid ||appid.length == 0) {
        appid = @"";
    }
    [mutableRequest setValue:agent forHTTPHeaderField:@"agent"];
    [mutableRequest setValue:gameid forHTTPHeaderField:@"gameid"];
    [mutableRequest setValue:[ShareVale sharedInstance].token forHTTPHeaderField:@"token"];
    [mutableRequest setValue:@"ios" forHTTPHeaderField:@"clienttype"];
    [mutableRequest setValue:appid forHTTPHeaderField:@"appid"];
    [mutableRequest setValue:deviceType forHTTPHeaderField:@"device-type"];
    [mutableRequest setValue:deviceName forHTTPHeaderField:@"device-name"];
    [mutableRequest setValue:[DeviceInfo shareInstance].appVersion forHTTPHeaderField:@"sdkversion"];
    return mutableRequest;
}

- (BOOL)vipDownloadGame:(NSDictionary *)parmaDic
{
//1、默认下载方式；2、通过safari打开vip_ios_url；3、内部下载安装游戏（个人签名版）
    NSInteger down_type = [parmaDic[@"down_type"] integerValue];
    if (down_type == 3)
    {
        [self loadingView:parmaDic];
        return YES;
    }
    else if (down_type == 2)
    {
        [self loadingView:parmaDic];
        return NO;
    }
    return NO;
}

- (void)loadingView:(NSDictionary *)parmaDic
{
    NSString * maiyou_gameid = parmaDic[@"maiyou_gameid"];
    NSInteger down_type = [parmaDic[@"down_type"] integerValue];
    if ([maiyou_gameid isEqualToString:@"152"] || down_type == 2)
    {
        MyDownGameLoadingView * loadingView = [[MyDownGameLoadingView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        loadingView.downType = down_type;
        loadingView.gameid = maiyou_gameid;
        loadingView.GetVipGameDownUrl = ^(NSInteger code, NSString * _Nonnull url){
            
        };
        [[UIApplication sharedApplication].keyWindow addSubview:loadingView];
    }
    else
    {
        MyDownGameLoadingView * loadingView = [[MyDownGameLoadingView alloc] init];
        loadingView.gameid = maiyou_gameid;
        loadingView.GetVipGameDownUrl = ^(NSInteger code, NSString * _Nonnull url){
            if (self.VipDownUrl)
            {
                self.VipDownUrl(code, url);
            }
        };
    }
}

+ (void)pushVcForType:(NSString *)type Value:(NSString *)value Vc:(UIViewController *)vc
{
    if ([self isBlankString:value])
    {
        return;
    }
    
    if ([type isEqualToString:@"game_info"]) {
        //游戏详情
        
        GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
        detailVC.gameID = value;
        //        detailVC.title = dic[@"game_name"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:detailVC animated:YES];
    }
    else if ([type isEqualToString:@"news_info"]) {
        //资讯详情
        NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
        detailVC.news_id = value;
        detailVC.hidesBottomBarWhenPushed = YES;
        [vc.navigationController pushViewController:detailVC animated:YES];
    }
    else if ([type isEqualToString:@"outer_web"] || [type isEqualToString:@"work_weixin"]) {
        //web 外部
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:value]];
    }
    else if ([type isEqualToString:@"rebate"] || [type isEqualToString:@"rebate_info"])
    {
        //返利
        MyReplyRebateDetailController * detail = [MyReplyRebateDetailController new];
        detail.hidesBottomBarWhenPushed = YES;
        detail.rebate_id = value;
        [vc.navigationController pushViewController:detail animated:YES];
    }
    else if ([type isEqualToString:@"inner_web"])
    {
        //web详情
        NSString * userName = [YYToolModel getUserdefultforKey:@"user_name"];
        NSString * token = [YYToolModel getUserdefultforKey:TOKEN];
        NSString * url = value;
        if (token && userName)
        {
            url = [value urlAddCompnentForValue:userName key:@"username"];
            url = [url urlAddCompnentForValue:token key:@"token"];
        }
        
        WebViewController * payVC = [[WebViewController alloc]init];
        payVC.hidesBottomBarWhenPushed = YES;
        payVC.urlString = url;
        [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
    }
    else if ([type isEqualToString:@"trades_info"])
    {
        //交易详情
        ProductDetailsViewController * detail = [[ProductDetailsViewController alloc] init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.trade_id = value;
        [vc.navigationController pushViewController:detail animated:YES];
    }
}

//添加客服的悬浮按钮
- (void)initAddEventBtn:(UIViewController *)vc Top:(CGFloat)top
{
    self.currentVC = vc;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - 58, top, 50, 50)];
    [btn setBackgroundImage:[UIImage imageNamed:@"contact_service"]  forState:UIControlStateNormal];
    btn.tag = 0;
    btn.layer.cornerRadius = btn.height;
    [vc.view addSubview:btn];
    self.spButton = btn;
    [btn addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    [vc.view bringSubviewToFront:btn];
    //添加手势
    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [btn addGestureRecognizer:panRcognize];
}

- (void)addEvent:(UIButton *)sender
{
    MyCustomerServiceController *webVC = [[MyCustomerServiceController alloc] init];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:webVC animated:YES];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [recognizer translationInView:self.currentVC.navigationController.view];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint stopPoint = CGPointMake(0, kScreenH / 2.0);
            
            if (recognizer.view.center.x < kScreenW / 2.0) {
                if (recognizer.view.center.y <= kScreenH/2.0) {
                    //左上
                    if (recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.spButton.width/2.0);
                    }else{
                        stopPoint = CGPointMake(self.spButton.width/2.0, recognizer.view.center.y);
                    }
                }else{
                    //左下
                    if (recognizer.view.center.x  >= kScreenH - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, kScreenH - self.spButton.width/2.0);
                    }else{
                        stopPoint = CGPointMake(self.spButton.width/2.0, recognizer.view.center.y);
                        //                        stopPoint = CGPointMake(recognizer.view.center.x, kScreenH - self.spButton.width/2.0);
                    }
                }
            }else{
                if (recognizer.view.center.y <= kScreenH/2.0) {
                    //右上
                    if (kScreenW - recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.spButton.width/2.0);
                    }else{
                        stopPoint = CGPointMake(kScreenW - self.spButton.width/2.0, recognizer.view.center.y);
                    }
                }else{
                    //右下
                    if (kScreenW - recognizer.view.center.x  >= kScreenH - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, kScreenH - self.spButton.width/2.0);
                    }else{
                        stopPoint = CGPointMake(kScreenW - self.spButton.width/2.0,recognizer.view.center.y);
                    }
                }
            }
            
            //如果按钮超出屏幕边缘
            if (stopPoint.y + self.spButton.width+40>= kScreenH) {
                stopPoint = CGPointMake(stopPoint.x, kScreenH - self.spButton.width/2.0-49);
                NSLog(@"超出屏幕下方了！！"); //这里注意iphoneX的适配。。X的SCREEN高度算法有变化。
            }
            if (stopPoint.x - self.spButton.width/2.0 <= 0) {
                stopPoint = CGPointMake(self.spButton.width/2.0, stopPoint.y);
            }
            if (stopPoint.x + self.spButton.width/2.0 >= kScreenW) {
                stopPoint = CGPointMake(kScreenW - self.spButton.width/2.0, stopPoint.y);
            }
            if (stopPoint.y - self.spButton.width/2.0 <= 0) {
                stopPoint = CGPointMake(stopPoint.x, self.spButton.width/2.0);
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                recognizer.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.currentVC.view];
}

+ (NSString *)md5EncryptionForRequest:(NSString *)timestamp
{
    NSString * md5Str = [NSString stringWithFormat:@"%@%@%@%@", MYNoncestr, MyClient_id, timestamp, MYClient_secret];
    md5Str = [md5Str md5HashToLower32Bit];
    return md5Str;
}

+ (NSArray *)gifChangeToImages:(NSString *)fileName
{
    //1. 拿到gif数据
    NSString * gifPathSource = [[NSBundle mainBundle] pathForResource:fileName ofType:@"gif"];
    NSData * data = [NSData dataWithContentsOfFile:gifPathSource];
#warning 桥接的意义 (__bridge CFDataRef)
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    //2. 将gif分解为一帧帧
    size_t count = CGImageSourceGetCount(source);
    NSLog(@"%zu", count);
    
    NSMutableArray * tmpArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < count; i ++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        //3. 将单帧数据转为UIImage
        UIImage * image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        [tmpArray addObject:image];
#warning CG类型的对象 不能用ARC自动释放内存.需要手动释放
        CGImageRelease(imageRef);
    }
    CFRelease(source);
    return tmpArray;
}

+ (void)getLibraryAuthorizationStatus
{
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 此应用程序没有被授权访问的照片数据。可能是家长控制权限。
        NSLog(@"因为系统原因, 无法访问相册");
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝访问相册
        [[YYToolModel getCurrentVC] jxt_showAlertWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - 项目名称] 打开访问开关" appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.addActionCancelTitle(@"取消").addActionDefaultTitle(@"确定");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            if (buttonIndex == 1) {
                // 系统是否大于10
                NSURL *url = nil;
                if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
                    url = [NSURL URLWithString:@"prefs:root=privacy"];
                    
                } else {
                    url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                }
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) { //用户允许访问相册
        // 放一些使用相册的代码
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
              // 放一些使用相册的代码
            }
        }];
    }
}

- (void)showUIFortype:(NSString *)string Parmas:(NSString *)exts
{
    if ([string isEqualToString:@"news_info"])
    {
        //资讯详情
        NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
        detailVC.news_id = exts;
        detailVC.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:detailVC animated:YES];
    }
    else if ([string isEqualToString:@"outer_web"] || [string isEqualToString:@"work_weixin"])
    {
        //web 外部
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:exts] options:@{} completionHandler:nil];
    }
    else if ([string isEqualToString:@"inner_web"])
    {
        NSString * url = [NSString stringWithFormat:@"%@%@username=%@&token=%@", exts, [exts containsString:@"?"] ? @"&" : @"?", [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
        //web详情
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.urlString = url;
        [[YYToolModel getCurrentVC].navigationController pushViewController:webVC animated:YES];
    }
    else if ([string isEqualToString:@"nickname"])//修改昵称
    {
        [self pushModifyNickNameVC];
    }
    else if ([string isEqualToString:@"mobile"])//修改手机号
    {
        [self pushBindMobileVC];
    }
    else if ([string isEqualToString:@"authentication"])//修改实名认证
    {
        [self pushModifyIDVC];
    }
    else if ([string isEqualToString:@"avatar"])//修改头像
    {
        SecureViewController * secure = [SecureViewController new];
        secure.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:secure animated:YES];
    }
    else if ([string isEqualToString:@"rechargeTransfer"])//充值转移
    {
        [self pushChargeTransfer];
    }
    else if ([string isEqualToString:@"share"])//分享
    {
        [self pushShareInviteFriend:exts];
    }
    else if ([string isEqualToString:@"qq"])//修改
    {
        [self pushModifyQQVC];
    }
    else if ([string isEqualToString:@"game"] || [string isEqualToString:@"game_info"])//游戏详情
    {
        GameDetailInfoController * game = [GameDetailInfoController new];
        game.gameID = exts;
        game.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:game animated:YES];
    }
    else if ([string isEqualToString:@"monthly_card"])//月卡
    {
        [MyAOPManager userInfoRelateStatistic:@"ClickMonthlycardFromMembershipCenter"];
        
        SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
        payVC.selectedIndex = 0;
        payVC.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
    }
    else if ([string isEqualToString:@"rechargePtb"])//平台币
    {
        [self platform:NO];
    }
    else if ([string isEqualToString:@"rechargeVip"])//会员
    {
        SaveMoneyCardViewController * payVC = [[SaveMoneyCardViewController alloc]init];
        payVC.selectedIndex = 1;
        payVC.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
    }
    else if ([string isEqualToString:@"task"])//赚金
    {
        MyTaskViewController * task = [MyTaskViewController new];
        task.isPush = YES;
        task.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:task animated:YES];
    }
    else if ([string isEqualToString:@"voucher"])//代金券列表
    {
        MyHomeCouponCenterController * task = [MyHomeCouponCenterController new];
        task.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:task animated:YES];
    }
    else if ([string isEqualToString:@"myVoucher"])//我的代金券
    {
        MyVoucherListViewController * task = [MyVoucherListViewController new];
        task.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:task animated:YES];
    }
    else if ([string isEqualToString:@"myGifts"])//我的礼包
    {
        MyGiftViewController * task = [MyGiftViewController new];
        task.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:task animated:YES];
    }
    else if ([string isEqualToString:@"project"] || [string isEqualToString:@"special"])//游戏专题
    {
        MyProjectGameController * task = [MyProjectGameController new];
        task.hidesBottomBarWhenPushed = YES;
        task.project_id = exts;
        [[YYToolModel getCurrentVC].navigationController pushViewController:task animated:YES];
    }
    else if ([string isEqualToString:@"holidayEvent"] || [string isEqualToString:@"answerReward"] || [string isEqualToString:@"syGift"])//活动和答题
    {
        if (![YYToolModel isAlreadyLogin]) return;
        NSString * url = [NSString stringWithFormat:@"%@%@username=%@&token=%@", exts, [exts containsString:@"?"] ? @"&" : @"?", [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.urlString = url;
        [[YYToolModel getCurrentVC].navigationController pushViewController:webVC animated:YES];
    }
    else if ([string isEqualToString:@"noviceTask"])//新人福利
    {
        [[YYToolModel getCurrentVC].navigationController pushViewController:[MyNoviceTaskController new] animated:YES];
    }
    else if ([string isEqualToString:@"goldMall"])//金币商城
    {
        [[YYToolModel getCurrentVC].navigationController pushViewController:[MyGoldMallViewController new] animated:YES];
    }
    else if([string isEqualToString:@"tradeGoods"]){
        MyTradeFliterViewController * trade = [[MyTradeFliterViewController alloc]init];
        trade.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:trade animated:YES];
    }
    else
    {
        NSString *className = string; //classNames 字符串数组集
        Class class = NSClassFromString(className);
        if (class && className)
        {
            BaseViewController *ctrl = class.new;
            ctrl.hidesBottomBarWhenPushed = YES;
            [[YYToolModel getCurrentVC].navigationController pushViewController:ctrl animated:YES];
        }
    }
}

#pragma mark - 分享邀请好友
- (void)pushShareInviteFriend:(NSString *)type
{
    [[YYToolModel getCurrentVC].navigationController pushViewController:[MyInviteFriendsController new] animated:YES];
}

- (void)pushChargeTransfer
{
    MyTransferViewController * transfer = [MyTransferViewController new];
    [[YYToolModel getCurrentVC].navigationController pushViewController:transfer animated:YES];
}

#pragma mark 平台币
- (void)platform:(BOOL)isMember
{
    UserPayGoldViewController * payVC = [[UserPayGoldViewController alloc]init];
    payVC.hidesBottomBarWhenPushed = YES;
    isMember ? (payVC.isMember = YES) : (payVC.isRecharge = YES);
    payVC.isFullScreen = isMember;
    [[YYToolModel getCurrentVC].navigationController pushViewController:payVC animated:YES];
}

#pragma mark — 跳转到QQ
- (void)pushModifyQQVC
{
    ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
    bindVC.title = @"QQ";
    bindVC.hidesBottomBarWhenPushed = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:bindVC animated:YES];
}

- (void)pushModifyNickNameVC {
    ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
    bindVC.title = @"昵称";
    bindVC.hidesBottomBarWhenPushed = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:bindVC animated:YES];
}

- (void)pushModifyIDVC {
    ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
    bindVC.title = @"实名认证";
    bindVC.hidesBottomBarWhenPushed = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:bindVC animated:YES];
}

- (void)pushBindMobileVC
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"];
    NSString *moblie = dic[@"mobile"];
    
    if (!moblie || moblie.length == 0)
    {
        BindMobileViewController *bindVC = [[BindMobileViewController alloc] init];
        bindVC.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:bindVC animated:YES];
    }
    else
    {
        BindVerifyViewController *verifyVC = [[BindVerifyViewController alloc]init];
        verifyVC.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:verifyVC animated:YES];
    }
}

+ (NSDictionary *)getParamsWithUrlString:(NSURL *)urlString{
    NSString * url = [NSString stringWithFormat:@"%@",urlString];
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    NSArray * paramsArray = [[url componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"&"];
    for (NSString * string in paramsArray) {
        NSString * key = [string componentsSeparatedByString:@"="].firstObject;
        NSString * value = [NSString stringWithFormat:@"%@",[string componentsSeparatedByString:@"="].lastObject];
        [params setValue:value forKey:key];
    }
    return params;
}

+ (BOOL)getIsIpad
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
}

- (void)getMiluVipCions
{
    GetMiluVipCionsApi * api = [[GetMiluVipCionsApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if ([request.data[@"balance"] boolValue])
        {
            MyGetMuliVipCoinsView * coinView = [[MyGetMuliVipCoinsView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
            coinView.noticeLabel.text = request.data[@"content"];
            [[UIApplication sharedApplication].keyWindow addSubview:coinView];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

//加密
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
      
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
      
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode | kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        NSLog(@"resultData=%@",[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding]);
        //return [GTMBase64 stringByEncodingData:resultData];
//        return [self hexStringFromData:resultData];
        return [resultData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    free(buffer);
    return nil;
}
//解密
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
      
    //NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
      
//    NSData *data=[self dataForHexString:encryptText];
    NSData * data = [[NSData alloc] initWithBase64EncodedString:encryptText options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
      
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionECBMode | kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}
// 普通字符串转换为十六进
+ (NSString *)hexStringFromData:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    // 下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff]; //16进制数
        newHexStr = [newHexStr uppercaseString];
          
        if([newHexStr length] == 1) {
            newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
        }
          
        hexStr = [hexStr stringByAppendingString:newHexStr];
          
    }
    return hexStr;
}
//十六进制转Data
//十六进制转Data
+ (NSData*)dataForHexString:(NSString*)hexString
{
    if (hexString == nil) {
        return nil;
    }
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        if (*ch == ' ') {
            continue;
        }
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            byte = *ch - '0';
        }else if ('a' <= *ch && *ch <= 'f') {
            byte = *ch - 'a' + 10;
        }else if ('A' <= *ch && *ch <= 'F') {
            byte = *ch - 'A' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch) {
            if ('0' <= *ch && *ch <= '9') {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f') {
                byte += *ch - 'a' + 10;
            }else if('A' <= *ch && *ch <= 'F'){
                byte += *ch - 'A' + 10;
            }
            ch++;
        }
        [data appendBytes:&byte length:1];
    }
    return data;
}

+ (void)clipRectCorner:(UIRectCorner)corner radius:(CGFloat)radius view:(UIView *)view{
    [view layoutIfNeeded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect rect = CGRectMake(0, 0, view.width, view.height);
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = rect;
        maskLayer.path = path.CGPath;
        view.layer.mask = maskLayer;
    });
}

+ (NSString *)homeCellHeightPath{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"homeCellHeight.plist"];
    return plistPath;
}

+ (NSDictionary *)getHomeCellData{
    return [[NSDictionary alloc] initWithContentsOfFile:[self homeCellHeightPath]];
}

+ (void)saveHeight:(CGFloat)cellHeight forKey:(NSString *)key{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:[self getHomeCellData]];
    [dict setValue:[NSString stringWithFormat:@"%.0f",cellHeight] forKey:key];
    [dict writeToFile:[self homeCellHeightPath] atomically:YES];
}

+ (CGFloat)getHomeCellForKey:(NSString *)key{
    return [[[self getHomeCellData] objectForKey:key] floatValue];
}

//保存缓存数据
+ (void)saveCacheData:(id)data forKey:(NSString *)key;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData * data1 = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingFragmentsAllowed error:nil];
        [YYToolModel saveUserdefultValue:data1 forKey:key];
    });
}

//获取缓存数据
+ (id)getCacheData:(NSString *)key
{
    NSData * homeData = [self getUserdefultforKey:key];
    if (homeData != NULL)
    {
        id data = [NSJSONSerialization JSONObjectWithData:homeData options:NSJSONReadingMutableContainers error:nil];
        return data;
    }
    return nil;
}

@end
