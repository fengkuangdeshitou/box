//
//  MyHomeGameListController.m
//  Game789
//
//  Created by Maiyou on 2020/7/27.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyHomeGameListController.h"
#import "MyProjectGameController.h"
#import "MyGamePreviewController.h"
#import "MyNewGamesListController.h"
#import "MyNewGameStartingController.h"
#import "UserPayGoldViewController.h"
#import "MyUserReturnController.h"
#import "MyChatViewController.h"

#import "ExternalAlertView.h"
#import "HGHomeScrollHeaderView.h"
#import "HGFindRecommendGamesCell.h"
#import "HGHomeHotGamesCell.h"
#import "HGHomeGameProjectCell.h"
#import "MyActivityBunnerCell.h"
#import "MyGameRecommendCell.h"
#import "HGHomeProjectGamesCell.h"
#import "SendFirstChargeCoverView.h"
#import "MyOpeningNoticeView.h"
#import "MyDismissOperationView.h"
#import "HGLoadDataFooterView.h"
#import "MyHomeVideoListCell.h"
#import "MyNewHomeHotGameListCell.h"
#import "StepMaskGuideView.h"
#import "MyUserAgreementView.h"
#import "MyTwoActivityItemsCell.h"

#import "MyHomeGameListApi.h"
#import "HomeOpenNoticeApi.h"
#import "GetUnreadMgsApi.h"
#import <UMLink/MobClickLink.h>
#import "HomeRecentlyPlayCell.h"
#import "HomeProjectMediaCell.h"
#import "NewExclusiveViewController.h"
#import "InternalTestingViewController.h"
#import "HomeAlertImageView.h"

@import CoreTelephony;
@class MyPromotionActivationApi;

#define Activity_Save_Id [NSString stringWithFormat:@"Activity%@%@", [NSDate getNowTimeTimestamp:@"YYYYMMdd"], [YYToolModel getUserdefultforKey:USERID]]
#define FirstCharge_Save_Id [NSString stringWithFormat:@"FirstCharge%@%@", [NSDate getNowTimeTimestamp:@"YYYYMMdd"], [YYToolModel getUserdefultforKey:USERID]]
#define Novice_Save_Id [NSString stringWithFormat:@"Novice%@%@", [NSDate getNowTimeTimestamp:@"YYYYMMdd"], [YYToolModel getUserdefultforKey:USERID]]
#define Notice_Save_Id [NSString stringWithFormat:@"Notice%@%@", [NSDate getNowTimeTimestamp:@"YYYYMMdd"], [YYToolModel getUserdefultforKey:USERID]]

#define ShowNoticeTag      @"ShowNoticeTag"
#define ShowActivityTag    @"ShowActivityTag"
#define ShowFirstChargeTag @"ShowFirstChargeTag"
#define ShowNoviceTag      @"ShowNoviceTag"

@interface MyHomeGameListController ()<UITableViewDelegate, UITableViewDataSource>
{
    dispatch_source_t _timer;
}
@property (nonatomic, strong) HGHomeScrollHeaderView *headerView;
//首页数据
@property (nonatomic, strong) NSDictionary * dataDic;
//通知数据
@property (nonatomic, strong) NSDictionary * noticeDic;
@property (nonatomic, assign) BOOL isLoadNotice;
@property (nonatomic, strong) NSMutableArray * dataArray;
//签到MyHomeGameListController
@property (strong, nonatomic) UIButton * signBtn;
@property (strong, nonatomic) UIButton * welfareBtn;
@property (strong, nonatomic) UILabel * welfareLabel;
/**  是否完成新手任务  */
@property (nonatomic, assign) BOOL isFinish;
/**  是否登录后后刷新数据  */
@property (nonatomic, assign) BOOL isLoginRefresh;
/** 用来记录是否滚动了一级菜单 */
@property (nonatomic, assign) BOOL isScroll;
@property (strong, nonatomic) HomeAlertImageView * img;
@property (strong, nonatomic) NSDictionary * popularGame;
@end

@implementation MyHomeGameListController

- (HomeAlertImageView *)img{
    if(!_img){
        _img = [[HomeAlertImageView alloc] initWithFrame:CGRectZero];
    }
    return _img;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self SignIn];
    
    [self homeViewOpen];
    //获取盒子的配置
    [self getTopButtonCount];

    [self loadData];
    
    //先加载缓存的数据
    NSData * homeData = [YYToolModel getUserdefultforKey:MiluHomeDataCache];
    BOOL isShow = YES;
    if (homeData != NULL)
    {
        @try {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:homeData options:NSJSONReadingMutableContainers error:nil];
            [self parmasHomeData:dic];
            isShow = NO;
        } @catch (NSException *exception) {
            [YYToolModel deleteUserdefultforKey:MiluHomeDataCache];
        } @finally {
            
        }
    }
    [self getHomeData:^(BOOL isSuccess) {
    } isHud:isShow];
    [self getHomeNoticeRequest];
//    [self getUserInfo];
}

/// 首次安装进入活动
- (void)loadFristLinkUrl
{
    [MobClickLink getInstallParams:^(NSDictionary *params, NSURL *URL, NSError *error) {
        NSDictionary * dictionary = [YYToolModel getParamsWithUrlString:URL];
        NSLog(@"UMLinkFlagUrl=%@,params=%@",URL,dictionary);
        if (![YYToolModel getUserdefultforKey:@"UMLinkFlag"]) {
            if ([dictionary objectForKey:@"b"]) {
                [DeviceInfo shareInstance].isULink = YES;
                NSString * gameId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"b"]];
                if (gameId.length > 0) {
                    ExternalAlertView * view = [ExternalAlertView createViewFromNib];
                    view.b = gameId;
                    if ([dictionary objectForKey:@"c"]) {
                        view.c = dictionary[@"c"];
                    }
                    [view showAnimationWithSpace:70];
                }
            }else if ([dictionary objectForKey:@"zt"]) {
                [DeviceInfo shareInstance].isULink = YES;
                ExternalAlertView * view = [ExternalAlertView createViewFromNib];
                view.zt = dictionary[@"zt"];
                view.zu = dictionary[@"zu"];
                [view showAnimationWithSpace:70];
            }
        }
        //保存渠道
        if ([dictionary objectForKey:@"a"])
        {
            [YYToolModel saveUserdefultValue:dictionary[@"a"] forKey:@"UMLinkGetAgent"];
        }
        //百度投放token
        if ([dictionary objectForKey:@"tk"] || [dictionary objectForKey:@"tk01"])
        {
            [DeviceInfo shareInstance].tk_url = dictionary[@"tk01"]?:@"";
            [DeviceInfo shareInstance].tk = dictionary[@"tk"]?:@"";
            [self tkrequest];
        }
    }];
}
     
- (void)tkrequest{
    TKApi * api = [[TKApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
                
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

/// 获取网络权限
/// @param completion 权限
- (void)getNetworkPermissionsCompletion:(void(^)(CTCellularDataRestrictedState state))completion{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(state);
            });
        });
    };
}

