//
//  AppDelegate+AppService.h
//  Game789
//
//  Created by Maiyou on 2019/4/24.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (AppService)

/**  获取广告追踪权限  */
- (void)requestTrackingAuthorization;
/**  热更新  */
- (void)initJspatch;
/**  友盟统计  */
- (void)configUM;
/**  分享  */
- (void)setShareAppKey;
/**  键盘  */
- (void)initKeyBoardManager;
/**  网络监控  */
- (void)networkState;
/**  下载管理  */
- (void)setUpDownload:(UIApplication *)application;
/**  获取活动信息  */
- (void)getActivityInfo;
/**  sdk跳转到盒子打开相应的界面  */
- (void)SDKToAppOpenUrl:(NSURL *)url;
/**  小视频  */
- (void)initGameVideo;
/**  上传激活的数据  */
- (void)uploadActivationData;
/**  初始化ocpcSDK  */
- (void)initOcpcSdk;

@end

NS_ASSUME_NONNULL_END
