//
//  YYToolModel.h
//  Game789
//
//  Created by Maiyou on 2018/8/6.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "YCDownloadItem.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>

#define LAST_RUN_VERSION_KEY @"last_run_version_of_application"

@interface YYToolModel : NSObject

// 超级签名的游戏下载地址
@property (nonatomic, copy) void(^VipDownUrl)(NSInteger code, NSString *url);

//添加客服悬浮按钮
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) UIButton *spButton;

+ (instancetype) shareInstance;

/**  是否为第一次加载  */
+ (BOOL) isFirstLoad;

/**  获取个人信息  */
+ (void)getUserInfoApiRequest:(void(^)(NSDictionary * dic))respondData;

/**  设置tabbar为跟视图控制器  */
+ (void)initTabbarRootVC;

+ (UIViewController *)getCurrentVC;

/**  设置渐变色  */
+ (void)setGradientColor:(UIView *)view CornerRadius:(CGFloat)radius ColorArray:(NSArray *)colorArray;

/**  是否登陆  */
+ (BOOL)islogin;
/**  是否已经登录，内部已经判断没有登录跳转到登录页面  */
+ (BOOL)isAlreadyLogin;

/**  获取分享的icon名字  */
+ (NSString *)getShareIconName;
/** 本地存储 */
+ (void)saveUserdefultValue:(id)value forKey:(NSString *)fileName;
/** 本地取值 */
+(id)getUserdefultforKey:(NSString *)fileName;
/** 本地删除 */
+(void)deleteUserdefultforKey:(NSString *)fileName;

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGSize)sizeWithText:(NSString *)text size:(CGSize)size font:(UIFont *)font;

/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
/**
 *  通过 Quartz 2D 在 UIImageView 绘制虚线
 *
 *  param imageView 传入要绘制成虚线的imageView
 *  return
 */

+ (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView;

/**
 判断字符是否为空

 @param aStr string
 @return YES 空 NO 非空
 */
+ (BOOL)isBlankString:(NSString *)aStr;

/**
 判断图片网络地址的图片类型

 @param path 地址路径
 @return 返回图片后缀
 */
+ (NSString *)contentTypeForImageData:(NSString *)path;


/**
 通过 bundle identifier 跳转到其他App

 @param bundleId bundleid
 @return 是否可以跳转
 */
+ (BOOL)openApp:(NSString *)bundleId;

/**
 通过 bundle identifier 判断手机上是否安装了该应用

 @param BundleID bundleid
 @param isList 1 列表显示 0 ios12下已安装直接打开
 @return 是否安装
 */
+ (BOOL)isInstalled:(NSString *)BundleID IsList:(BOOL)isList;

/**
 获取ipa下载的状态

 @param item YCDownloadItem
 @return 返回显示的状态
 */
+ (NSString *)getIpaDownloadStatus:(YCDownloadItem *)item;

/**
 安装ipa

 @param item YCDownloadItem
 */
+ (void)installAppForItem:(YCDownloadItem *)item;

/**
 获取下载ipa包的url

 @param str 下载地址
 @param dic 该游戏数据
 @param vc 当前显示控制器
 @param isPackage 是否为分包后的刷新
 */
+ (void)getIpaDownloadUrl:(NSString *)str Data:(NSDictionary *)dic Vc:(UIViewController *)vc IsPackage:(BOOL)isPackage;

/**
 加载ipa.plist

 @param vc 当前控制器
 @param url url
 */
+ (void)loadIpaUrl:(UIViewController *)vc Url:(NSString *)url;

/**
 请求头添加参数

 @param request 要添加的request
 @return 返回request
 */

+ (NSMutableURLRequest *)requestHeaderAddParas:(NSURLRequest *)request;

/**
 超级签名下载方式

 type 1、默认下载方式；2、通过safari打开vip_ios_url；3、内部下载安装游戏（个人签名版）
 @param parmaDic @{@"maiyou_gameid":@"", @"down_type":@"", @"vip_ios_url":@""}
 
 @return 返回是否为个签
 */
- (BOOL)vipDownloadGame:(NSDictionary *)parmaDic;

- (void)loadingView:(NSDictionary *)parmaDic;

/**  多种跳转类型  */
+ (void)pushVcForType:(NSString *)type Value:(NSString *)value Vc:(UIViewController *)vc;

//添加客服悬浮窗
- (void)initAddEventBtn:(UIViewController *)vc Top:(CGFloat)top;

/**  接口请求md5加密  */
+ (NSString *)md5EncryptionForRequest:(NSString *)timestamp;

/**
将gif图分解为图片

@return 图片数组
*/
+ (NSArray *)gifChangeToImages:(NSString *)fileName;

/** 获取相册的权限状态   */
+ (void)getLibraryAuthorizationStatus;

- (void)showUIFortype:(NSString *)string Parmas:(NSString *)exts;

+ (NSDictionary *)getParamsWithUrlString:(NSURL *)url;
//是否为iPad
+ (BOOL)getIsIpad;

- (void)getMiluVipCions;

+ (NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;

//解密
+ (NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;

+ (void)clipRectCorner:(UIRectCorner)corner radius:(CGFloat)radius view:(UIView *)view;

+ (void)saveHeight:(CGFloat)cellHeight forKey:(NSString *)key;

+ (CGFloat)getHomeCellForKey:(NSString *)key;

+ (NSArray *)replaceArray;

+ (UIImage *)loadImageWithImageName:(NSString *)name;

/** 保存缓存数据 */
+ (void)saveCacheData:(id)data forKey:(NSString *)key;

/** 获取缓存数据 */
+ (id)getCacheData:(NSString *)key;

@end