- (void)homeViewOpen
{
    //是否完成了首冲任务
//    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
//    (dic != NULL) ? (self.isFinish = [dic[@"is_finish_newtask"] boolValue]) : (self.isFinish = YES);
    BOOL isActivity = [[YYToolModel getUserdefultforKey:IS_ACTIVITY] boolValue];
//    if (!isActivity && self.isFinish)
//    {
//        self.signBtn.hidden = YES;
//        [self.signBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0);
//        }];
//    }
//    else
    if (isActivity)
    {
        self.signBtn.hidden = NO;
        [self.signBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
        }];
    }
    
    //新人福利
//    [self getNoviceStatus:dic];
    
    //是否登录后是新用户需要弹出新人福利弹窗
//    if (self.isLoginRefresh && [self isNewUser])
//    {
//        [self getHomeNoticeRequest];
//    }
    
    //是否显示一级菜单的item
//    if ([YYToolModel getUserdefultforKey:@"myShowSectionItem"] == NULL)
//    {
//        [YYToolModel saveUserdefultValue:@"1" forKey:@"myShowSectionItem"];
//        [self showSectionViewItem];
//    }
    
    [self showAllAlertView];
}

//获取新手福利状态
- (void)getNoviceStatus:(NSDictionary *)dic
{
    //是否显示新手福利
    BOOL isShow = [self isNewUser];
    self.welfareBtn.hidden = !isShow;
    MYLog(@"====%ld", (long)[DeviceInfo shareInstance].novice_fuli_v2101_expire_time);
    if (isShow)
    {
        if ([DeviceInfo shareInstance].novice_fuli_v2101_show == 1 && [DeviceInfo shareInstance].novice_fuli_v2101_expire_time == 0)
        {//新版新人福利
            if (_timer)
            {
                dispatch_source_cancel(_timer);
                _timer = nil;
            }
            self.welfareLabel.text = @"";
        }
        else if ([dic[@"is_show_reg_gt_30day"] intValue] == 1)
        {
            NSString * gifPathSource = [[NSBundle mainBundle] pathForResource:@"home_novice_benefits2" ofType:@"gif"];
            [self.welfareBtn sd_setImageWithURL:[NSURL fileURLWithPath:gifPathSource] forState:UIControlStateNormal];
            self.welfareLabel.text = @"";
        }
        else
        {
            __weak __typeof(self) weakSelf = self;
            if (_timer == nil) {
                if ([DeviceInfo shareInstance].timeout != 0) {
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
                    dispatch_source_set_event_handler(_timer, ^{
                        if([DeviceInfo shareInstance].timeout <= 0){ //  当倒计时结束时做需要的操作: 关闭 活动到期不能提交
                            dispatch_source_cancel(_timer);
                            _timer = nil;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                weakSelf.welfareLabel.text = @"";
//                                [weakSelf.welfareBtn setBackgroundImage:MYGetImage(@"home_novice_benefits") forState:0];
                                NSString * gifPathSource = [[NSBundle mainBundle] pathForResource:@"home_novice_benefits1" ofType:@"gif"];
                                [weakSelf.welfareBtn sd_setImageWithURL:[NSURL fileURLWithPath:gifPathSource] forState:UIControlStateNormal];
                            });
                        } else { // 倒计时重新计算 时/分/秒
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSString * gifPathSource = [[NSBundle mainBundle] pathForResource:@"home_novice_benefits" ofType:@"gif"];
                                [weakSelf.welfareBtn sd_setImageWithURL:[NSURL fileURLWithPath:gifPathSource] forState:UIControlStateNormal];
//                                [weakSelf.welfareBtn setBackgroundImage:MYGetImage(@"home_novice_benefits") forState:0];
                            });
                            NSInteger days = (int)([DeviceInfo shareInstance].timeout/(3600*24));
                            NSInteger hours = (int)(([DeviceInfo shareInstance].timeout-days*24*3600)/3600);
                            NSInteger minute = (int)([DeviceInfo shareInstance].timeout-days*24*3600-hours*3600)/60;
                            NSInteger second = [DeviceInfo shareInstance].timeout - days*24*3600 - hours*3600 - minute*60;
                            NSString *strTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minute, second];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (days == 0) {
                                    weakSelf.welfareLabel.text = strTime;
                                } else {
                                    weakSelf.welfareLabel.text = [NSString stringWithFormat:@"%ld天%02ld:%02ld", days, hours, minute];
                                }
                            });
                            [DeviceInfo shareInstance].timeout--; // 递减 倒计时-1(总时间以秒来计算)
                        }
                    });
                    dispatch_resume(_timer);
                }
            }
        }
    }
}

- (void)prepareBasic
{
    self.navBar.hidden = YES;
    self.view.backgroundColor = BackColor;
    self.tableView.hidden = YES;
    
    //闪屏广告点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickLanchView:) name:@"kImageViewPress" object:nil];
    //登录或者注册成功回传
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginReloadData) name:@"loginReloadUrl" object:nil];
    //首次安装活动跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFristLinkUrl) name:@"firstInstallPushNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:kLoginExitNotice object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.popularGame = nil;
        [self.img removeFromSuperview];
        self.img = nil;
        if (self.dataArray.count > 0) {
            if (self.dataArray.firstObject[@"popularGame"])
            {
                [self.dataArray removeObjectAtIndex:0];
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getHomeNoticeRequest];
        });
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if ([[YYToolModel getCurrentVC] isKindOfClass:NSClassFromString(@"MyHomeSubsectionController")]){
            [self showAllAlertView];
        }
    }];
    [[DeviceInfo shareInstance] addObserver:self forKeyPath:@"novice_fuli_v2101_show" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[DeviceInfo shareInstance] addObserver:self forKeyPath:@"menu_items" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[DeviceInfo shareInstance] addObserver:self forKeyPath:@"networkState" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"novice_fuli_v2101_show"])
    {
        //新人福利
//        NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
//        [self getNoviceStatus:dic];
    }
//    else if ([keyPath isEqualToString:@"menu_items"])
//    {
//        [self showSectionViewItem];
//    }
    else if ([keyPath isEqualToString:@"networkState"])
    {
        if (self.tableView.hidden)//数据没有加载处理的话，网络变化刷新首页接口
        {
            [self loadFristLinkUrl];
        }
    }
}

#pragma mark ——— 是否显示一级菜单添加的item
- (void)showSectionViewItem
{
    NSArray * items = [DeviceInfo shareInstance].menu_items;
    if (items.count == 0) return;
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.headerView.sectionTitleArray];
    for (int i = 0; i < items.count; i ++)
    {
        NSDictionary * dic = items[i];
        if ([dic[@"is_show"] boolValue])
        {
            NSDictionary * data = @{@"title":dic[@"title"],
            @"image":[NSString stringWithFormat:@"home_section_item_icon%@", dic[@"index"]],
            @"vc":@"project_id",
            @"aop":[NSString stringWithFormat:@"click_home_section_item%d", 1+i],
            @"id":dic[@"id"]};
            if (![array containsObject:data])
            {
                [array insertObject:data atIndex:1+i];
            }
        }
    }
    self.headerView.sectionTitleArray = array;
    [self.headerView.collectionView reloadData];
}

#pragma mark ——— 登录或者注册刷新相关数据
- (void)loginReloadData
{
//    self.isLoginRefresh = [DeviceInfo shareInstance].novice_fuli_v2101_show;
    WEAKSELF
    //刷新首页一级菜单新人和回归任务
    [self getHomeData:^(BOOL isSuccess) {
        [weakSelf getHomeNoticeRequest];
    } isHud:NO];
}

