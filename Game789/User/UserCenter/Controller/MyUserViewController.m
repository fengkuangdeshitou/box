//
//  MyUserViewController.m
//  Game789
//
//  Created by Maiyou on 2019/10/18.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyUserViewController.h"
#import "MyMessageViewController.h"
#import "SettingDetailViewController.h"
#import "MyTrumpetRecyclingController.h"
#import "ModifyNameViewController.h"

#import "TipBarView.h"
#import "MyUserHeaderView.h"
#import "YYPersonalCollectionSectionView.h"
#import "YYPersonalCollectionViewCell.h"
#import "MyDownGameVipNoticeView.h"

#import "GetServiceApi.h"
#import "GetUnreadMgsApi.h"

#define HeaderViewHeight 370

@interface MyUserViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) NSArray * sectionTitles;
@property (nonatomic, strong) MyUserHeaderView * headerView;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (strong, nonatomic) NSDictionary *memberDic;
@property (nonatomic, strong) UIButton * emailButton;
@property (nonatomic, assign) NSInteger available_voucher;
@property (nonatomic, strong) TipBarView * barView;

@end

@implementation MyUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self setEmailClick];
    
    [self creatHeaderView];
    //获取QQ跳转数据
    [self getQQApiRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //我的页面统计
    [MyAOPManager relateStatistic:@"BrowseMyPage" Info:@{}];
    
    [self getUserInfoApiRequest];
    
    [self getUnreadMgsCount];
    
//    [BaiduAction logAction: BaiduSDKActionNamePurchase actionParam: @{BaiduSDKActionParamKeyPurchaseMoney:@(6)}];
    
}

#pragma mark - 基本配置
- (void)prepareBasic
{
    self.navBar.backgroundColor = [UIColor clearColor];
    self.navBar.titleLable.textColor = [UIColor whiteColor];
    self.navBar.lineView.hidden = YES;
    self.view.backgroundColor = BackColor;

    NSDictionary * dic = @{@"title":@"至尊通道", @"image":@"user_icon15", @"vc":@"intro"};
    NSDictionary * dic1 = @{@"title":@"平台介绍", @"image":@"user_icon16", @"vc":@"video"};
//    NSDictionary * dic2 = @{@"title":@"活动测试", @"image":@"user_icon16", @"vc":@"WebViewController"};
    NSMutableArray * array = [NSMutableArray arrayWithArray:self.titleArray[1]];
    if (![DeviceInfo shareInstance].isGameVip && [DeviceInfo shareInstance].isVipPassage)
    {
        [array addObject:dic];
    }
    if ([DeviceInfo shareInstance].isOpenIntro)
    {
        [array insertObject:dic1 atIndex:2];
    }
//    [array addObject:dic2];
    NSInteger count = array.count;
    if (array.count < 8)
    {
        for (int i = 0; i < 8 - count; i ++)
        {
            [array addObject:@{@"title":@"", @"image":@"", @"vc":@""}];
        }
    }
    [self.titleArray replaceObjectAtIndex:1 withObject:array];
    
    [self.view insertSubview:self.collectionView belowSubview:self.navBar];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.memberDic = [YYToolModel getUserdefultforKey:@"member_info"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitLogin) name:kLoginExitNotice object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollTopAction:) name:NSStringFromClass([self class]) object:nil];
}

#pragma mark ——— 单击指定双击刷新
- (void)scrollTopAction:(NSNotification *)noti
{
    [self.collectionView setContentOffset:CGPointMake(0, -HeaderViewHeight) animated:YES];
    
    NSNumber * number = noti.object;
    //双击刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([number boolValue])
        {
            [self getUserInfoApiRequest];
        }
    });
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = [NSMutableArray arrayWithArray:@[
       @[@{@"title":@"返利中心".localized, @"image":@"user_icon4", @"vc":@"MyRebateCenterController"},
         @{@"title":@"我的账单".localized, @"image":@"user_icon21", @"vc":@"MyOrderDetailListController"},
         @{@"title":@"我的游戏".localized, @"image":@"user_icon8", @"vc":@"MyCollectionCenterController"},
         @{@"title":@"我的礼包".localized, @"image":@"user_icon5", @"vc":@"MyGiftViewController"},
         @{@"title":@"我的足迹".localized, @"image":@"user_icon19", @"vc":@"UserPersonalCenterController"},
         @{@"title":@"邀请好友".localized, @"image":@"user_icon7", @"vc":@"MyInviteFriendsController"},
         @{@"title":@"充值转游".localized, @"image":@"user_icon3", @"vc":@"MyTransferViewController"},
         @{@"title":@"小号回收".localized, @"image":@"user_icon18", @"vc":@""}],
       @[@{@"title":@"在线客服".localized, @"image":@"user_icon20", @"vc":@"MyCustomerServiceController"},
         @{@"title":@"投诉反馈".localized, @"image":@"user_icon17", @"vc":@"MyFeedbackViewController"},
         @{@"title":@"加入QQ群".localized, @"image":@"user_icon12", @"vc":@"qq"},
         @{@"title":@"账号安全".localized, @"image":@"user_icon11", @"vc":@"SecureViewController"}]]];
    }
    return _titleArray;
}

