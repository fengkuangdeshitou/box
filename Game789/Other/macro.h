//
//  macro.h
//  LoveViteApp
//
//  Created by weiheng on 2017/6/13.
//  Copyright © 2017年 ven. All rights reserved.
//

#ifndef macro_h
#define macro_h
/***************测试接口******************/
//#define Base_Request_Url @"http://testapi2.app.99maiyou.com/"
////邀请好友 充值转移
//#define Invite_Url       @"http://testadm2.app.99maiyou.com/"
////支付 签到
//#define UserPay          @"http://testsys.99maiyou.com/"

/**************正式环境*******************/
//#ifdef DEBUG
//#define Base_Request_Url @"http://192.168.1.80/"
//#else
#define Base_Request_Url @"https://api3.app.wakaifu.com/"
//#endif
#define UserPay          @"https://sys.wakaifu.com/"
#define Invite_Url       @"https://m.app.wakaifu.com/"
#define K_AES_KEY          @"2%!9vn8(&MK*49)_"

#define RESIGN_TIME 30

/**  判断前缀  */
#define Down_Game_Url @"itms"

#define TOKEN @"token"
#define USERID @"user_id"
#define DOWN_STYLE @"DownLoadStyle"
#define NEW_TABBAR_UI @"IOS_NEW_UI"
#define IS_CLOSE_TRADE @"IsCloseTrade"
#define IS_ACTIVITY @"IsActivity"
#define MILU_UDID @"MiluDeviceUdid"
#define AREA_CODE @"MiluSelectedCountryCode"
#define MY_BAIDU_OCPC @"MY_Baidu_Ocpc"
#define MiluConfigDataCache @"MiluConfigDataCache"
#define MiluHomeDataCache @"MiluHomeDataCache"
#define MiluWelfareCenterDataCache @"MiluWelfareCenterDataCache"
#define MiluGameMallDataCache @"MiluGameMallDataCache"
#define MiluGameTypeListCache @"MiluGameTypeListCache"
#define MiluTradeListCache @"MiluTradeListCache"

#define AUTHID @"salt_key"
#define Base_Key @"985game_api_nFWn18Wm"

#define kLoginNotice @"kNotificationLoginIn"
#define kLoginExitNotice @"kNotificationLoginOut"

#define kScreen_height  [[UIScreen mainScreen] bounds].size.height
#define kScreen_width   [[UIScreen mainScreen] bounds].size.width

#define MainNaviBarColor @"#e54724"

#define LoginUserAgreementUrl [NSString stringWithFormat:@"%@?channel=%@", @"https://api3.app.wakaifu.com/userAgreement", [DeviceInfo shareInstance].channel]

#define LoginPrivacyPolicyUrl [NSString stringWithFormat:@"%@?channel=%@",  @"https://api3.app.wakaifu.com/privacyPolicy", [DeviceInfo shareInstance].channel]
//免责声明
#define DisclaimerUrl [NSString stringWithFormat:@"%@respons?channel=%@", Base_Request_Url, [DeviceInfo shareInstance].channel]
//转游说明
#define TransferInstructionsUrl [NSString stringWithFormat:@"%@%@?channel=%@", Base_Request_Url, @"transferDesc.html", [DeviceInfo shareInstance].channel]

//保存账号密码
#define SaveUserLoginAccount [NSString stringWithFormat:@"%@%@", [DeviceInfo shareInstance].boxBranch, @"SaveUserLoginAccount"]

// status bar height.

#define  kStatusBarHeight      (IS_IPhoneX_All ? 44.f : 20.f)

// Navigation bar height.

#define  kNavigationBarHeight  (IS_IPhoneX_All ? 88.f : 64.f)

// Tabbar height.

#define  kTabbarHeight         (IS_IPhoneX_All ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.

#define  kTabbarSafeBottomMargin        (IS_IPhoneX_All ? 34.f : 0.f)

// Status bar & navigation bar height.

#define  kStatusBarAndNavigationBarHeight  (IS_IPhoneX_All ? 88.f : 64.f)

// Tabbar safe bottom margin.
#define  kTabbarSafeBottomMargin         (IS_IPhoneX_All ? 34.f : 0.f)

#define SegmentViewHeight (kStatusBarHeight + 44)

//判断是否iPhone X
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_iPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

//判断是否是iphone 6+,6s+,7+,8+
#define IS_iPhone_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是iphone 6,6s,7,8
#define IS_iPhone_Normal ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//iphone 5系列
#define IS_iPhone_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是ipad
#define is_iPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !is_iPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !is_iPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !is_iPad : NO)

//添加如下宏
#define IsiPhone11 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define IsiPhone11Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IsiPhone11ProMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhone12_Mini
#define Is_iPhone12_Mini ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 2340), [[UIScreen mainScreen] currentMode].size) && !is_iPad : NO)
//判断iPhone12 | 12Pro
#define Is_iPhone12 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) && !is_iPad : NO)
//判断iPhone12 Pro Max
#define Is_iPhone12_ProMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) && !is_iPad : NO)

#define Is_iPhone14_Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1179, 2556), [[UIScreen mainScreen] currentMode].size) && !is_iPad : NO)

#define Is_iPhone14_ProMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1290, 2796), [[UIScreen mainScreen] currentMode].size) && !is_iPad : NO)


#define IS_IPhoneX_All (IS_IPHONE_Xs_Max == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xr == YES || IS_iPhoneX == YES || Is_iPhone12_Mini == YES || Is_iPhone12 == YES || Is_iPhone12_ProMax == YES || Is_iPhone14_Pro == YES || Is_iPhone14_ProMax == YES)

//弱引用
#define WEAKSELF typeof(self) __weak weakSelf = self;

//设置颜色
#define MYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define MYAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
// clear背景颜色
#define MYClearColor [UIColor clearColor]

#define ORANGE_COLOR [UIColor colorWithHexString:@"#FFC000"]
#define MAIN_COLOR [UIColor colorWithHexString:@"#FFC000"]

#define FontColor28 [UIColor colorWithHexString:@"#282828"]
#define FontColor66 [UIColor colorWithHexString:@"#666666"]
#define FontColor99 [UIColor colorWithHexString:@"#999999"]
#define FontColorDE [UIColor colorWithHexString:@"#DEDEDE"]
#define FontColorF6 [UIColor colorWithHexString:@"#F6F6F6"]
#define BackColor [UIColor colorWithHexString:@"#F5F6F8"]

//#define MYGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define MYGetImage(imageName) [YYToolModel loadImageWithImageName:imageName]


//打印
#ifdef DEBUG
#define MYLog(format, ...) printf("class: < %s:(%d行) > method: %s \n%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define MYLog(...)
#endif

//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#endif /* macro_h */