#pragma mark ——— 闪屏广告点击事件
- (void)clickLanchView:(NSNotification *)not
{
    NSDictionary *dic = [not object];
    
    [YYToolModel pushVcForType:dic[@"link_route"] Value:dic[@"link_value"] Vc:self];
}

#pragma mark 签到(判断是否签到)
- (void)SignIn
{
    self.signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_width - 70, kScreen_height - 60 - kTabbarHeight - 10, 60, 60)];
    self.signBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.signBtn addTarget:self action:@selector(signMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.signBtn aboveSubview:self.tableView];
    
    [self.signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
//    UIButton * welfareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    welfareBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreen_width - 70, self.signBtn.top - 80, 70, 70)];
//    welfareBtn.contentMode = UIViewContentModeScaleAspectFit;
//    [welfareBtn addTarget:self action:@selector(noviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
////    [welfareBtn setBackgroundImage:MYGetImage(@"home_novice_benefits") forState:0];
//    NSString * gifPathSource = [[NSBundle mainBundle] pathForResource:@"home_novice_benefits" ofType:@"gif"];
//    [self.welfareBtn sd_setImageWithURL:[NSURL fileURLWithPath:gifPathSource] forState:UIControlStateNormal];
//    welfareBtn.hidden = ![self isNewUser];
//    [self.view insertSubview:welfareBtn aboveSubview:self.tableView];
//    self.welfareBtn = welfareBtn;
//
//    UILabel * welfareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, welfareBtn.height - 21, welfareBtn.width, 15)];
//    welfareLabel.textColor = [UIColor whiteColor];
//    welfareLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
//    welfareLabel.text = @"";
//    welfareLabel.textAlignment = NSTextAlignmentCenter;
//    [welfareBtn addSubview:welfareLabel];
//    self.welfareLabel = welfareLabel;
//
//    [self.welfareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.view.mas_right).offset(-10);
//        make.bottom.mas_equalTo(self.signBtn.mas_top).offset(-10);
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(60);
//    }];
//
//    [welfareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(welfareBtn.mas_right);
//        make.left.mas_equalTo(welfareBtn.mas_left);
//        make.bottom.mas_equalTo(welfareBtn.mas_bottom).offset(-6);
//        make.height.mas_equalTo(15);
//    }];
}

#pragma mark ——— 获取用户信息
- (void)getUserInfo
{
    [YYToolModel getUserInfoApiRequest:^(NSDictionary *dic) {
//        [self getNoviceStatus:dic];
        
//        if (DeviceInfo.shareInstance.novice_fuli_eight_time == 1)
//        {
//            [MyAOPManager relateStatistic:@"ShowFloatingWndowAds" Info:@{@"type":@"8"}];
//        }
//        else if ([DeviceInfo shareInstance].novice_fuli_v2101_show == 1)
//        {
//            [MyAOPManager relateStatistic:@"ShowFloatingWndowAds" Info:@{@"type":@"7"}];
//        }
    }];
}

#pragma mark ——— 是否为新用户领取新手福利
- (BOOL)isNewUser
{
    if ([YYToolModel islogin])
    {
        NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
        BOOL value = false;
        if (DeviceInfo.shareInstance.novice_fuli_eight_time == 1) {
            value = YES;
        }else if(DeviceInfo.shareInstance.novice_fuli_thirty_time == 1){
            value = YES;
        }else{
            value = [dic[@"novice_fuli_v2101_show"] boolValue];
        }
        return value;
    }
    else
    {
        return [DeviceInfo shareInstance].novice_fuli_v2101_show == 1;
    }
}

- (void)noviceBtnClick:(UIButton *)sender
{
    if (![YYToolModel isAlreadyLogin]) return;
    
    if (DeviceInfo.shareInstance.novice_fuli_thirty_time == 1)
    {
        [MyAOPManager relateStatistic:@"ClickFloatingWindowAd" Info:@{@"type":@"30"}];
        
        MyUserReturnController * vc = [MyUserReturnController new];
        vc.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:vc animated:YES];
    }
    else
    {
        NewExclusiveViewController * new = [[NewExclusiveViewController alloc] init];
        new.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:new animated:true];
    }
    
//    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
//    UserPayGoldViewController * pay = [[UserPayGoldViewController alloc] init];
//    if(DeviceInfo.shareInstance.novice_fuli_thirty_time == 1){
//        pay.reg_gt_30day_url = YES;
//        [MyAOPManager relateStatistic:@"ClickFloatingWindowAd" Info:@{@"type":@"30"}];
//    }else{
//        pay.isFullScreen = YES;
//        pay.isNewWelfare = [dic[@"novice_fuli_v2101_show"] boolValue] || [dic[@"is_show_reg_between_8day_30day"] boolValue];
//        [MyAOPManager relateStatistic:@"ClickFloatingWindowAd" Info:@{@"type":DeviceInfo.shareInstance.novice_fuli_eight_time == 1 ? @"8" : @"7"}];
//    }
//    pay.hidesBottomBarWhenPushed = YES;
//    [[YYToolModel getCurrentVC].navigationController pushViewController:pay animated:YES];
}

- (void)signMethod
{
    if (![YYToolModel isAlreadyLogin]) return;
    
    //是否在活动期间显示活动
    BOOL isActivity = [[YYToolModel getUserdefultforKey:IS_ACTIVITY] boolValue];
    if (isActivity)
    {
        //活动期间点击活动
        [MyAOPManager relateStatistic:@"ClickFloatingWindowAd" Info:@{@"type":@"huodong"}];
        [self firstChargeView:YES];
    }
    else
    {
//        if (self.isFinish)//是否已经完成首冲任务
//        {
//            [MyAOPManager relateStatistic:@"ClickFloatingWindowAd" Info:@{@"type":@"shouchong"}];
//            MyTaskViewController *coinsVC = [[MyTaskViewController alloc]init];
//            coinsVC.hidesBottomBarWhenPushed = YES;
//            coinsVC.isPush = YES;
//            [self.navigationController pushViewController:coinsVC animated:YES];
//        }
//        else
//        {
//            [self firstChargeView:NO];
//        }
    }
}