- (NSArray *)sectionTitles
{
    if (!_sectionTitles)
    {
        _sectionTitles = @[@"玩家服务".localized, @"更多服务".localized];
    }
    return _sectionTitles;
}

//退出登陆调用方法
- (void)exitLogin{
    @try {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"member_info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self cancelLocalNotification];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        self.available_voucher = 0;
        self.memberDic = @{};
        self.headerView.dataDic = self.memberDic;
        [self.collectionView reloadData];
    }
}

//// 取消本地推送通知
- (void)cancelLocalNotification {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

#pragma mark 请求数据
- (void)getUserInfoApiRequest
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (userId && userId.length > 0) {
        GetUserInfoApi *api = [[GetUserInfoApi alloc] init];
        
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            [self handleUserSuccess:api];
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
    else
    {
        self.headerView.dataDic = @{};
    }
}

- (void)handleUserSuccess:(GetUserInfoApi *)api
{
    if (api.success == 1)
    {
        NSDictionary * dic = api.data[@"member_info"] ;
        self.memberDic = [dic deleteAllNullValue];
        [YYToolModel saveUserdefultValue:dic[@"member_name"] forKey:@"user_name"];
        [YYToolModel saveUserdefultValue:self.memberDic forKey:@"member_info"];
        [DeviceInfo shareInstance].isCheckAuth = [dic[@"isCheckAuth"] boolValue];
        [DeviceInfo shareInstance].isCheckAdult = [dic[@"isCheckAdult"] boolValue];
        if ([DeviceInfo shareInstance].isGameVip)
        {
            [YYToolModel saveUserdefultValue:@"0" forKey:DOWN_STYLE];
        }
        else
        {
            [YYToolModel saveUserdefultValue:dic[@"ios_down_style"] forKey:DOWN_STYLE];
        }
        self.available_voucher = [self.memberDic[@"available_voucher"] integerValue];
        [DeviceInfo shareInstance].vipsignLifeTimeDesc = dic[@"vipsignLifeTimeDesc"];
        [DeviceInfo shareInstance].boxBranch = dic[@"boxBranch"];
        self.headerView.dataDic = self.memberDic;
        [self.collectionView reloadData];
        //新人福利显示
        [DeviceInfo shareInstance].timeout = [self.memberDic[@"novice_fuli_v2101_expire_time"] integerValue];
        [DeviceInfo shareInstance].novice_fuli_v2101_expire_time = [dic[@"novice_fuli_v2101_expire_time"] integerValue];
        [DeviceInfo shareInstance].novice_fuli_v2101_show = [dic[@"novice_fuli_v2101_show"] integerValue];
        [DeviceInfo shareInstance].novice_fuli_eight_time = [dic[@"is_show_reg_between_8day_30day"] integerValue];
        [DeviceInfo shareInstance].novice_fuli_thirty_time = [dic[@"is_show_reg_gt_30day"] integerValue];
        [DeviceInfo shareInstance].reg_gt_30day_url = dic[@"reg_gt_30day_url"];
    }
    else {
        [YYToolModel deleteUserdefultforKey:USERID];
        NSLog(@" api.error--------->%@", api.error_desc);
    }
}

#pragma mark 请求QQ群地址
- (void)getQQApiRequest {
    
    GetServiceApi *api = [[GetServiceApi alloc] init];
    //    api.pageNumber = self.pageNumber;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleQQSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleQQSuccess:(GetServiceApi *)api
{
    if (api.success == 1) {
        self.dataDic = [[NSDictionary alloc] initWithDictionary:api.data];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = api.error_desc;
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.0];
    }
}

#pragma mark - 获取未读消息
- (void)getUnreadMgsCount
{
    if ([YYToolModel getUserdefultforKey:USERID] == NULL) return;
    
    GetUnreadMgsApi *api = [[GetUnreadMgsApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
     {
         NSString * count = [NSString stringWithFormat:@"%@",api.data[@"message_unread_num"]];
//         UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:4];
         if (count.integerValue > 0)
         {
             //设置item角标数字
//             item.badgeValue = count;
             
             self.emailButton.redDotText = count;
             [self.emailButton ShowBadgeView];
             self.navigationController.tabBarItem.redDotColor = [UIColor redColor];
             [self.navigationController.tabBarItem ShowBadgeView];
         }
         else
         {
//             item.badgeValue = nil;
             [self.emailButton hideBadgeView];
             [self.navigationController.tabBarItem hideBadgeView];
         }
     } failureBlock:^(BaseRequest * _Nonnull request) {
         
     }];
}

#pragma mark 邮箱设置按钮
-(void)setEmailClick
{
    UIButton * setBtn = [[UIButton alloc]init];
    [setBtn setImage:[UIImage imageNamed:@"Group15"] forState:UIControlStateNormal];
    setBtn.imageEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    [self.navBar addSubview:setBtn];
    [setBtn addTarget:self action:@selector(exitApp) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * email = [[UIButton alloc]init];
    [email setImage:[UIImage imageNamed:@"Group19"] forState:UIControlStateNormal];
    email.imageEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    [self.navBar addSubview:email];
    [email addTarget:self action:@selector(pushToMessageVC) forControlEvents:UIControlEventTouchUpInside];
    self.emailButton = email;
    email.frame = CGRectMake(kScreen_width - 67, kStatusBarHeight + (44 - 25) / 2, 25, 25);
    setBtn.frame = CGRectMake(CGRectGetMaxX(email.frame) + 6.5, email.y, 25, 25);
}

- (void)exitApp
{
    SettingDetailViewController *settingVC = [[SettingDetailViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark 我的消息
- (void)pushToMessageVC
{
    if ([YYToolModel isAlreadyLogin])
    {
        MyMessageViewController *gitfVC = [[MyMessageViewController alloc] init];
        gitfVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gitfVC animated:YES];
    }
}

- (void)creatHeaderView
{
    _headerView = [[MyUserHeaderView alloc] initWithFrame:CGRectMake(0, - HeaderViewHeight, kScreenW, HeaderViewHeight)];
    _headerView.currentVC = self;
    [self.collectionView addSubview:_headerView];
    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
    if (dic != NULL)
    {
        _headerView.dataDic = self.memberDic;
        self.available_voucher = [self.memberDic[@"available_voucher"] integerValue];
    }
    else
    {
        _headerView.dataDic = @{};
        _headerView.userName_top.constant = -2.5;
        _headerView.userName_height.constant = 20;
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置列的最小间距
        flowLayout.minimumInteritemSpacing = 0;
        // 设置最小行间距
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTabbarHeight) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //设置内容范围偏移HeaderViewHeight
        _collectionView.contentInset = UIEdgeInsetsMake(HeaderViewHeight, 0, 0, 0);
        //注册
        [_collectionView registerNib:[UINib nibWithNibName:@"YYPersonalCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"YYPersonalCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YYPersonalCollectionSectionView class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YYPersonalCollectionSectionView"];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.titleArray.count;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"YYPersonalCollectionViewCell";
    YYPersonalCollectionViewCell * cell = (YYPersonalCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary * dic = self.titleArray[indexPath.section][indexPath.item];
    cell.dataDic = dic;
    cell.indexPath = indexPath;
    cell.showTitle.textColor = [UIColor colorWithHexString:indexPath.section == 0 ? @"#282828" : @"#999999"];
    cell.showTitle.font = [UIFont systemFontOfSize:indexPath.section == 0 ? 13 : 12 weight:UIFontWeightMedium];
//    if (indexPath.section == 0 && indexPath.item == 1 && [self.memberDic[@"available_voucher"] integerValue] > 0)
//    {
//        cell.badgeCount.text = [NSString stringWithFormat:@"%@", self.memberDic[@"available_voucher"]];
//        cell.badgeCount.hidden = NO;
//        
//        cell.badgeLabel_height.constant = 16;
//        cell.badgeLabel_left.constant = -8;
//        cell.badgeCount.layer.cornerRadius = 8;
//        if ([self.memberDic[@"available_voucher"] integerValue] > 99)
//        {
//            cell.badgeLabel_width.constant = 25;
//        }
//        else
//        {
//            cell.badgeLabel_width.constant = 16;
//        }
//    }
//    else
//    {
        cell.badgeCount.hidden = YES;
//    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            [self clipRectCorner:UIRectCornerTopLeft radius:13 view:cell.radiusView section:indexPath.section];
        }else if (indexPath.row == 3)
        {
            [self clipRectCorner:UIRectCornerTopRight radius:13 view:cell.radiusView section:indexPath.section];
        }
        else if (indexPath.row == 4)
        {
            [self clipRectCorner:UIRectCornerBottomLeft radius:13 view:cell.radiusView section:indexPath.section];
        }
        else if (indexPath.row == 7)
        {
            [self clipRectCorner:UIRectCornerBottomRight radius:13 view:cell.radiusView section:indexPath.section];
        }
        else{
            [self clipRectCorner:UIRectCornerAllCorners radius:0 view:cell.radiusView section:indexPath.section];
        }
    }
    else
    {
       if (indexPath.row == 0) {
           [self clipRectCorner:UIRectCornerTopLeft radius:13 view:cell.radiusView section:indexPath.section];
       }
       else if (indexPath.row == 3)
       {
           [self clipRectCorner:UIRectCornerTopRight radius:13 view:cell.radiusView section:indexPath.section];
       }
       else if (indexPath.row == 4)
       {
           [self clipRectCorner:UIRectCornerBottomLeft radius:13 view:cell.radiusView section:indexPath.section];
       }
       else if (indexPath.row == 7)
       {
           [self clipRectCorner:UIRectCornerBottomRight radius:13 view:cell.radiusView section:indexPath.section];
       }else{
           [self clipRectCorner:UIRectCornerAllCorners radius:0 view:cell.radiusView section:indexPath.section];
       }
   }
    return cell;
}

- (void)clipRectCorner:(UIRectCorner)corner radius:(CGFloat)radius view:(UIView *)view section:(NSInteger)section{
    [view setNeedsLayout];
    [view layoutIfNeeded];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = path.CGPath;
    view.layer.mask = maskLayer;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger num = 4;
    CGFloat itemWidth = (kScreenW-30)/num;
    CGFloat height = 80;
    NSString * string = [NSString stringWithFormat:@"%.2f",itemWidth];
    CGFloat remainder = 0;
    if ([string containsString:@"."]) {
        remainder = [[[NSString stringWithFormat:@"%.2f",itemWidth] componentsSeparatedByString:@"."].lastObject floatValue]/100;
    }
     
    CGFloat realWidth = floor(itemWidth);
    if(indexPath.row == 0 || indexPath.row == 4){
        //第一列的width比其他列稍大一些，消除item之间的间隙
        return CGSizeMake(realWidth+remainder*num, height);
    }else{
        return CGSizeMake(realWidth, height);
    }
//    return CGSizeMake(ceilf((kScreenW - 30) / 4), 80);
}
//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, section == 0 ? 0 : 15, 15);
}

//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    YYPersonalCollectionSectionView * sectionView = (YYPersonalCollectionSectionView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"YYPersonalCollectionSectionView" forIndexPath:indexPath];
    sectionView.showTitle.text = [self.sectionTitles[indexPath.section] localized];
    //1 关闭 2 打开 月卡
    BOOL isShow = [[DeviceInfo shareInstance].data[@"monthcard"] integerValue] == 2 ? YES : NO;
    sectionView.monthCardView.hidden = !isShow;
    if (isShow)
    {
        sectionView.spaceView_top.constant = indexPath.section == 0 ?  0 : 11;
        indexPath.section == 0 ? sectionView.spaceView_height.constant = 0 : (sectionView.spaceView_height.constant = 91.5 * (kScreenW - 30) / 345);
    }
    else
    {
        sectionView.spaceView_height.constant = 0;
        sectionView.spaceView_top.constant = 0;
    }
    return sectionView;
}

/**  区头大小  */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    BOOL isShow = [[DeviceInfo shareInstance].data[@"monthcard"] integerValue] == 2 ? YES : NO;
    if (isShow)
    {
        return CGSizeMake(kScreenW, section == 0 ? 51 : (62 + 91.5 * (kScreenW - 15) / 345));
    }
    else
    {
        return CGSizeMake(kScreenW, 51);
    }
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ((((indexPath.row == 1 || indexPath.row == 4) && indexPath.section == 1) || indexPath.section == 0)  && ![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    NSDictionary * dic = self.titleArray[indexPath.section][indexPath.item];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 7)
        {
            [self pushToXhRecycle];
        }
        else
        {
            [self pushToViewVC:indexPath];
        }
        
        //统计
        if (indexPath.item == 0)
        {
            [MyAOPManager userInfoRelateStatistic:@"ClickToApplyForRebate"];
        }
        else if (indexPath.item == 1)
        {
            [MyAOPManager userInfoRelateStatistic:@"ClickMyVoucher"];
        }
        else if (indexPath.item == 5)
        {
            [MyAOPManager userInfoRelateStatistic:@"ClickToInviteFriends"];
        }
        else if (indexPath.item == 6)
        {
            [MyAOPManager userInfoRelateStatistic:@"ClickToTransferGameRechargeOnMyPage"];
        }
    }
    else if (indexPath.section == 1)
    {
        if ([dic[@"vc"] isEqualToString:@"qq"])
        {
            [self pushQQCommunication];
        }
        else
        {
            [self pushToViewVC:indexPath];
        }
    }
}

- (void)pushToXhRecycle
{
    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
    if (dic == NULL || [dic[@"mobile"] isEqualToString:@""])
    {
        BindMobileViewController * bind = [BindMobileViewController new];
        bind.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bind animated:YES];
        return;
    }
    if (dic == NULL || [dic[@"real_name"] isEqualToString:@""] || [dic[@"identity_card"] isEqualToString:@""])
    {
        ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
        bindVC.title = @"实名认证".localized;
        bindVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bindVC animated:YES];
        return;
    }
    MyTrumpetRecyclingController * recycle = [MyTrumpetRecyclingController new];
    recycle.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recycle animated:YES];
}

