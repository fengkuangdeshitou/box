//
//  DeviceInfo.h
//  Game789
//
//  Created by xinpenghui on 2017/9/10.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

+ (instancetype) shareInstance;

@property (nonatomic, copy) void(^getUDIDSuccessBlock)(NSString * udid);

/**  bunleId  */
@property (nonatomic, strong) NSString * bundleId;

/**  0 咪噜游戏 1 985手游 2 为游戏盒子 3 9917玩 4 AA玩   */
@property (nonatomic, copy) NSString * channelTag;
/**  0 非tf签名 1 tf签名   */
@property (nonatomic, assign) BOOL isTFSigin;
/**  TF签名一键登录的key，动态的   */
@property (nonatomic, copy) NSString * TFSiginVerifyKey;
@property (nonatomic, copy) NSString * getChannelData;
@property (nonatomic, strong) NSString *channel;
/** 获取包里面的游戏ID   */
@property (nonatomic, strong) NSString *myGameId;
/**  友盟广告统计  */
@property (nonatomic, strong) NSString *umchannel;
/**  友盟appkey  */
@property (nonatomic, strong) NSString *umAppkey;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *ffOpenUDID;
@property (nonatomic, strong) NSString *deviceUDID;
@property (nonatomic, strong) NSString *deviceIdfa;
@property (nonatomic, strong) NSString *deviceVersion;
@property (nonatomic, strong) NSString *deviceSize;
@property (nonatomic, strong) NSString *deviceModel;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *appDisplayVersion;
@property (nonatomic, strong) NSString *appDisplayName;
@property (nonatomic, strong) NSString *uastr;
/** 盒子的基本配置 */
@property (nonatomic, strong) NSDictionary *data;
/**  0 先下载再安装 1 在线安装  */
@property (nonatomic, assign) NSInteger downLoadStyle;
/**  当前网络状态 0 无网 1 蜂窝 2 WiFi -1 未知网络  */
@property (nonatomic, assign) NSInteger networkState;
/**  是否展示新的UI 0 展示默认 1 展示主题图片  */
@property (nonatomic, assign) NSInteger is_new_ui;
/**  是否关闭交易提交 0 默认正常交易 1 关闭交易  */
@property (nonatomic, assign) NSInteger is_close_trade;
/**  活动详情  */
@property (nonatomic, strong) NSDictionary * activityDic;
/** 是否为至尊版 */
@property (nonatomic, assign) BOOL isGameVip;
/** 是否打开平台介绍 */
@property (nonatomic, assign) BOOL isOpenIntro;
/** 平台介绍视频地址 */
@property (nonatomic, copy) NSString * intro_video_url;
/** 是否显示至尊版通道 */
@property (nonatomic, assign) BOOL isVipPassage;
/** 首页右下角活动图片 */
@property (nonatomic, copy) NSString * activity_img;
/** 是否点击游戏大厅，用来判断首页点击游戏类型的跳转判断 */
@property (nonatomic, assign) BOOL isClickGameHall;
/** 搜索框默认游戏名称 */
@property (nonatomic, copy) NSString * searchGameName;
/** 搜索框游戏名称列表 */
@property (nonatomic, copy) NSArray * homeSearchDefaultTitleList;
/** 月卡显示活动描述 */
@property (nonatomic, copy) NSString * monthCardDesc;
/** 是否开启视频的声音 */
@property (nonatomic, assign) BOOL isOpenVoice;
/** 首页新人福利活动倒计时 */
@property (nonatomic, assign) __block NSInteger timeout;
/** 新人福利地址 */
@property (nonatomic, copy) NSString *novice_fuli_v2101_url;
/** 新人福利按钮是否显示 */
@property (nonatomic, assign) NSInteger novice_fuli_v2101_show;
/** 新人过期时间 */
@property (nonatomic, assign) NSInteger novice_fuli_v2101_expire_time;
/** 新人8-30天 */
@property (nonatomic, assign) NSInteger novice_fuli_eight_time;
/** 新人30天 */
@property (nonatomic, assign) NSInteger novice_fuli_thirty_time;
/** 新人30天以上用户 活动地址 */
@property (nonatomic, copy) NSString * reg_gt_30day_url;
/** 是否在主页一级菜单加item */
@property (nonatomic, strong) NSArray * menu_items;
/** 是否开启青少年模式  */
@property (nonatomic, assign) BOOL isOpenYouthMode;
/** 获取udid的加载地址 */
@property (nonatomic, copy) NSString *getUdidUrl;
/** 获取点击vip下载的图片地址 */
@property (nonatomic, copy) NSString *getUdidAlert;
/** 获取购买后vip下载的图片地址 */
@property (nonatomic, copy) NSString *udidAlertBuy;
/** 云游戏地址 */
@property (nonatomic, copy) NSString *cloudappIndexUrl;
/** 云游戏检测 */
@property (nonatomic, copy) NSString *cloudappCheckAvailableUrl;
/** 百度token */
@property (nonatomic, copy) NSString *tk;
/** 百度落地页地址 */
@property (nonatomic, copy) NSString *tk_url;

/**true:支付需要实名验证 , false : 不需要*/
@property (nonatomic, assign) BOOL isCheckAuth;
/**单独控制未成年 开关*/
@property (nonatomic, assign) BOOL isCheckAdult;

@property (nonatomic, assign) float folderSizes;
/** 交易精选  顶部图片 */
@property (nonatomic, copy)NSString * trade_goods_cover;
/** 导航配置 */
@property (nonatomic, strong) NSArray * navList;
/** 是否包含当前渠道，下载前跳转到登录 */
@property (nonatomic, assign) BOOL isContainAgent;
/** 至尊版的有效期 */
@property (nonatomic, copy)NSString * vipsignLifeTimeDesc;
/** 获取百度ocpc/搜狗 vid */
@property (nonatomic, copy)NSString * bdvid;
/** 获取当前自定义渠道包的标识 */
@property (nonatomic, copy)NSString * boxBranch;
/** 实名认证 */
@property (nonatomic, copy)NSString * authBottomTips;
/** U-link 有弹窗 */
@property (nonatomic, assign) BOOL isULink;
/** 实名认证弹窗上面的  */
@property (nonatomic, copy) NSString * authConfirmTopTips;
/** 名认证弹窗底部 */
@property (nonatomic, copy) NSString * authConfirmBottomTips;
@property (nonatomic, copy) NSString * vip_desc;
@property (nonatomic, copy) NSString * month_card_desc;

- (NSString *)getFileContent:(NSString *)fileName;

@end