- (void)getHomeData:(RequestData)block isHud:(BOOL)isShow
{
    MyHomeGameListApi * api = [[MyHomeGameListApi alloc] init];
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            if (block) block(YES);
            [self parmasHomeData:request.data];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

- (void)parmasHomeData:(NSDictionary *)homeData
{
    //缓存当前数据
    [YYToolModel saveCacheData:homeData forKey:MiluHomeDataCache];

    if (self.dataArray)
    {
//        NSString * str = [self.dataDic[@"ab_test_stage"] integerValue] == 1 ? self.dataDic[@"ab_test_index_swiper"] : self.dataDic[@"ab_test_index_first_publish"];
//        NSDictionary * dic = @{@"ab_test1":[NSString stringWithFormat:@"%@", str]};
        //统计进入首页
//        [MyAOPManager relateStatistic:@"HomeViewAppear" Info:[self.dataDic[@"is_985"] boolValue] ? dic : @{}];
    }
    else
    {
        //当第一次加的时候，上传推广激活数据
        [self uploadPromotionData];
    }
    self.tableView.hidden = NO;
    self.topBackView.hidden = NO;
    self.dataDic = homeData;
    NSArray * array = [homeData[@"list"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[NSNumber numberWithInteger:[obj1[@"sort"] integerValue]] compare:[NSNumber numberWithInteger:[obj2[@"sort"] integerValue]]];
    }];
    self.dataArray = [NSMutableArray arrayWithArray:array];
    //将重磅推荐加入列表
    if (self.popularGame)
    {
        NSDictionary * dic = @{@"title":@"", @"tag":@"popularGame", @"popularGame":self.popularGame, @"sort":@"0"};
        self.dataArray.count > 0 ? [self.dataArray insertObject:dic atIndex:0] : [self.dataArray addObject:dic];
    }
    self.headerView.dataDic = self.dataDic;
    NSDictionary * dic = self.dataDic[@"swiper_920"][0];
    UIColor * color = [UIColor colorWithHexString:dic[@"color"]];
    self.topBackView.backgroundColor = color;
    
    HGLoadDataFooterView * footerView = (HGLoadDataFooterView *)[self creatFooterView];
    footerView.backgroundColor = BackColor;
    footerView.showText.text = @"更多游戏请到发现中查看";
    self.tableView.tableFooterView = footerView;
    [self.tableView reloadData];

    //获取开屏通知,每次进也没只请求一次
//    if (!self.isLoadNotice)
//    {
//        self.isLoadNotice = YES;
//        [self getHomeNoticeRequest];
//    }
    [self scrollSctionItem];
}

#pragma mark ——— 滚动一级菜单和处理启动图片的移除
- (void)scrollSctionItem
{
    NSString * userCenter = [YYToolModel getUserdefultforKey:@"HomeGuidePageView"];
    if (userCenter != NULL)
    {
        UIView * view = [UIApplication sharedApplication].delegate.window;
        UIImageView * imageView = [view viewWithTag:8888];
        if (imageView)
        {
            [UIView transitionWithView:view duration:0.8 options:UIViewAnimationOptionTransitionNone animations:^{
                imageView.alpha = 0;
            } completion:^(BOOL finished) {
                [imageView removeFromSuperview];
            }];
        }
    }
    if (!self.isScroll)
    {
        if (self.headerView.sectionTitleArray.count == 0) {
            return;
        }
        self.isScroll = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 animations:^{
                [self.headerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.headerView.sectionTitleArray.count>6?6:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.8 animations:^{
                    [self.headerView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
                } completion:^(BOOL finished) {
                    self.headerView.isScroll = YES;
                }];
            }];
        });
    }
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kTabbarHeight - kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView.userInteractionEnabled = YES;
        _tableView.tableHeaderView = self.headerView;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"MyNewHomeHotGameListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyNewHomeHotGameListCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HGFindRecommendGamesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HGFindRecommendGamesCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MyHomeVideoListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"VideoListCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MyHomeVideoListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ReserveListCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HGHomeHotGamesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HGHomeHotGamesCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HGHomeGameProjectCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HGHomeGameProjectCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MyGameRecommendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyGameRecommendCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HGHomeProjectGamesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HGHomeProjectGamesCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MyTwoActivityItemsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyTwoActivityItemsCell"];
        [_tableView registerClass:[MyActivityBunnerCell class] forCellReuseIdentifier:@"MyActivityBunnerCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HomeRecentlyPlayCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeRecentlyPlayCell"];
    }
    return _tableView;
}

#pragma mark - 懒加载