- (void)pushToViewVC:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.titleArray[indexPath.section][indexPath.item];
    NSString *className = dic[@"vc"]; //classNames 字符串数组集
    Class class = NSClassFromString(className);
    if ([className isEqualToString:@"video"])
    {
        [YYToolModel saveUserdefultValue:@"1" forKey:@"videoPlay"];
        NSString * url = [DeviceInfo shareInstance].intro_video_url;
        SJRouteRequest *reqeust = [[SJRouteRequest alloc] initWithPath:@"player/fullscreen" parameters:@{@"url":url, @"vc":self}];
        [SJRouter.shared handleRequest:reqeust completionHandler:nil];
        [self.collectionView reloadData];
    }
    else if ([className isEqualToString:@"intro"])
    {
        if (![DeviceInfo shareInstance].isGameVip)
        {
            [YYToolModel saveUserdefultValue:@"1" forKey:@"vipIntro"];
            MyDownGameVipNoticeView * noticeView = [[MyDownGameVipNoticeView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
            noticeView.CloseView = ^{
                
            };
            [[UIApplication sharedApplication].delegate.window addSubview:noticeView];
        }
        [self.collectionView reloadData];
    }
//    else if ([className isEqualToString:@"WebViewController"])
//    {
//        NSString * url = [NSString stringWithFormat:@"%@?username=%@&token=%@", @"http://sys.99maiyou.com/home/lottery2109", [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
//        NSString * url = [NSString stringWithFormat:@"%@?username=%@&token=%@", @"http:192.168.1.180:8080", [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
//        WebViewController * coin = [WebViewController new];
//        coin.urlString = url;
//        [self.navigationController pushViewController:coin animated:YES];
//    }
    else if (class && className)
    {
        BaseViewController *ctrl = class.new;
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark — 加入QQ群
- (void)pushQQCommunication
{
    NSDictionary * dic = self.dataDic;
    NSString *string = [dic objectForKey:@"qq_group"];
    if ([YYToolModel isBlankString:string])
    {
        [MBProgressHUD showToast:@"暂时无QQ群" toView:self.view];
        return;
    }
    NSString * urlStr = [dic objectForKey:@"game_group_key"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [MBProgressHUD showToast:@"暂时无QQ群" toView:self.view];
    }
}

#pragma mark — 邀请好友
- (void)pushToInviteFriend
{
    [[YYToolModel getCurrentVC].navigationController pushViewController:[MyInviteFriendsController new] animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.collectionView.contentOffset.y > -self.headerView.height)
    {
        self.navBar.title = @"我的";
    }
    else
    {
        self.navBar.title = @"";
    }
    self.navBar.backgroundColor = [MAIN_COLOR colorWithAlphaComponent:(self.collectionView.contentOffset.y + self.headerView.height) / kStatusBarHeight];
}

@end