- (HGHomeScrollHeaderView *)headerView
{
    if (!_headerView)
    {
//        kStatusBarAndNavigationBarHeight + kScreenW/(375-30)*320 + 93 + 10
        _headerView = [[HGHomeScrollHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 920 / 750 + 17)];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

- (UIView *)topBackView
{
    if (!_topBackView)
    {
        _topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kStatusBarAndNavigationBarHeight + 120)];
        [self.view insertSubview:_topBackView atIndex:0];
    }
    return _topBackView;
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary * dic = self.dataArray[section];
    NSString * type = dic[@"tag"];
    NSString * key = [NSString stringWithFormat:@"%@list", type];
    NSArray * array = dic[key];
    
    if ([type isEqualToString:@"hotCategory"] || [type isEqualToString:@"recentlyPlayGame"] || [type isEqualToString:@"startingGames"]){
        return 0.0001;
    }
    NSDictionary * bannerDic = self.popularGame;
    if (section == 1 && [bannerDic[@"activity_top"] count] == 0 && [bannerDic[@"recommend_top"] isKindOfClass:[NSNull class]]) {
        return 8;
    }
    else if (array.count == 0) {
        return 0.001;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArray[indexPath.section];
    NSString * type = dic[@"tag"];
    NSString * key = [NSString stringWithFormat:@"%@list", type];
    NSArray * array = dic[key];
    if ([type isEqualToString:@"popularGame"])
    {
        NSDictionary * bannerDic = self.popularGame;
        if (!bannerDic)
        {
            return 0;
        }
        else
        {
            if ([bannerDic[@"activity_top"] count] == 0 && [bannerDic[@"recommend_top"] isKindOfClass:[NSNull class]])
            {
                return 0;
            }
            else if ([bannerDic[@"activity_top"] count] > 0)
            {
                return (kScreenW - 30) * 170 / 690 + 10;
            }
            else if ([bannerDic[@"recommend_top"] isKindOfClass:[NSDictionary class]] && [bannerDic[@"recommend_top"] count] > 0)
            {
                return 100;
            }
        }
        return 0;
    }
    else if ([type isEqualToString:@"recommendGames"])
    {
        return array.count > 0 ? 198 : 0;
    }
    else if ([type isEqualToString:@"hotGames"])
    {
        if ([self.dataDic[@"ab_test_index_swiper"] integerValue] == 1)
        {
            return array.count > 0 ? 326 + 20 : 0;
        }
        else
        {
            NSString * heightKey = [NSString stringWithFormat:@"%@",dic[@"tips"]];
//            return array.count == 0 ? 0 : ([NSUserDefaults.standardUserDefaults objectForKey:heightKey] ? [[NSUserDefaults.standardUserDefaults objectForKey:heightKey] floatValue] + 72 : 600);
            return array.count == 0 ? 0 : ([YYToolModel getHomeCellForKey:heightKey] > 0 ? [YYToolModel getHomeCellForKey:heightKey] + 72 : 600);
        }
    }
    else if ([type isEqualToString:@"projectGames"])
    {
        int outstyle = [dic[@"outstyle"] intValue];
        if (outstyle == 1) {
            return array.count > 0 ? (kScreenW - 30) * 180 / 345 + 87 : 0;
        }else if(outstyle == 2){
            return array.count > 0 ? 198 : 0;
        }else if(outstyle == 3){
            return array.count > 0 ? (ScreenWidth-56)*9/16+110+43 : 0;
        }
    }
    else if ([type isEqualToString:@"startingGames"])
    {
//        if (array.count == 0 || [self.dataDic[@"ab_test_index_first_publish"] integerValue] == 2)
//        {
//            return 0;
//        }
//        else
//        {
//            return 246;
//        }
        return 0.001;
    }
    else if ([type isEqualToString:@"videoList"] || [type isEqualToString:@"reserverGames"])
    {
        CGFloat viewWidth = kScreenW - 15 * 2 - 13 * 2 - 42;
        return array.count > 0 ? (viewWidth * 9 / 16) + 74 + 53 : 0;
    }
    else if ([type isEqualToString:@"diycategory"])
    {
        return array.count > 0 ? 295 + 38 : 0;
    }
    else if ([type isEqualToString:@"hotCategory"])
    {
        return array.count > 0 ? 150 : 0;
    }
//    else if ([type isEqualToString:@"youLikeGames"])
//    {
//        CGFloat cellWidth = (kScreenW - 2 * 10 - 15 * 2) / 3;
//        return array.count > 0 ?  cellWidth * 158.5 / 108 + 66 : 0;
//    }
//    else if ([type isEqualToString:@"imagejump"])
//    {
//        BOOL isShow = [dic[@"is_show"] boolValue];
//        return isShow ? (kScreenW - 40) / 2 * 90.0 / 167.5 + 25 : 0;
//    }
//    else if ([type isEqualToString:@"recentlyPlayGame"])
//    {
//        CGFloat cellHeight = (ScreenWidth-30-40-26)/5;
//        return cellHeight + 20 + 20;
//    }
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArray[indexPath.section];
    NSString * type = dic[@"tag"];
//    NSLog(@"tag=%@,outstyle=%d",type,[dic[@"outstyle"] intValue]);
    NSString * key = [NSString stringWithFormat:@"%@list", type];
    NSArray * array = dic[key];
    NSString * title_image = dic[@"title_image"];
    
    if ([type isEqualToString:@"popularGame"])
    {
        NSDictionary * bannerDic = self.popularGame;
        if (bannerDic)
        {
            if ([bannerDic[@"recommend_top"] isKindOfClass:[NSDictionary class]] && [bannerDic[@"recommend_top"] count] > 0)
            {
                static NSString *reuseID = @"MyGameRecommendCell";
                MyGameRecommendCell * cells = [tableView dequeueReusableCellWithIdentifier:reuseID];
                cells.dataDic = bannerDic[@"recommend_top"];
                cells.selectionStyle = UITableViewCellSelectionStyleNone;
                return cells;
            }
            else if([bannerDic[@"activity_top"] count] > 0)
            {
                static NSString *reuseID = @"MyActivityBunnerCell";
                MyActivityBunnerCell * cells = [tableView dequeueReusableCellWithIdentifier:reuseID];
                cells.dataArray = bannerDic[@"activity_top"];
                cells.selectionStyle = UITableViewCellSelectionStyleNone;
                cells.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
                return cells;
            }
        }
    }
    else if ([type isEqualToString:@"recommendGames"])
    {
        static NSString *reuseID = @"HGFindRecommendGamesCell";
        HGFindRecommendGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.currentVC = self;
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:title_image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                cell.showImageViewWidthConstraint.constant = image.size.width*18/image.size.height;
            }
        }];
        cell.hidden = [array count] > 0 ? NO : YES;
        cell.dataArray = array;
        cell.more.hidden = YES;
        return cell;
    }
    else if ([type isEqualToString:@"hotGames"])
    {
        static NSString *reuseID = @"HGHomeHotGamesCell";
        HGHomeHotGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.currentVC = self;
        cell.is_985 = [self.dataDic[@"is_985"] boolValue];
        cell.ab_test_index_swiper = [self.dataDic[@"ab_test_index_swiper"] integerValue];
        cell.type = @"hot";
//        cell.source = @"home";
        cell.UpdateRelatedGames = ^{
            [UIView performWithoutAnimation:^{
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
        };
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:title_image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                cell.showImageViewWidthConstraint.constant = image.size.width*18/image.size.height;
            }
        }];
        cell.showTitle.text = dic[@"tips"];
        cell.hidden = [array count] > 0 ? NO : YES;
        cell.dataArray = array;
        return cell;
    }
    else if ([type isEqualToString:@"projectGames"])
    {
        int outstyle = [dic[@"outstyle"] intValue];
        if (outstyle == 1) {
            static NSString *reuseID = @"HGHomeGameProjectCell";
            HGHomeGameProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            cell.dataDic = dic;
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:title_image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    cell.titleImageWidthConstraint.constant = image.size.width*18/image.size.height;
                }
            }];
            cell.more.hidden = false;
            return cell;
        }else if (outstyle == 2){
            static NSString *reuseID = @"HGFindRecommendGamesCell";
            HGFindRecommendGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            cell.currentVC = self;
            [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:title_image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    cell.showImageViewWidthConstraint.constant = image.size.width*18/image.size.height;
                }
            }];
            cell.hidden = [array count] > 0 ? NO : YES;
            cell.dataArray = array;
            cell.more.hidden = false;
            return cell;
        }else if(outstyle == 3){
            static NSString * identifier = @"HomeProjectMediaCell";
            HomeProjectMediaCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[NSBundle mainBundle] loadNibNamed:@"HomeProjectMediaCell" owner:self options:nil].firstObject;
            }
            NSDictionary * data = dic[@"game_info"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.descLabel.text = dic[@"tips"];
            cell.descLabel.numberOfLines = 1;
            [cell.gameIcon sd_setImageWithURL:[NSURL URLWithString:dic[@"top_image"]] placeholderImage:MYGetImage(@"banner_photo")];
            cell.playButton.hidden = YES;
            
            [cell.gameCell setModelDic:data];
            [YYToolModel clipRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight radius:13 view:cell.gameCell.radiusView];
            [YYToolModel clipRectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:13 view:cell.radiusView];
            return cell;
        }
    }
//    else if ([type isEqualToString:@"startingGames"])
//    {
//        static NSString *reuseID = @"HGHomeHotGamesCell";
//        HGHomeHotGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
//        cell.currentVC = self;
//        cell.type = @"starting";
//        cell.showTitle.text = title;
//        cell.hidden = (array.count == 0 || [self.dataDic[@"ab_test_index_first_publish"] integerValue] == 2) ? YES : NO;
//        cell.dataArray = array;
//        cell.hidden = YES;
//        return cell;
//    }
//    else if ([type isEqualToString:@"youLikeGames"])
//    {
//        static NSString *reuseID = @"HGHomeHotGamesCell";
//        HGHomeHotGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
//        cell.currentVC = self;
//        cell.type = @"youLike";
//        cell.showTitle.text = title;
//        cell.hidden = [array count] > 0 ? NO : YES;
//        cell.dataArray = array;
//        return cell;
//    }
//    else if ([type isEqualToString:@"videoList"])
//    {
//        static NSString *reuseID = @"VideoListCell";
//        MyHomeVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
//        cell.currentVC = self;
//        cell.type = @"video";
//        cell.showTitle.text = title;
//        cell.hidden = [array count] > 0 ? NO : YES;
//        cell.dataArray = array;
//        return cell;
//    }
    else if ([type isEqualToString:@"reserverGames"])
    {
        static NSString *reuseID = @"ReserveListCell";
        MyHomeVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.currentVC = self;
        cell.type = @"reserve";
        cell.hidden = [array count] > 0 ? NO : YES;
        cell.dataArray = [[NSMutableArray alloc] initWithArray:array];
        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:title_image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                cell.titleImageWidthConstraint.constant = image.size.width*18/image.size.height;
            }
        }];
        return cell;
    }
    else if ([type isEqualToString:@"diycategory"])
    {
        static NSString *reuseID = @"HGHomeProjectGamesCell";
        HGHomeProjectGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.currentVC = self;
        cell.type = @"project";
        cell.colorView.backgroundColor = UIColor.whiteColor;
        cell.collectionView.backgroundColor = UIColor.whiteColor;
        cell.hidden = [array count] > 0 ? NO : YES;
        cell.dataArray = array;
        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:title_image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                cell.titleImageWidthConstraint.constant = image.size.width*18/image.size.height;
            }
        }];
        return cell;
    }
    else if ([type isEqualToString:@"hotCategory"])
    {
        static NSString *reuseID = @"HGHomeProjectGamesCell";
        HGHomeProjectGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.currentVC = self;
        cell.type = @"classify";
        cell.colorView.backgroundColor = BackColor;
        cell.collectionView.backgroundColor = BackColor;
        cell.hidden = [array count] > 0 ? NO : YES;
        cell.dataArray = array;
        cell.moreBtn.hidden = YES;
        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:title_image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                cell.titleImageWidthConstraint.constant = image.size.width*18/image.size.height;
            }
        }];
        return cell;
    }
//    else if ([type isEqualToString:@"imagejump"])
//    {
//        static NSString *reuseID = @"MyTwoActivityItemsCell";
//        MyTwoActivityItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
//        cell.currentVC = self;
//        cell.hidden = ![dic[@"is_show"] boolValue];
//        cell.dataArray = array;
//        return cell;
//    }
//    else if ([type isEqualToString:@"recentlyPlayGame"])
//    {
//        static NSString *reuseID = @"HomeRecentlyPlayCell";
//        HomeRecentlyPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
//        cell.currentVC = self;
//        cell.dataArray = array;
//        return cell;
//    }
    
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==%ld",(long)indexPath.section);

    NSString * type = self.dataArray[indexPath.section][@"tag"];
    if ([type isEqualToString:@"popularGame"])
    {
        NSDictionary * bannerDic = self.popularGame[@"list"];
        if (bannerDic && ![bannerDic isKindOfClass:[NSNull class]])
        {
            MyGameRecommendCell * cell = (MyGameRecommendCell * )[tableView cellForRowAtIndexPath:indexPath];
            [cell gameContentTableCellBtn:bannerDic[@"recommend_top"]];
        }
    }
    else if ([type isEqualToString:@"projectGames"] || [type isEqualToString:@"diycategory"])
    {
        NSDictionary * dic = self.dataArray[indexPath.section];
        
        if ([type isEqualToString:@"projectGames"] && [dic[@"jump_type"] isEqualToString:@"tradeGoods"]) {
            [YYToolModel.shareInstance showUIFortype:dic[@"jump_type"] Parmas:@""];
            return;
        }
        
        [MyAOPManager relateStatistic:@"ClickTheTopicToSeeMore" Info:@{@"title":dic[@"title"]}];
        
        if ([type isEqualToString:@"projectGames"] && [dic[@"outstyle"] intValue] == 3) {
            [MyAOPManager relateStatistic:@"ClickTheGameInTheTopic" Info:@{@"title":dic[@"title"],@"gameName":dic[@"game_info"][@"game_name"]}];
            GameDetailInfoController * detail = [[GameDetailInfoController alloc] init];
            detail.gameID = dic[@"game_info"][@"game_id"];
            [self.navigationController pushViewController:detail animated:YES];
            return;
        }
        
        if ([type isEqualToString:@"projectGames"] && [dic[@"style"] intValue] == 6) {
            InternalTestingViewController * detail = [[InternalTestingViewController alloc] init];
            detail.Id = dic[@"id"];
            detail.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:detail animated:YES];
            return;
        }
        
        if ([type isEqualToString:@"diycategory"] && [dic[@"target_type"] integerValue] == 2)
        {
            UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
            [nav.tabBarController setSelectedIndex:1];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectGameType" object:dic[@"target_game_cate"]];
            return;
        }
        MyProjectGameController * project = [MyProjectGameController new];
        project.hidesBottomBarWhenPushed = YES;
        project.project_id = dic[@"id"];
        project.project_title = dic[@"title"];
        project.type = type;
//        project.dataDic = dic;
        [self.navigationController pushViewController:project animated:YES];
    }
    else if ([type isEqualToString:@"reserverGames"])
    {
        MyGamePreviewController * preview = [MyGamePreviewController new];
        preview.hidesBottomBarWhenPushed = YES;
        preview.isHomeMore = YES;
        [self.navigationController pushViewController:preview animated:YES];
    }
    else if ([type isEqualToString:@"startingGames"])
    {
        MyNewGameStartingController * game = [MyNewGameStartingController new];
        game.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:game animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    MYLog(@"==========-->>>%f", scrollView.contentOffset.y);
    
    NSDictionary * dic = self.dataDic[@"swiper_920"][0];
    UIColor * color = [UIColor colorWithHexString:dic[@"color"]];
    CGFloat ratio = scrollView.contentOffset.y / self.topBackView.height;
    self.topBackView.backgroundColor = [color colorWithAlphaComponent:ratio >= 1 ? 0 : (1-ratio)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新，
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshScrollOffsetY" object:[NSNumber numberWithFloat:scrollView.contentOffset.y]];
    });
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull HGHomeHotGamesCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    [self playVideoInVisiableCells];
}

// 松手时已经静止,只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO)
    {
        // scrollView已经完全静止
        [self playVideoInVisiableCells];
    }
}

// 松手时还在运动, 先调用scrollViewDidEndDragging,在调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //scrollView已经完全静止
    [self playVideoInVisiableCells];
}

- (void)playVideoInVisiableCells
{
    NSArray *visiableCells = [self.tableView visibleCells];
    //在可见cell中找到第一个有视频的cell
    MyHomeVideoListCell  * videoCell = nil;
    for (MyHomeVideoListCell *cell in visiableCells)
    {
        if ([cell isKindOfClass:[MyHomeVideoListCell class]])
        {
            if ([cell.type isEqualToString:@"video"])
            {
                videoCell = cell;
                break;
            }
        }
    }
    //如果找到了, 就开始播放视频
    if (videoCell)
    {
        if (videoCell.player)
        {
            [videoCell.player play];
        }
        else
        {
            [videoCell sj_playerNeedPlayNewAssetAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
    }
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [tableView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getHomeData:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } isHud:NO];
    }];
    
    // 上拉刷新
//    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.pageNumber ++;
//
//    }];
}

#pragma mark - 获取顶部segment的状态
- (void)getTopButtonCount
{
    //获取折扣和BT显示状态
    SegmentTypeApi * api = [[SegmentTypeApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        NSDictionary * dic = [request.data deleteAllNullValue];
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
            AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appd getHomePageMaterial];
        }
        //至尊版下载地址
        if (dic[@"vip_app_url"]) {
            [YYToolModel saveUserdefultValue:dic[@"vip_app_url"] forKey:@"vip_app_url"];
        }
        //是否打开至尊版通道
        [DeviceInfo shareInstance].isVipPassage = [dic[@"is_vip_passage"] boolValue];
        //是否开启视频介绍
        [DeviceInfo shareInstance].intro_video_url = dic[@"intro_video_url"];
        [DeviceInfo shareInstance].isOpenIntro = [dic[@"is_open_intro"] boolValue];
        //TF签名友盟一键登录动态的key
        [DeviceInfo shareInstance].TFSiginVerifyKey = dic[@"qqkey"];
        //将配置存储
        [DeviceInfo shareInstance].data = dic;
        if ([dic[@"is_activity"] boolValue])
        {
            //活动期间按钮的显示统计
            [MyAOPManager relateStatistic:@"ShowFloatingWndowAds" Info:@{@"type":@"huodong"}];
            NSString * activityImg = dic[@"activity_thumb"];
            if (![activityImg isBlankString])
            {
                [self.signBtn sd_setImageWithURL:[NSURL URLWithString:activityImg] forState:0];
            }
            else
            {
                [self.signBtn setImage:MYGetImage(@"activity_bg_icon") forState:UIControlStateNormal];
            }
            [self.signBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(60);
            }];
        }
//        else if (!self.isFinish)
//        {
//            [MyAOPManager relateStatistic:@"ShowFloatingWndowAds" Info:@{@"type":@"shouchong"}];
//            [self.signBtn setImage:[UIImage imageNamed:@"Send_first_charge_btn"] forState:UIControlStateNormal];
//            [self.signBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(60);
//            }];
//        }
        else
        {
            self.signBtn.hidden = YES;
            [self.signBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

//显示送首充
- (void)firstChargeView:(BOOL)isShowActivity
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isShowActivity)
            {
//                MYLog(@"==========%@", Activity_Save_Id);
                [YYToolModel saveUserdefultValue:Activity_Save_Id forKey:ShowActivityTag];
            }
            else
            {
                [YYToolModel saveUserdefultValue:FirstCharge_Save_Id forKey:ShowFirstChargeTag];
            }
        });
    });
    
    SendFirstChargeCoverView * coverView = [[SendFirstChargeCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    coverView.currentVC = self;
    coverView.isActivity = isShowActivity;
    coverView.isNoviceFuli = NO;
    coverView.tag = 5233;
    coverView.hidden = ![[YYToolModel getCurrentVC] isKindOfClass:NSClassFromString(@"MyHomeSubsectionController")];
    coverView.ClickActionBlock = ^{
        [self hiddenAllAlertView];
    };
    [[UIApplication sharedApplication].delegate.window addSubview:coverView];
}

//获取开屏通知
- (void)getHomeNoticeRequest
{
    HomeOpenNoticeApi *api = [[HomeOpenNoticeApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleGetHomeNoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleGetHomeNoticeSuccess:(HomeOpenNoticeApi *)api
{
    if (api.success == 1)
    {
        self.isLoginRefresh = NO;
        [self parmasNoticeData:api.data];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

- (void)parmasNoticeData:(NSDictionary *)data
{
    if ([data isKindOfClass:[NSNull class]] || !data)
    {
        return;
    }
    if ([DeviceInfo shareInstance].isULink) {
        return;
    }
    self.noticeDic = data;

    //显示活动
    BOOL isActivity = [[YYToolModel getUserdefultforKey:IS_ACTIVITY] boolValue];
    NSString * activityTag = [YYToolModel getUserdefultforKey:ShowActivityTag];
    if (isActivity && ([DeviceInfo shareInstance].activityDic && (activityTag == NULL || ![Activity_Save_Id isEqualToString:activityTag])))
    {
        [MyAOPManager relateStatistic:@"ShowPop-upAds" Info:@{@"type":@"huodong"}];
        [self firstChargeView:YES];
    }
    self.popularGame = data[@"popularGame"];
    if (self.dataArray.count > 0){
        if (!self.dataArray.firstObject[@"popularGame"] && self.popularGame)
        {
            NSDictionary * dic = @{@"title":@"", @"tag":@"popularGame", @"popularGame":self.popularGame, @"sort":@"0"};
            [self.dataArray insertObject:dic atIndex:0];
        }
        [self.tableView reloadData];
    }
    if(![data[@"popularGame"][@"bottom_banner"] isEqual:[NSNull null]]){
        NSDictionary * bottom_banner = data[@"popularGame"][@"bottom_banner"];
        if (bottom_banner.count>0){
            [self.view addSubview:self.img];
            self.img.didBlock = ^{
                BOOL is_check_login = [bottom_banner[@"is_check_login"] boolValue];
                if(is_check_login && ![YYToolModel isAlreadyLogin]){
                    return;
                }
                [[[YYToolModel alloc] init] showUIFortype:bottom_banner[@"type"] Parmas:bottom_banner[@"value"]];
            };
            [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.mas_equalTo(0);
            }];
            [self.img yy_setImageWithURL:[NSURL URLWithString:bottom_banner[@"img"]] placeholder:nil options:0 completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                [self.img mas_updateConstraints:^(MASConstraintMaker *make) {
                    if(image){
                        make.height.mas_equalTo(image.size.height/image.size.width*ScreenWidth);
                    }
                }];
            }];
        }
    }
    //显示开屏通知
    NSArray * alertList = data[@"alertList"];
    for (NSDictionary * dic in alertList)
    {
        NSInteger type = [dic[@"type"] integerValue];
        if (type == 2)
        {
            if ([YYToolModel isBlankString:dic[@"img"]])
            {
                MyOpeningNoticeView * noticeView = [[MyOpeningNoticeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                noticeView.dataDic = dic;
                noticeView.currentVC = self;
                noticeView.tag = 5230;
                noticeView.hidden = ![[YYToolModel getCurrentVC] isKindOfClass:NSClassFromString(@"MyHomeSubsectionController")];
                noticeView.ClickActionBlock = ^{
                    [self hiddenAllAlertView];
                };
                [[UIApplication sharedApplication].delegate.window addSubview:noticeView];
            }
            else
            {
                SendFirstChargeCoverView * coverView = [[SendFirstChargeCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                coverView.currentVC = self;
                coverView.dataDic = dic;
                coverView.tag = 5231;
                coverView.hidden = ![[YYToolModel getCurrentVC] isKindOfClass:NSClassFromString(@"MyHomeSubsectionController")];
                coverView.ClickActionBlock = ^{
                    [self hiddenAllAlertView];
                };
                [[UIApplication sharedApplication].delegate.window addSubview:coverView];
            }
        }
        else if (type == 3)
        {
            WEAKSELF
            MyAlertConfigure * configure = [MyAlertConfigure new];
            configure.title = dic[@"title"];
            configure.btnTitleColors = @[ColorWhite];
            configure.btnBackColors = @[MAIN_COLOR];
            configure.btnTitles = @[dic[@"button"]];
            configure.content = dic[@"content"];
            configure.showIcon = true;
            configure.textAlignment = NSTextAlignmentLeft;
            configure.tag = 5232;
            MyAlertView * alertView = [MyAlertView alertViewWithConfigure:configure buttonBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [self hiddenAllAlertView];
                    MyChatViewController * chat = [MyChatViewController new];
                    chat.message_id = dic[@"value"];
                    chat.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:chat animated:YES];
                }
            }];
            alertView.hidden = ![[YYToolModel getCurrentVC] isKindOfClass:NSClassFromString(@"MyHomeSubsectionController")];
        }
    }
    
    
    
    
    /********************* 之前的逻辑 *************************/
    
    
    
    
    
    //如果首页的引导页面没有展示，先展示引导图
//    NSString * userCenter = [YYToolModel getUserdefultforKey:@"HomeGuidePageView"];
//    if (userCenter == NULL)
//    {
//        return;
//    }
    
    //显示返利、交易驳回信息
//    if (![data[@"reject"] isKindOfClass:[NSNull class]] && data[@"reject"] && [data[@"reject"] allKeys].count > 0)
//    {
//        MyDismissOperationView * dismissView = [[MyDismissOperationView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        dismissView.dataDic   = data[@"reject"];
//        dismissView.currentVC = self;
//        [[UIApplication sharedApplication].delegate.window addSubview:dismissView];
//    }
//    else
//    {
        //若没有返利、交易驳回，是否有活动，要是有活动则显示活动
//        BOOL isActivity = [[YYToolModel getUserdefultforKey:IS_ACTIVITY] boolValue];
//        NSString * activityTag = [YYToolModel getUserdefultforKey:ShowActivityTag];
//        NSString * noticeTag = [YYToolModel getUserdefultforKey:ShowNoticeTag];
//         if (![data[@"notice"] isKindOfClass:[NSNull class]] && data[@"notice"] && [data[@"notice"] allKeys].count > 0 && ![Notice_Save_Id isEqualToString:noticeTag])
//        {
//            [YYToolModel saveUserdefultValue:Notice_Save_Id forKey:ShowNoticeTag];
//            //没有活动则显示通知
//            NSDictionary *dics = data[@"notice"];
//            if ([dics[@"type"] integerValue] == 1)
//            {
//                MyOpeningNoticeView * noticeView = [[MyOpeningNoticeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                noticeView.dataDic = dics;
//                noticeView.currentVC = self;
//                [[UIApplication sharedApplication].delegate.window addSubview:noticeView];
//            }
//            else if ([dics[@"type"] integerValue] == 2)
//            {
//                SendFirstChargeCoverView * coverView = [[SendFirstChargeCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                coverView.currentVC = self;
//                coverView.dataDic = dics;
//                [[UIApplication sharedApplication].delegate.window addSubview:coverView];
//            }
//        }
//        else if (isActivity && ([DeviceInfo shareInstance].activityDic && (activityTag == NULL || ![Activity_Save_Id isEqualToString:activityTag])))
//         {
//             [MyAOPManager relateStatistic:@"ShowPop-upAds" Info:@{@"type":@"huodong"}];
//             [self firstChargeView:YES];
//         }
//        else
//        {
//            if (![YYToolModel islogin]) return;
//            NSString * firstChargeTag = [YYToolModel getUserdefultforKey:ShowNoviceTag];
//            NSString * eight = [NSString stringWithFormat:@"%@is_show_reg_between_8day_30day",[YYToolModel getUserdefultforKey:USERID]];
//            NSString * thirty = [NSString stringWithFormat:@"%@is_show_reg_gt_30day",[YYToolModel getUserdefultforKey:USERID]];
//            NSString * str = @"";
//            //新人福利，注册7天内的用户
//            if (([DeviceInfo shareInstance].novice_fuli_v2101_show == 1 && [DeviceInfo shareInstance].novice_fuli_v2101_expire_time > 0) && (firstChargeTag == NULL || ![firstChargeTag isEqualToString:Novice_Save_Id]))
//            {
//                str = @"7";
//                SendFirstChargeCoverView * coverView = [[SendFirstChargeCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                coverView.currentVC = self;
//                coverView.isNoviceFuli = YES;
//                [[UIApplication sharedApplication].delegate.window addSubview:coverView];
//
//                [YYToolModel saveUserdefultValue:Novice_Save_Id forKey:ShowNoviceTag];
//            }
//            else if (DeviceInfo.shareInstance.novice_fuli_eight_time == 1 && ![NSUserDefaults.standardUserDefaults objectForKey:eight])
//            {
//                str = @"8";
//                SendFirstChargeCoverView * coverView = [[SendFirstChargeCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                coverView.currentVC = self;
//                coverView.novice_fuli_eight_time = YES;
//                [[UIApplication sharedApplication].delegate.window addSubview:coverView];
//                [YYToolModel saveUserdefultValue:@"is_show_reg_between_8day_30day" forKey:eight];
//            }
//            else if (DeviceInfo.shareInstance.novice_fuli_thirty_time == 1 && ![NSUserDefaults.standardUserDefaults objectForKey:thirty])
//            {
//                str = @"30";
//                SendFirstChargeCoverView * coverView = [[SendFirstChargeCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                coverView.currentVC = self;
//                coverView.novice_fuli_thirty_time = YES;
//                [[UIApplication sharedApplication].delegate.window addSubview:coverView];
//                [YYToolModel saveUserdefultValue:@"is_show_reg_gt_30day" forKey:thirty];
//            }
//            else
//                if (!self.isFinish)
//            {
//                NSString * firstChargeTag = [YYToolModel getUserdefultforKey:ShowFirstChargeTag];
//                if (firstChargeTag == NULL || ![firstChargeTag isEqualToString:FirstCharge_Save_Id])
//                {
//                    str = @"shouchong";
//                    [self firstChargeView:NO];
//                }
//            }
//            //统计弹窗显示
//            if (![str isEqualToString:@""])
//            {
//                [MyAOPManager relateStatistic:@"ShowPop-upAds" Info:@{@"type":str}];
//            }
//        }
//    }
    //为了将闪屏后的图片置顶
    UIImageView * imageView = [[UIApplication sharedApplication].delegate.window viewWithTag:8888];
    if (imageView)
    {
       [[UIApplication sharedApplication].delegate.window bringSubviewToFront:imageView];
    }
    
    NSString * userCenter = [YYToolModel getUserdefultforKey:@"HomeGuidePageView"];
    MyUserAgreementView * userView = [[UIApplication sharedApplication].delegate.window viewWithTag:9999];
    if (userCenter == NULL)
    {
        [[UIApplication sharedApplication].delegate.window bringSubviewToFront:userView];
    }
}

- (void)hiddenAllAlertView
{
    for (int i = 0; i < 4; i ++)
    {
        UIView * view = [[UIApplication sharedApplication].delegate.window viewWithTag:5230 + i];
        view.hidden = YES;
    }
}

- (void)showAllAlertView
{
    for (int i = 0; i < 4; i ++)
    {
        UIView * view = [[UIApplication sharedApplication].delegate.window viewWithTag:5230 + i];
        view.hidden = NO;
    }
}

#pragma mark ——— 上传推广激活数据
- (void)uploadPromotionData
{
    MyPromotionActivationApi * api = [[MyPromotionActivationApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - 获取未读消息
- (void)getUnreadMgsCount{
    if ([YYToolModel getUserdefultforKey:USERID] == NULL) return;
    
    GetUnreadMgsApi *api = [[GetUnreadMgsApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request){
        NSString * count = [NSString stringWithFormat:@"%@",api.data[@"message_unread_num"]];
        UITabBarController * tabBarController = (UITabBarController *)UIApplication.sharedApplication.keyWindow.rootViewController;
        UITabBarItem *item = [[[tabBarController tabBar] items] objectAtIndex:4];
        if (count.integerValue > 0){
            item.redDotColor = [UIColor redColor];
            [item ShowBadgeView];
        }else{
            [item hideBadgeView];
        }
     } failureBlock:^(BaseRequest * _Nonnull request) {
         
     }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getUnreadMgsCount];
    });
}

@end
