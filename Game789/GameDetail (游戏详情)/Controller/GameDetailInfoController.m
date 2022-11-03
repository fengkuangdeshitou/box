//
//  GameDetailInfoController.m
//  Game789
//
//  Created by Maiyou on 2018/11/6.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "GameDetailInfoController.h"
#import "YNPageViewController.h"
#import "UIView+YNPageExtend.h"

#import "GameDetailKaifuViewController.h"
#import "GameDetailTradeViewController.h"
#import "GameDetailCommentViewController.h"
#import "GameCommitViewController.h"
#import "HGGameDetailIntroController.h"
#import "MyGameDetailIntroBController.h"
#import "PayViewController.h"
#import "HGGameGiftListController.h"
#import "MyGameAllVouchersController.h"
#import "MyBuyVipViewController.h"
#import "CloudGameViewController.h"
#import "CloudGameDescViewController.h"
#import "MyDownloadProgressController.h"
#import "MyCustomerServiceController.h"

#import "GameDetailHeaderView.h"
#import "TipBarView.h"

#import "CloudappCheckAvailableAPI.h"
#import "GameDetailApi.h"
#import "GameDownLoadApi.h"
#import "TradingListApi.h"
#import "GameCommitApi.h"
#import "SmallAccountApi.h"
#import "MyDownGameLoadingView.h"
#import "MyCollectionGameApi.h"
#import "MyGameReserveApi.h"
#import "MyVoucherListModel.h"
#import "MyWelfareViewController.h"
#import "MyShowVipDownTipView.h"
#import "MyCloudGameGuideView.h"
#import "DownloadPromptViewController.h"
#import "MyActivityDetailController.h"
#import "HomeTypeApi.h"
@class StageABTestApi;

#define bg_color [UIColor colorWithHexString:@"FFC46E"]

@class MyCancleGameReserveApi;
@class MyCancleCollectionGameApi;

@interface GameDetailInfoController () <YNPageViewControllerDataSource, YNPageViewControllerDelegate, YCDownloadItemDelegate, MyResignTimeTaskDelegate>

@property (nonatomic, strong) NSDictionary * dataDic;

@property (weak, nonatomic) IBOutlet UIButton *contactServices;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *downLoad;
@property (weak, nonatomic) IBOutlet UIButton *GMButton;
@property (weak, nonatomic) IBOutlet UIButton *vipButton;
@property (weak, nonatomic) IBOutlet UIButton *previewButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preViewBtn_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *preViewButton_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previewButton_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipButton_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipButton_width;

@property (nonatomic, strong) UIButton * kaifuCount;
@property (nonatomic, strong) UIButton * tradeCount;
@property (nonatomic, strong) UIButton * commitCount;
@property (nonatomic, strong) UIButton * giftCount;

@property (nonatomic, strong) NSMutableArray * xhListArray;
@property (nonatomic, strong) TipBarView * barView;
@property (nonatomic, strong) UIView * badgeView;

@property (nonatomic, strong) YCDownloadItem * downloadItem;
@property (nonatomic, copy) NSString * routeUrl;
/**  是否分包  */
@property (nonatomic, assign) BOOL isPackage;
/**  是否可以预约  */
@property (nonatomic, assign) BOOL isReservedSucess;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) MyColorCircle *circleView;
@property (weak, nonatomic) IBOutlet MyLikeButton *collectionButton;
@property (weak, nonatomic) IBOutlet MyLikeButton *collectionButton1;
@property (nonatomic, copy) NSString *showDownSize;
@property (nonatomic, strong) GameDetailHeaderView * headerView;

@end

@implementation GameDetailInfoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
    
    [self creatRightButton];
    
    [self gameDetailApiRequest:nil];
    
//    [self addCircleProgressView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //获取当前签名或者下载的进度
//    [self getResignOrDownloadProgress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGift) name:@"refrefshGiftNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.headerView.player vc_viewWillDisappear];
    
    self.barView.hidden = YES;
    if (self.barView)
    {
        [self.barView removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refrefshGiftNotification" object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.headerView.player vc_viewDidAppear];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.headerView.player vc_viewDidDisappear];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.barView.hidden = YES;
    if (self.barView)
    {
        [self.barView removeFromSuperview];
    }
}

- (void)dealloc
{
    [self.headerView.player stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hiddenTipBarView" object:nil];
}

- (void)prepareBasic
{
    self.navBar.backgroundColor = UIColor.clearColor;
    self.navBar.lineView.hidden = YES;
    [self.navBar.leftButton setImage:MYGetImage(@"back-1") forState:0];
    self.navBar.titleLable.textColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.bottomView.hidden = YES;
    self.downLoad.titleLabel.numberOfLines = 0;
    self.downLoad.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.downLoad.titleLabel.textColor = [UIColor whiteColor];
    self.vipButton.titleLabel.numberOfLines = 0;
    self.vipButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.vipButton.titleLabel.textColor = [UIColor whiteColor];
    self.collectionButton.animateStyle = YYViewAnimateEffectStyleZoom;
    self.collectionButton1.animateStyle = YYViewAnimateEffectStyleDefault;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTipBarView) name:@"hiddenTipBarView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshGameDetail) name:UIApplicationWillEnterForegroundNotification object:nil];

}

- (void)refreshGift{
    GameDetailApi *api = [[GameDetailApi alloc] init];
    //    WEAKSELF
    api.gameId = self.gameID;
    api.maiyou_gameid = self.maiyou_gameid;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        self.dataDic = request.data;
        
        //显示代金券数量
        if ([self.dataDic[@"voucher_info"][@"num"] integerValue] > 0)
        {
            self.headerView.showVoucherNum.text = [NSString stringWithFormat:@"%@  ", self.dataDic[@"voucher_info"][@"num"]];
        }
        self.headerView.showVoucherNum.hidden = ![self.dataDic[@"voucher_info"][@"num"] boolValue];
        //礼包数量
        self.headerView.showGiftNum.text = [NSString stringWithFormat:@"%@  ", self.dataDic[@"packsNum"]];
        self.headerView.showGiftNum.hidden = ![self.dataDic[@"packsNum"] boolValue];
        //活动数量
        self.headerView.showActivityNum.text = [NSString stringWithFormat:@"%@  ", self.dataDic[@"activityNum"]];
        self.headerView.showActivityNum.hidden = ![self.dataDic[@"activityNum"] boolValue];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshGift" object:self.dataDic];
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)refreshGameDetail
{
    //移除支付页面
    for (UIView * view in UIApplication.sharedApplication.keyWindow.subviews)
    {
        if ([view isKindOfClass:NSClassFromString(@"PayAlertView")])
        {
            [view removeFromSuperview];
            break;
        }
    }
    //刷新游戏详情页面
    [self gameDetailApiRequest:^(BOOL isSuccess) {
            
    }];
}

- (void)hiddenTipBarView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.barView.alpha = 0;
    }completion:^(BOOL finished) {
        [self.barView removeFromSuperview];
    }];
}

#pragma mark - 添加圆形加载view
- (void)addCircleProgressView
{
    [self.view layoutIfNeeded];
    
    CGFloat view_width = 30;
    MyColorCircle *circle = [[MyColorCircle alloc]initWithFrame:CGRectMake((self.downLoad.width - view_width) / 2 + 10, (self.downLoad.height - view_width) / 2, view_width, view_width)];
    circle.hidden = YES;
    [self.downLoad addSubview:circle];
    self.circleView = circle;
    
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.downLoad.mas_centerX);
        make.centerY.equalTo(self.downLoad.mas_centerY);
        make.width.equalTo(@(view_width));
        make.height.equalTo(@(view_width));
    }];
}

#pragma mark - 添加分享按钮
- (void)creatRightButton
{
    UIView * rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW - 40, self.navBar.height - 25 - (44 - 25) / 2, 25, 25)];
    [self.navBar addSubview:rightView];
    
    NSArray * array = @[@"share_icon"];
    for (int i = 0; i < array.count; i ++)
    {
        UIButton * shareButton = [[UIButton alloc] initWithFrame:CGRectMake((25 + 10) * i, 0, 25, 25)];
        shareButton.tag = i + 10;
        [shareButton setImage:[UIImage imageNamed:array[i]] forState:0];
        [shareButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:shareButton];
    }
}

#pragma mark - 获取游戏详情
- (void)gameDetailApiRequest:(RequestData)block
{
    GameDetailApi *api = [[GameDetailApi alloc] init];
    //    WEAKSELF
    api.gameId = self.gameID;
    api.maiyou_gameid = self.maiyou_gameid;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleNoticeSuccess:api];
        if (block) block(YES);
    } failureBlock:^(BaseRequest * _Nonnull request) {
    }];
}

- (void)handleNoticeSuccess:(GameDetailApi *)api
{
    if (api.success == 1)
    {
        NSInteger is_collected = [api.data[@"game_info"][@"is_collected"] integerValue];
        self.collectionButton.selected = is_collected == 0 ? NO : YES;
        self.bottomView.hidden = NO;
        self.dataDic = api.data;
        //记录进入游戏详情事件
        [self gameDetailClickStatistic:@"GameDetailViewAppear"];
        
        //是否显示云游的提示蒙层
//        if ([self.dataDic[@"game_info"][@"isOpenCloudApp"] boolValue])
//        {
//            [self showGuidePageView];
//        }
        //是否提示评论的提示
        if ([YYToolModel getUserdefultforKey:@"CommentMakgeMoney"] == NULL && !self.barView)
        {
            self.barView = [[TipBarView alloc] initWithFrame:CGRectMake(kScreenW - 85, kScreenH - hxBottomMargin - 49 - 21, 72.5, 21)];
            [[YYToolModel getCurrentVC].navigationController.view addSubview:self.barView];
        }
        
        self.showDownSize = @"";
        
        self.vipButton_left.constant = 0;
        self.vipButton_width.constant = 0;
//        CGFloat width = self.commitButton.left - self.contactServices.right - 30;
        self.isReservedSucess = [api.data[@"game_info"][@"is_reserved"] integerValue];
        NSInteger allow_download = [api.data[@"game_info"][@"allow_download"] integerValue];
        CGFloat starting_time = [self.dataDic[@"game_info"][@"starting_time"] doubleValue];
        CGFloat nowTime = [[NSDate getNowTimeTimestamp] doubleValue];
        BOOL cloud = [self.dataDic[@"game_info"][@"isOpenCloudApp"] boolValue];
        NSInteger game_species_type = [api.data[@"game_info"][@"game_species_type"] integerValue];
        
        if (game_species_type == 3)
        {
            self.downLoad.hidden = false;
            [self.downLoad setAttributedTitle:[self getAttrTitle:@"开始".localized] forState:0];
        }
        else
        {
            if (starting_time > nowTime)
            {
                self.downLoad.hidden = false;
                self.downLoad.backgroundColor = [UIColor colorWithHexString:@"#2893FF"];
                if (self.isReservedSucess) {
                    [self setAttributed:true forButton:self.downLoad];
                }else{
                    [self setAttributed:false forButton:self.downLoad];
                }
            }
            else
            {
                //0 企业签 1 至尊签 2 两者
                NSInteger new_down_type = [self.dataDic[@"game_info"][@"new_down_type"] integerValue];
                if (new_down_type == 0)
                {
                    self.downLoad.hidden = false;
                    [self.downLoad setTitle:@"下载".localized forState:0];
                    
                }
                else if (new_down_type == 1)
                {
                    if (cloud)
                    {
                        if (allow_download)
                        {
                            self.downLoad.hidden = YES;
                            [self.previewButton setImage:MYGetImage(@"detail_cloud_btn") forState:0];
                            [self.previewButton setTitle:@"极速云玩".localized forState:UIControlStateNormal];
                            
                            [self.previewButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
                            
                            [self.vipButton setTitle:@"至尊版下载".localized forState:UIControlStateNormal];
                        }
                        else
                        {
                            self.downLoad.hidden = false;
                            [self.downLoad setTitle:@"极速云玩".localized forState:0];
                        }
                    }
                    else
                    {
                        self.downLoad.hidden = false;
                        [self.downLoad setTitle:@"至尊版下载".localized forState:0];
                    }
                }
                else if (new_down_type == 2)
                {
                    self.downLoad.hidden = YES;
                    
                    [self.previewButton setTitle:@"下载".localized forState:UIControlStateNormal];
                    
                    [self.vipButton setTitle:@"至尊版下载".localized forState:UIControlStateNormal];
                }
            }
        }
        
        [self.view layoutIfNeeded];
        
        //ios安装plist
        NSString * ios_url = self.dataDic[@"game_info"][@"game_url"][@"ios_url"];
        if ([ios_url isKindOfClass:[NSNull class]] || !ios_url) {
            self.routeUrl = @"";
        }
        else
        {
            self.routeUrl = ios_url;
        }

        [self setupPageVC];
        
        NSArray * kaifuArray = api.data[@"game_info"][@"kaifu_info"];
        BOOL isKaifu = NO;
        CGFloat currentTime = [NSDate getNowTimeTimestamp].floatValue;
        for (NSDictionary * dic in kaifuArray)
        {
            if (currentTime < [dic[@"starttime"] floatValue])
            {
                isKaifu = YES;
                break;
            }
        }
        //有未开服
        if (isKaifu)
        {
            self.badgeView.hidden = NO;
        }
        //显示交易的数量
//        NSInteger total = [api.data[@"game_trade_num"] integerValue];
//        if (total == 0)
//        {
            self.tradeCount.hidden = YES;
//        }
//        else
//        {
//            self.tradeCount.hidden = NO;
//            (total > 999) ? [self.tradeCount setTitle:@"999+" forState:0] : [self.tradeCount setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)total] forState:0];
//        }
        //显示礼包的数量
        NSInteger gitTotal = [api.data[@"game_info"][@"gift_bag_list"] count];
        if (gitTotal == 0)
        {
            self.giftCount.hidden = YES;
        }
        else
        {
//            if ([self.dataDic[@"ab_test_game_detail_welfare"] intValue] == 2)
//            {
                self.giftCount.hidden = YES;
//            }
//            else
//            {
//                self.giftCount.hidden = NO;
//            }
//            (gitTotal > 999) ? [self.giftCount setTitle:@"999+" forState:0] : [self.giftCount setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)gitTotal] forState:0];
        }
        //显示评论的数量
//        NSInteger commitTotal = [api.data[@"game_comment_num"] integerValue];
//        if (commitTotal == 0)
//        {
            self.commitCount.hidden = YES;
//        }
//        else
//        {
//            self.commitCount.hidden = NO;
//            (commitTotal > 999) ? [self.commitCount setTitle:@"999+" forState:0] : [self.commitCount setTitle:[NSString stringWithFormat:@"%ld", (long)commitTotal] forState:0];
//            (commitTotal > 999) ? (self.commitCount.titleLabel.font = [UIFont boldSystemFontOfSize:9]) : (self.commitCount.titleLabel.font = [UIFont boldSystemFontOfSize:9]);
//        }
        
        
       if ([self.dataDic[@"voucher_info"][@"num"] integerValue] > 0 && self.isVoucherCenter)
       {
           [self.headerView getVoucherList:YES];
       }
        if (self.c.intValue == 1)
        {
            UIButton * button = (UIButton *)[self.view viewWithTag:[DeviceInfo shareInstance].isGameVip ? 30 : 10];
            [self downGameAction:button];
        }
        if (self.isShowActivityAlert == true){
            [JXTAlertView showAlertViewWithTitle:@"温馨提示" message:@"是否前往查看活动详情" cancelButtonTitle:@"是" buttonIndexBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    MyActivityDetailController *detailVC = [[MyActivityDetailController alloc] init];
                    detailVC.news_id = self.newid;
                    detailVC.gameInfo = self.dataDic[@"game_info"];
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
            } otherButtonTitles:@"否", nil];
        }
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

//获取签名或者下载的显示进度
- (void)getResignOrDownloadProgress
{
    //签名中更新下载状态
    if ([MyResignTimeTask sharedManager].isResign && [[MyResignTimeTask sharedManager].maiyou_gameid isEqualToString:self.dataDic[@"game_info"][@"maiyou_gameid"]])
    {
        [self.downLoad setAttributedTitle:[self getAttrTitle:[MyResignTimeTask sharedManager].statusTitle] forState:0];
        self.downLoad.backgroundColor = [UIColor clearColor];
        [MyResignTimeTask sharedManager].delegate = self;
        [self IpaResignFinishBlock];
    }
    else
    {
        //获取下载状态
        [self getGameDownloadStatus:[YCDownloadManager itemWithFileId:self.dataDic[@"game_info"][@"maiyou_gameid"]]];
    }
}
#pragma mark - 获取下载状态
- (void)getGameDownloadStatus:(YCDownloadItem *)item
{
    if (item)
    {
        //根据现在状态显示
        self.downloadItem = item;
        self.downloadItem.delegate = self;
        switch (self.downloadItem.downloadStatus) {
            case YCDownloadStatusPaused:
                self.downLoad.backgroundColor = [UIColor clearColor];
                [self.progressView setProgress:(float)self.downloadItem.downloadedSize / self.downloadItem.fileSize];
                [self.downLoad setAttributedTitle:[self getAttrTitle:@"继续".localized] forState:0];
                break;
            case YCDownloadStatusDownloading:
                self.downLoad.backgroundColor = [UIColor clearColor];
                [self.progressView setProgress:(float)self.downloadItem.downloadedSize / self.downloadItem.fileSize];
                [self.downLoad setAttributedTitle:[self getAttrTitle:[DeviceInfo shareInstance].isGameVip ? @"下载中".localized : @"暂停".localized] forState:0];
                break;
            case YCDownloadStatusFinished:
                self.downLoad.backgroundColor = bg_color;
                [self.downLoad setAttributedTitle:[self getAttrTitle:[YYToolModel getIpaDownloadStatus:self.downloadItem]] forState:0];
                break;
            case YCDownloadStatusWaiting:
                self.downLoad.backgroundColor = [UIColor clearColor];
                [self.progressView setProgress:(float)self.downloadItem.downloadedSize / self.downloadItem.fileSize];
                [self.downLoad setAttributedTitle:[self getAttrTitle:@"等待中".localized] forState:0];
                break;
            case YCDownloadStatusUnknow:
                [self removeFailedAndUnknowItem];
                break;
            case YCDownloadStatusFailed:
                [self removeFailedAndUnknowItem];
                break;
            
            default:
            break;
        }
        //当时至尊版和暂停状态删除当前任务
        if ([DeviceInfo shareInstance].isGameVip && (self.downloadItem.downloadStatus == YCDownloadStatusPaused || self.downloadItem.downloadStatus == YCDownloadStatusFailed))
        {
            [self removeFailedAndUnknowItem];
        }
    }
    else
    {
        NSInteger game_species_type = [self.dataDic[@"game_info"][@"game_species_type"] integerValue];
        if (game_species_type == 3)
        {
            [self.downLoad setAttributedTitle:[self getAttrTitle:@"开始".localized] forState:0];
        }
        else
        {
            NSString * str = [NSString stringWithFormat:@"%@\n%@", @"下载".localized, self.dataDic[@"game_info"][@"game_size"][@"ios_size"]];
            if (!self.isReserve && [self.dataDic[@"game_info"][@"new_down_type"] integerValue] == 0)
            {
                str = self.showDownSize;
            }
//            //a面显示默认，b面不显示游戏大小
//            if ([self.dataDic[@"ab_test_game_detail_download"] integerValue] == 2)
//            {
//                str = @"下载".localized;
//            }
            [self.downLoad setAttributedTitle:[self getAttrTitle:str] forState:0];
        }
    }
}

/**  删除失败状态/未知状态下的任务  */
- (void)removeFailedAndUnknowItem
{
    [YCDownloadManager stopDownloadWithItem:self.downloadItem];
    self.downLoad.backgroundColor = bg_color;
    [self.downLoad setAttributedTitle:[self getAttrTitle:self.showDownSize] forState:0];
}

#pragma mark - 分享
- (void)rightButtonAction:(UIButton *)sender
{
    //未登录先登录
    if (![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    //分享按钮点击统计
    [self gameDetailClickStatistic:@"ClickToShareGame"];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
         [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    NSDictionary * dic = self.dataDic[@"game_info"];
    NSString * title = dic[@"game_name"];
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"game_image"][@"thumb"]]];
    NSString * desc = dic[@"game_introduce"];
    NSString * url = dic[@"url"];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:[UIImage imageWithData:data]];
    //设置网页地址
    shareObject.webpageUrl = url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [MBProgressHUD showToast:@"分享失败" toView:self.view];
        }
        else
        {
            [YJProgressHUD showSuccess:@"分享成功" inview:self.view];
        }
    }];
}

#pragma mark — 收藏/取消收藏
- (void)collectionGameRequest:(BOOL)isCancle
{
    if (isCancle)
    {
        self.collectionButton.selected = NO;
        
        MyCancleCollectionGameApi * api = [[MyCancleCollectionGameApi alloc] init];
        api.maiyou_gameid = self.dataDic[@"game_info"][@"maiyou_gameid"];
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
         {
             if (api.success == 1)
             {
                 [MBProgressHUD showSuccess:@"取消成功" toView:self.view];
             }
             else
             {
                 [MBProgressHUD showToast:api.error_desc toView:self.view];
             }
         } failureBlock:^(BaseRequest * _Nonnull request) {
             
         }];
    }
    else
    {
        self.collectionButton.selected = YES;
        
        MyCollectionGameApi * api = [[MyCollectionGameApi alloc] init];
        api.maiyou_gameid = self.dataDic[@"game_info"][@"maiyou_gameid"];
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request)
         {
             if (api.success == 1)
             {
                 //记录游戏收藏成功事件
                 [MobClick event:@"CollectionGame" attributes:@{@"gameName":self.dataDic[@"game_info"][@"game_name"]}];
                 
                 [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
             }
             else
             {
                 [MBProgressHUD showToast:api.error_desc toView:self.view];
             }
         } failureBlock:^(BaseRequest * _Nonnull request) {
             
         }];
    }
}

- (NSArray *)getArrayVCs
{
    GameDetailKaifuViewController *vc_1   = [[GameDetailKaifuViewController alloc] init];
    vc_1.dataDic = self.dataDic;
    
    GameDetailTradeViewController *vc_2   = [[GameDetailTradeViewController alloc] init];
    vc_2.dataDic = self.dataDic;
    
    GameDetailCommentViewController *vc_3 = [[GameDetailCommentViewController alloc] init];
    vc_3.dataDic = self.dataDic;
        
    MyGameDetailIntroBController *vc_4 = [[MyGameDetailIntroBController alloc] init];
    vc_4.dataDic = self.dataDic;
    
//    MyWelfareViewController * vc_5 = [[MyWelfareViewController alloc] init];
//    vc_5.hiddenNavBar = YES;
//    vc_5.dataDic = self.dataDic;
//    vc_5.downloadGameBlock = ^{
//        UIButton * button = (UIButton *)[self.view viewWithTag:[DeviceInfo shareInstance].isGameVip ? 30 : 10];
//        [self downGameAction:button];
//    };
    
    return @[vc_4, vc_3, vc_1, vc_2];
}

- (NSArray *)getArrayTitles
{
    return @[@"详情".localized, @"评论".localized, @"开服表".localized, @"交易".localized];
}

- (void)setupPageVC
{
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionCenter;
    configration.headerViewCouldScale = YES;
    /// 控制tabbar 和 nav
    configration.showTabbar = YES;
    configration.showNavigation = NO;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = NO;
    configration.showBottomLine = YES;
    configration.bottomLineHeight = 0.5;
    configration.bottomLineBgColor = [UIColor colorWithHexString:@"#DEDEDE"];
    configration.normalItemColor = [UIColor colorWithHexString:@"#666666"];
    configration.selectedItemColor = [UIColor colorWithHexString:@"#282828"];
    configration.itemFont = [UIFont systemFontOfSize:14];
    configration.selectedItemFont = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    configration.lineHeight = 3;
    configration.lineCorner = 1.5;
    configration.lineColor = MAIN_COLOR;
    configration.lineLeftAndRightMargin = (kScreenW / [self getArrayVCs].count - 18) / 2;
    configration.lineBottomMargin = 5;
    configration.isGameDetail = YES;
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = kStatusBarAndNavigationBarHeight;
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    vc.headerView = [self creatHeaderView];
    
    //福利页面要显示的数据全是空
    NSArray * game_feature_list = self.dataDic[@"game_info"][@"game_feature_list"];
    BOOL isContent = NO;
    for (int i = 0; i < game_feature_list.count; i ++)
    {
        NSDictionary * dic = game_feature_list[i];
        if ((i == 0 || i == 1) && [dic[@"content"] isBlankString])
        {
            isContent = YES;
        }
    }
    vc.pageIndex =  0;
    vc.view.frame = CGRectMake(0, 0, kScreenW, kScreenH - hxBottomMargin - 49);
    
//    CGFloat button_width = kScreenW / [self getArrayTitles].count;
    
//    UIView * badgeView = [[UIView alloc] initWithFrame:CGRectMake(button_width + button_width / 2 + 20, 7, 6, 6)];
//    badgeView.hidden = YES;
//    badgeView.layer.cornerRadius = badgeView.height / 2;
//    badgeView.layer.masksToBounds = YES;
//    badgeView.backgroundColor = [UIColor redColor];
//    [vc.scrollMenuView addSubview:badgeView];
//    self.badgeView = badgeView;

//    for (int i = 0; i < 3; i ++)
//    {
//        NSInteger index = i == 0 ? 1 : i + 2;
//        UIButton * showCount = [[UIButton alloc] initWithFrame:CGRectMake(button_width * index + button_width / 2 + 13, 5, 27, 15)];
//        [showCount setBackgroundImage:[UIImage imageNamed:@"comment_normal_bg"] forState:0];
//        [showCount setBackgroundImage:[UIImage imageNamed:@"comment_press_bg"] forState:UIControlStateSelected];
//        [showCount setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//        [showCount setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [showCount setTitle:@"0" forState:0];
//        showCount.titleLabel.font = [UIFont boldSystemFontOfSize:9];
//        showCount.hidden = YES;
//        [vc.scrollMenuView addSubview:showCount];
//        if (i == 0)
//        {
//            self.giftCount = showCount;
//        }
//        else
//        {
//            i == 2 ? (self.tradeCount = showCount) : (self.commitCount = showCount);
//        }
//    }
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    
    UIButton * button = [UIControl creatButtonWithFrame:CGRectMake(kScreenW - 60, kScreenH - kTabbarSafeBottomMargin - 49 - 86, 55, 55) backgroundColor:[UIColor colorWithHexString:@"#00D280"] title:@"进入\n权限".localized titleFont:[UIFont systemFontOfSize:14 weight:UIFontWeightBold] actionBlock:^(UIControl *control) {
        [self gmButtonClick:self.GMButton];
    }];
    button.tag = 21;
    button.layer.cornerRadius = button.height / 2;
    button.layer.masksToBounds = YES;
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:button];
    self.GMButton = button;
    button.hidden = [self.dataDic[@"game_info"][@"game_species_type"] integerValue] == 4 ? NO : YES;
    
    [self.view addSubview:self.navBar];
}

- (UIView *)creatHeaderView
{
    GameDetailHeaderView * view = [[GameDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 190.5 + kScreenW  * 9 / 16)];
    view.currentVC = self;
    view.dataDic = self.dataDic;
    self.headerView = view;
    return view;
}

#pragma mark - YNPageViewControllerDataSource
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index
{
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[GameDetailKaifuViewController class]])
    {
        return [(GameDetailKaifuViewController *)vc kaifuView].tableView;
    }
    else if ([vc isKindOfClass:[GameDetailTradeViewController class]])
    {
        return [(GameDetailTradeViewController *)vc tradeView].tableView;
    }
    else if ([vc isKindOfClass:[GameDetailCommentViewController class]])
    {
        return [(GameDetailCommentViewController *)vc commitView].tableView;
    }
    else if ([vc isKindOfClass:[HGGameGiftListController class]])
    {
        return [(HGGameGiftListController *)vc tableView];
    }
    else if ([vc isKindOfClass:[MyWelfareViewController class]])
    {
        return [(MyWelfareViewController *)vc tableView];
    }
    else if ([vc isKindOfClass:[MyGameDetailIntroBController class]])
    {
        return [(MyGameDetailIntroBController *)vc tableView];
    }
    else
    {
        return [(HGGameDetailIntroController *)vc tableView];
    }
}

#pragma mark - YNPageViewControllerDelegate
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    
    if (contentOffset > -self.headerView.height / 2)
    {
        if (self.headerView.player.playStatus == SJVideoPlayerPlayStatusPlaying)
        {
            [self.headerView.player pause];
        }
    }
    else if (contentOffset <= -self.headerView.height)
    {
        if (self.headerView.player.playStatus == SJVideoPlayerPlayStatusPaused)
        {
            [self.headerView.player play];
        }
    }
    [self refreshScrollOffsetY:progress];
}

- (void)pageViewController:(YNPageViewController *)pageViewController
                 didScroll:(UIScrollView *)scrollView
                  progress:(CGFloat)progress
                 formIndex:(NSInteger)fromIndex
                   toIndex:(NSInteger)toIndex
{
//    MYLog(@"========================%ld ---- %f", (long)toIndex, progress);
    
    if (progress == 0 && toIndex == 1)
    {
        self.giftCount.selected = YES;
//        [self gameDetailClickStatistic:[self.dataDic[@"ab_test_game_detail_welfare"] integerValue] == 1 ? @"ClickTheGamePackageTab" : @"ClickTheGameWelfareTab"];
    }
    else
    {
        self.giftCount.selected = NO;
    }
    
    if (progress == 0 && toIndex == 4)
    {
        self.tradeCount.selected = YES;
        [self gameDetailClickStatistic:@"ClickTheGameTradingTab"];
    }
    else
    {
        self.tradeCount.selected = NO;
    }
    
    if (progress == 0 && toIndex == 3)
    {
        self.commitCount.selected = YES;
        [self gameDetailClickStatistic:@"ClickTheGameCommentTab"];
    }
    else
    {
        self.commitCount.selected = NO;
    }
    
    if (progress == 0 && toIndex == 0)
    {
        [self gameDetailClickStatistic:@"ClickTheGameDetailsTab"];
    }
    else if (progress == 0 && toIndex == 2)
    {
        [self gameDetailClickStatistic:@"ClickOnTheServerOpeningTimeTab"];
    }
}

#pragma mark — 接收首页tableView滚动的距离
- (void)refreshScrollOffsetY:(CGFloat)progress
{
    if(progress <= 0.01){
        //往上滑动，透明度为0
        self.navBar.backgroundColor = [UIColor clearColor];
        self.navBar.alpha = 1;
        self.navBar.title = @"";
    }else{
        self.navBar.backgroundColor = MAIN_COLOR;
        //滑动到距离为100的时候才显示完全
        if (progress >= 1)
        {
            self.navBar.alpha = 1;
            return;
        }
        self.navBar.title = self.dataDic[@"game_info"][@"game_name"];
        self.navBar.alpha = progress;
    }
}

#pragma mark - 联系客服
- (IBAction)contactServicesAction:(id)sender
{
    if (![YYToolModel isAlreadyLogin]) return;
    
    UIButton * btn = sender;
    if (btn == self.collectionButton1)
    {
        [self.collectionButton buttonAnimationWithZoom];
    }
    //收藏按钮点击统计
    [self gameDetailClickStatistic:@"ClickToFavoriteGames"];

    [self collectionGameRequest:self.collectionButton.selected];
}

#pragma mark - 点评
- (IBAction)commitGameAction:(id)sender
{
    if (![YYToolModel isAlreadyLogin]) return;
    
    //点评按钮点击统计
    [self gameDetailClickStatistic:@"ClickTheGameCommentTab"];
    GameCommitViewController *detailVC = [[GameCommitViewController alloc]init];
    detailVC.topicId = [self.dataDic objectForKey:@"comment_topic_id"];
    detailVC.commentSuccess = ^{

    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 下载
- (IBAction)downGameAction:(id)sender
{
    //记录游戏详情点击下载按钮事件
    [self gameDetailClickStatistic:@"GameDetailDownload"];
    
//    [self stageABTest];
    
    NSDictionary * game_info = [self.dataDic objectForKey:@"game_info"];
    NSInteger game_species_type = [[game_info objectForKey:@"game_species_type"] integerValue];
    NSDictionary * game_url = [game_info objectForKey:@"game_url"];
    NSString * ios_url = [game_url objectForKey:@"ios_url"];
    if (game_species_type == 3)
    {
        //没有登陆
        if (![YYToolModel isAlreadyLogin]) return;
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
        LoadGameViewController * game = [[LoadGameViewController alloc] init];
        game.load_url = [NSString stringWithFormat:@"%@&username=%@", ios_url, userName];
        game.hidesBottomBarWhenPushed = YES;
        game.hiddenNavBar = YES;
        [self.navigationController pushViewController:game animated:YES];
    }
    else
    {
        UIButton * button = sender;
        if (button.tag == 30)
        {
            //至尊版到期必须购买，下载必须登录
            if (![YYToolModel islogin])
            {
                LoginViewController *VC = [[LoginViewController alloc] init];
                VC.hidesBottomBarWhenPushed = YES;
                VC.quickLoginBlock = ^{
                    [self gameDetailApiRequest:nil];
                };
                [self.navigationController pushViewController:VC animated:YES];
                return;
            }
            //第一次获取udid后触发这个监听方法
            [DeviceInfo shareInstance].getUDIDSuccessBlock = ^(NSString *udid) {
                //满足条件直接点击安装，没有满足条件点击购买
                BOOL isPayUser = [[game_info objectForKey:@"isPayUser"] boolValue];
                if (!isPayUser)
                {
                    [self gameDetailApiRequest:^(BOOL isSuccess) {
                        //至尊版弹窗相关逻辑处理
                        [self vipTipViewClick];
                    }];
                }
                else
                {
                    [self installVipGame];
                }
            };
            //先获取udid，获取到udid之后，再看符不符合至尊版下载条件
            NSString * udid = [DeviceInfo shareInstance].deviceUDID;
            if (udid == NULL)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[DeviceInfo shareInstance].getUdidUrl] options:@{} completionHandler:nil];
            }
            else
            {
                //至尊版弹窗相关逻辑处理
                [self vipTipViewClick];
            }
            return;
        }
        else
        {
            DownloadPromptViewController * prompt = [[DownloadPromptViewController alloc] initWithGameIcon:self.dataDic[@"game_info"][@"game_image"][@"thumb"]];
            [self presentViewController:prompt animated:YES completion:nil];
            
            [self getMessageApiRequest];
        }
    }
}

#pragma mark - 云游或者普通版下载
- (IBAction)cloudBtnClick:(UIButton *)sender
{
    if ([sender.titleLabel.text rangeOfString:@"极速云玩".localized].location != NSNotFound)
    {
        [self startCloudGame];
    }
    else
    {
        DownloadPromptViewController * prompt = [[DownloadPromptViewController alloc] initWithGameIcon:self.dataDic[@"game_info"][@"game_image"][@"thumb"]];
        [self presentViewController:prompt animated:YES completion:nil];
        
        [self getMessageApiRequest];
    }
}

#pragma mark - 预约或者开始游戏
- (IBAction)installAction:(UIButton *)sender
{
    NSDictionary * game_info = [self.dataDic objectForKey:@"game_info"];
    NSInteger game_species_type = [[game_info objectForKey:@"game_species_type"] integerValue];
    NSDictionary * game_url = [game_info objectForKey:@"game_url"];
    NSString * ios_url = [game_url objectForKey:@"ios_url"];
    if (game_species_type == 3)
    {
        //没有登陆
        if (![YYToolModel isAlreadyLogin]) return;
        
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
        LoadGameViewController * game = [[LoadGameViewController alloc] init];
        game.load_url = [NSString stringWithFormat:@"%@&username=%@", ios_url, userName];
        game.hidesBottomBarWhenPushed = YES;
        game.hiddenNavBar = YES;
        [self.navigationController pushViewController:game animated:YES];
    }
    else
    {
        if ([sender.titleLabel.text rangeOfString:@"极速云玩".localized].location != NSNotFound)
        {
            [self startCloudGame];
        }
        else if ([sender.titleLabel.text rangeOfString:@"至尊版下载".localized].location != NSNotFound)
        {
            UIButton * button = [self.view viewWithTag:30];
            [self downGameAction:button];
        }
        else if ([sender.titleLabel.text rangeOfString:@"下载".localized].location != NSNotFound)
        {
            DownloadPromptViewController * prompt = [[DownloadPromptViewController alloc] initWithGameIcon:self.dataDic[@"game_info"][@"game_image"][@"thumb"]];
            [self presentViewController:prompt animated:YES completion:nil];
            
            [self getMessageApiRequest];
        }
        else
        {
            if (![YYToolModel isAlreadyLogin]) return;
            
            if (!self.isReservedSucess)
            {
                [self reserveGame];
            }
            else
            {
                [self cancleReserveGame];
            }
        }
    }
}

//开始云游
- (void)startCloudGame
{
    if (![YYToolModel isAlreadyLogin]) return;
    
    [MyAOPManager gameRelateStatistic:@"ClickToPlayGameOncloud" GameInfo:self.dataDic[@"game_info"] Add:@{}];
    
    CloudappCheckAvailableAPI * api = [[CloudappCheckAvailableAPI alloc] init];
    api.isShow = YES;
    api.gameid = self.dataDic[@"game_info"][@"maiyou_gameid"];
    api.username = [YYToolModel getUserdefultforKey:@"user_name"];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success) {
            BOOL isValid = [request.data[@"isValid"] boolValue];
            [self cloudGameTips:isValid];
        }else{
            [MBProgressHUD showToast:api.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)cloudGameTips:(BOOL)isStart
{
    CloudGameDescViewController * cloud = [[CloudGameDescViewController alloc]initWithStatus:isStart];
    cloud.isStart = isStart;
    cloud.btnClick = ^(BOOL type) {
        if (!type)
        {
            UIButton * button = [self.view viewWithTag:30];
            [self downGameAction:button];
        }
        else
        {
            [MyAOPManager relateStatistic:@"ClickCloudPlay" Info:@{@"gameName":self.dataDic[@"game_info"][@"game_name"]}];
            CloudGameViewController * webView = [[CloudGameViewController alloc] init];
            webView.url = [NSString stringWithFormat:@"%@?token=%@&userid=%@&username=%@&gameid=%@",[DeviceInfo shareInstance].cloudappIndexUrl,[YYToolModel getUserdefultforKey:TOKEN], [YYToolModel getUserdefultforKey:USERID], [YYToolModel getUserdefultforKey:@"user_name"], self.dataDic[@"game_info"][@"maiyou_gameid"]];
            if (@available(iOS 13.0, *)) {
                webView.modalPresentationStyle = UIModalPresentationFullScreen;
            }
            [self presentViewController:webView animated:YES completion:nil];
        }
    };
    [self presentViewController:cloud animated:YES completion:nil];
    
}

//安装弹窗处理
- (void)vipTipViewClick
{
    //满足条件直接点击安装，没有满足条件点击购买
    if (![self.dataDic[@"game_info"][@"isPayUser"] boolValue])
    {
        [self loadVipLoadView];
    }
    else
    {
        //修改支付逻辑，是付费用户直接下载至尊版
        [self installVipGame];
        
        /** 之前企业签的盒子 判断是否为真正的至尊版 2022.04.08 */
        
//        //首先判断udid有没有绑定证书
//        if (![self.dataDic[@"game_info"][@"isBindUdid"] boolValue])
//        {
//            [self loadVipLoadView];
//        }
//        else
//        {
//            //如果本地存储的udid为空，则认为为至尊版个签盒子，否则该盒子是企业签的盒子
//            NSString *udid = [YYToolModel getUserdefultforKey:MILU_UDID];
//            if (udid == NULL)
//            {
//                [self installVipGame];//真正的至尊版盒子
//            }
//            else
//            {
//                [self loadVipLoadView];//企业签获取udid后的假至尊版
//            }
//        }
    }
}
//安装前提示
- (void)loadVipLoadView
{
    MyBuyVipViewController * buy = [[MyBuyVipViewController alloc] init];
    buy.dataDic = self.dataDic[@"game_info"];
    [self presentViewController:buy animated:YES completion:^{
        
    }];
    
//    MyShowVipDownTipView * tipView = [[MyShowVipDownTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
//    tipView.supremePayUrl = self.dataDic[@"game_info"][@"supremePayUrl"];
//    tipView.isBindUdid = [self.dataDic[@"game_info"][@"isBindUdid"] boolValue];
//    tipView.isUserVip  = [self.dataDic[@"game_info"][@"isPayUser"] boolValue];
//    tipView.vipAppInstallBlock = ^{
//        [self installVipGame];
//    };
//    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
}

//安装至尊版游戏
- (void)installVipGame
{
    NSString * vip_ios_url = self.dataDic[@"vip_ios_url"];
    if (![YYToolModel isBlankString:vip_ios_url])
    {
        [MBProgressHUD showMessage:@"加载中" toView:[UIApplication sharedApplication].delegate.window];
        NSURL* nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@", vip_ios_url]];
        [[UIApplication sharedApplication] openURL:nsUrl options:@{} completionHandler:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window];
        });
    }
    else
    {
//        NSDictionary * dic = self.dataDic;
//        NSDictionary * vipDic = @{@"maiyou_gameid":dic[@"game_info"][@"maiyou_gameid"], @"down_type":[NSString stringWithFormat:@"%d", 2], @"vip_ios_url":vip_ios_url};
//        [[YYToolModel shareInstance] loadingView:vipDic];
        WEAKSELF
        MyDownloadProgressController * download = [[MyDownloadProgressController alloc] initWithGameInfo:self.dataDic];
        [self presentViewController:download animated:YES completion:nil];
    }
}

//ipa包签名完成
- (void)IpaResignFinishBlock
{
    WEAKSELF
    [YYToolModel shareInstance].VipDownUrl = ^(NSInteger code, NSString *url) {
        [[MyResignTimeTask sharedManager] timingPause];
        if (code == 1 && url.length > 0) {
            //获取VIP盒子游戏下载地址
            weakSelf.routeUrl = url;
            [weakSelf creatNewTask];
            self.downLoad.backgroundColor = [UIColor clearColor];
            [self.downLoad setAttributedTitle:[self getAttrTitle:@"下载中".localized] forState:0];
        }
        else{
            YCDownloadItem * item = [YCDownloadManager itemWithFileId:self.dataDic[@"game_info"][@"maiyou_gameid"]];
            //删除当前任务
            [YCDownloadManager stopDownloadWithItem:item];
            self.downLoad.backgroundColor = bg_color;
            [self.downLoad setAttributedTitle:[self getAttrTitle:self.showDownSize] forState:0];
        }
    };
}

//获取下载包的状态
- (BOOL)existedGameIpaInstallOrOpen
{
    if (self.downloadItem)
    {
        NSDictionary * downDic = [NSJSONSerialization JSONObjectWithData:self.downloadItem.extraData options:0 error:nil];
        switch (self.downloadItem.downloadStatus) {
            case YCDownloadStatusFinished:
            {
                NSString * bundleid = downDic[@"my_ios_bundleid"];
                if ([YYToolModel isInstalled:bundleid IsList:NO]) {
                    [YYToolModel openApp:bundleid];
                }
                else
                {
                    [YYToolModel installAppForItem:self.downloadItem];
                }
            }
                break;
                
            case YCDownloadStatusPaused:
                if (![[DeviceInfo shareInstance] isGameVip])
                {
                    [YCDownloadManager resumeDownloadWithItem:self.downloadItem];
                    [self.downLoad setAttributedTitle:[self getAttrTitle:@"暂停".localized] forState:0];
                }
                break;
                
            case YCDownloadStatusDownloading:
                if (![[DeviceInfo shareInstance] isGameVip])
                {
                    [YCDownloadManager pauseDownloadWithItem:self.downloadItem];
                    [self.downLoad setAttributedTitle:[self getAttrTitle:@"继续".localized] forState:0];
                }
                break;
                
            case YCDownloadStatusWaiting:
                [self.downLoad setAttributedTitle:[self getAttrTitle:@"等待中".localized] forState:0];
                break;
                
            default:
                break;
        }
        return YES;
    }
    return NO;
}

//下载ipa包的处理
- (void)downloadGameIPa
{
    //当正在分包不可点击
    if (self.isPackage)  return;
    
    NSString * url = self.routeUrl;
    if ([url hasPrefix:Down_Game_Url])
    {
        if ([DeviceInfo shareInstance].downLoadStyle == 0)//先下载再安装
        {
            self.downLoad.backgroundColor = [UIColor clearColor];
            [self.downLoad setAttributedTitle:[self getAttrTitle:[DeviceInfo shareInstance].isGameVip ? @"下载中".localized : @"暂停".localized] forState:0];
            [YYToolModel getIpaDownloadUrl:url Data:self.dataDic[@"game_info"] Vc:self IsPackage:NO];
            //获取当前新的任务
            [self getCurrentDownTask];
        }
        else
        {
            [self GameDownloadList];
        }
    }
    else
    {
        if ([DeviceInfo shareInstance].downLoadStyle == 0)//先下载再安装
        {
            if (![DeviceInfo shareInstance].isGameVip)
            {
                //显示加载圈
                self.circleView.hidden = NO;
                [self.downLoad setAttributedTitle:[self getAttrTitle:@""] forState:0];
            }
            else
            {
                [self.navigationController pushViewController:[DownLoadManageController new] animated:YES];
            }
            
            //开始下载,做假下载处理
            [YYToolModel getIpaDownloadUrl:url Data:self.dataDic[@"game_info"] Vc:self IsPackage:NO];
        }
        if (![DeviceInfo shareInstance].isGameVip)
        {
            //未分包开始分包
            [self getMessageApiRequest];
        }
    }
}

#pragma mark - 获取安装plist
- (void)getMessageApiRequest
{
    self.isPackage = YES;
    
    GameDownLoadApi *api = [[GameDownLoadApi alloc] init];
//    if ([DeviceInfo shareInstance].downLoadStyle == 1)
    api.isShow = YES;
    api.requestTimeOutInterval = 600;
    api.urls = self.dataDic[@"game_info"][@"game_url"][@"ios_url"];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handle1NoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:@"正在下载安装包，请稍后再试！" toView:self.view];
    }];
}

- (void)handle1NoticeSuccess:(GameDownLoadApi *)api
{
    self.isPackage = NO;
    if (api.success == 1)
    {
        self.routeUrl = api.data[@"url"];
        
        if ([self.routeUrl containsString:@"url="])
        {
//            if ([DeviceInfo shareInstance].downLoadStyle == 0)
//            {
//                self.circleView.hidden = YES;
//                self.downLoad.backgroundColor = [UIColor clearColor];
//                [self.downLoad setAttributedTitle:[self getAttrTitle:@"暂停".localized] forState:0];
//                [self creatNewTask];
//            }
//            else
//            {
                [self GameDownloadList];
//            }
        }
        else
        {
            [self GameDownloadList];
        }
    }
    else
    {
        if ([DeviceInfo shareInstance].downLoadStyle == 0)
        {
            self.circleView.hidden = YES;
            //分包未完成,删除预下载任务
            self.downLoad.backgroundColor = bg_color;
            [self.downLoad setAttributedTitle:[self getAttrTitle:self.showDownSize] forState:0];
            YCDownloadItem * item = [YCDownloadManager itemWithFileId:self.dataDic[@"game_info"][@"maiyou_gameid"]];
            //删除当前任务
            [YCDownloadManager stopDownloadWithItem:item];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    }
}

- (void)creatNewTask
{
    YCDownloadItem * item = [YCDownloadManager itemWithFileId:self.dataDic[@"game_info"][@"maiyou_gameid"]];
    //删除当前任务
    [YCDownloadManager stopDownloadWithItem:item];
    //重新创建任务下载
    [YYToolModel getIpaDownloadUrl:self.routeUrl Data:self.dataDic[@"game_info"] Vc:self IsPackage:YES];
    //获取当前新的任务
    [self getCurrentDownTask];
    //刷新下载页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartDownloadIpa" object:nil];
}

//获取当前下载任务
- (void)getCurrentDownTask
{
    self.downloadItem = [YCDownloadManager itemWithFileId:self.dataDic[@"game_info"][@"maiyou_gameid"]];
    self.downloadItem.delegate = self;
}

#pragma mark - 加载plist安装
- (void)GameDownloadList
{
    [YYToolModel loadIpaUrl:self Url:self.routeUrl];
}

#pragma mark - YCDownloadItemDelegate
- (void)downloadItemStatusChanged:(nonnull YCDownloadItem *)item
{
    MYLog(@"downloadStatus : %lu", (unsigned long)item.downloadStatus);
    
    [self getGameDownloadStatus:item];
    
    if (item.downloadStatus == YCDownloadStatusFinished)
    {
        [YYToolModel installAppForItem:item];
    }
}

- (void)downloadItem:(nonnull YCDownloadItem *)item downloadedSize:(int64_t)downloadedSize totalSize:(int64_t)totalSize
{
    CGFloat percent = (float)downloadedSize / totalSize;
    self.isPackage = NO;
    //解决没有进度,percent = 0/0 = 1
    if (totalSize == 0 && percent == 1) return;
    if ([DeviceInfo shareInstance].isGameVip)
    {
        CGFloat progress = [MyResignTimeTask sharedManager].resginProgress;
        self.progressView.progress = percent * (1 - progress) + progress;
    }
    else
    {
        self.progressView.progress = percent;
    }
    
    MYLog(@"=======%f---下载大小%lld", (float)downloadedSize / totalSize, downloadedSize);
}

#pragma mark - MyResignTimeTaskDelegate
- (void)resignTimingWithDownIpa:(CGFloat)progress
{
    self.progressView.progress = progress;
    
    [self.downLoad setAttributedTitle:[self getAttrTitle:[MyResignTimeTask sharedManager].statusTitle] forState:0];
}

#pragma mark - GM
- (IBAction)gmButtonClick:(id)sender
{
    if (![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    UIButton * button = sender;
    if (button.tag == 20)
    {
        !self.isReservedSucess ? [self reserveGame] : [self cancleReserveGame];
    }
    else
    {
        [self getSmallAccount];
    }
    
//    NSString * userName = [YYToolModel getUserdefultforKey:@"user_name"];
//    NSString * userid   = @"mysa_1558522221_2eS6";
//
//    NSString * sign = [NSString stringWithFormat:@"%@.273.10002.%@", userid, @"CnTTvUVITuMEtmge3asAqRiDKbG2ieRe"];
//    NSString * url = [NSString stringWithFormat:@"http://h5.zyttx.com/gmapi/center.html?user_id=%@&username=%@&game_id=273&channel_id=10002&sign=%@", userid, userName, [sign md5HashToLower32Bit]];
//    PayViewController * webview = [PayViewController new];
//    webview.requestStr = url;
//    webview.gameid = @"2383";
//    [self.navigationController pushViewController:webview animated:YES];
}

#pragma mark - 获取小号列表
- (void)getSmallAccount
{
    SmallAccountApi * api = [[SmallAccountApi alloc] init];
    api.count = 50;
    api.pageNumber = 1;
    api.maiyou_gameid = self.dataDic[@"game_info"][@"maiyou_gameid"];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSMutableArray * array = [NSMutableArray array];
            self.xhListArray = [NSMutableArray arrayWithArray:request.data[@"xh_list"]];
            for (NSDictionary * dic in request.data[@"xh_list"])
            {
                [array addObject:dic[@"xh_alias"]];
            }
            
            if (array.count > 0)
            {
                [self showSmallAccount:array];
            }
            else
            {
                [MBProgressHUD showToast:@"暂无小号列表" toView:self.view];
            }
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

//显示小号列表
- (void)showSmallAccount:(NSArray *)array
{
    [BRStringPickerView showStringPickerWithTitle:@"请选择小号".localized dataSource:array defaultSelValue:array[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index)
     {
         NSDictionary * dic = self.xhListArray[index];
         NSString * userName = [YYToolModel getUserdefultforKey:@"user_name"];
         NSString * xh_username   = dic[@"xh_username"];
         NSString * cp_channel_id = self.dataDic[@"game_info"][@"cp_channel_id"];
         NSString * cp_game_id    = self.dataDic[@"game_info"][@"cp_game_id"];
         
         NSString * sign = [NSString stringWithFormat:@"%@.%@.%@.%@", xh_username, cp_game_id, cp_channel_id, @"CnTTvUVITuMEtmge3asAqRiDKbG2ieRe"];
         NSString * url = [NSString stringWithFormat:@"http://h5.zyttx.com/gmapi/center.html?user_id=%@&username=%@&game_id=%@&channel_id=%@&sign=%@", xh_username, userName, cp_game_id, cp_channel_id, [sign md5HashToLower32Bit]];
         PayViewController * webview = [PayViewController new];
         webview.requestStr = url;
         webview.gameid = self.dataDic[@"game_info"][@"maiyou_gameid"];
         webview.xh_username = xh_username;
         [self.navigationController pushViewController:webview animated:YES];
     }];
}
#pragma mark — 预约游戏
- (void)reserveGame
{
    self.previewButton.userInteractionEnabled = false;
    self.vipButton.userInteractionEnabled = false;
    self.downLoad.userInteractionEnabled = false;
    MyGameReserveApi * api = [[MyGameReserveApi alloc] init];
    api.game_id = self.dataDic[@"game_info"][@"maiyou_gameid"];
    api.reserveType = @"0";
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        self.downLoad.userInteractionEnabled = true;
        if (request.success == 1)
        {
            [MBProgressHUD showSuccess:@"预约成功" toView:self.view];
            [self setAttributed:YES forButton:self.downLoad];
            self.isReservedSucess = YES;
            
            if (self.previewAction) {
                self.previewAction(YES);
            }
            
            NSString * time = [NSString stringWithFormat:@"%.f", [self.dataDic[@"game_info"][@"starting_time"] doubleValue] - 30 * 60];
            [self registerLocalNotification:[self timeDateWithTimeIntervalString:time]];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        self.downLoad.userInteractionEnabled = true;
    }];
}

#pragma mark — 取消预约游戏
- (void)cancleReserveGame
{
    self.previewButton.userInteractionEnabled = false;
    self.vipButton.userInteractionEnabled = false;
    self.downLoad.userInteractionEnabled = false;
    MyCancleGameReserveApi * api = [[MyCancleGameReserveApi alloc] init];
    api.game_id = self.dataDic[@"game_info"][@"maiyou_gameid"];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        self.downLoad.userInteractionEnabled = true;
        if (request.success == 1)
        {
            [MBProgressHUD showSuccess:@"取消成功" toView:self.view];
            [self setAttributed:NO forButton:self.downLoad];
            self.isReservedSucess = NO;
            
            if (self.previewAction) {
                self.previewAction(NO);
            }
            [self deleteNoticeState:self.dataDic[@"game_info"][@"game_id"]];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        self.downLoad.userInteractionEnabled = true;
    }];
}

- (void)setAttributed:(BOOL)attributed forButton:(UIButton *)btn{
    if (!attributed)
    {
        NSString * title = [NSString stringWithFormat:@"%@\n%@%@", @"开启首发提醒".localized, [NSDate dateWithFormat:@"MM月dd日 HH:mm" WithTS:[self.dataDic[@"game_info"][@"starting_time"] doubleValue]], @"首发".localized];
        [btn setAttributedTitle:[self getAttrTitle:title] forState:0];
    }
    else
    {
        [btn setAttributedTitle:[self getAttrTitle:@"取消提醒".localized] forState:0];
    }
}

- (NSMutableAttributedString *)getAttrTitle:(NSString *)title
{
    if (title == nil)
    {
        title = @"";
    }
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:title];
    if ([title containsString:@"\n"])
    {
        NSRange range = [title rangeOfString:@"\n"];
        NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor whiteColor]};
        [firstPart setAttributes:firstAttributes range:NSMakeRange(range.location, firstPart.length - range.location)];
    }
    else
    {
        NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]};
        [firstPart setAttributes:firstAttributes range:NSMakeRange(0, firstPart.length)];
    }
    return firstPart;
}

//取消提醒
- (void)deleteNoticeState:(NSString *)value {
    
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[@"gameId"];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil && [info isEqualToString:value]) {
                
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                NSLog(@"cancle notification");
                break;
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginReloadUrl" object:nil];
}

// 设置本地通知
- (void)registerLocalNotification:(NSDate*)alertTime {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = alertTime;
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    notification.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    // 时区
    //    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    //    notification.repeatInterval = kCFCalendarUnitSecond;
    notification.repeatInterval = 0;
    
    // 通知内容 《你来吗英雄》双线一区 开服啦，快来体验吧
    //    notification.alertBody = [NSString stringWithFormat:@"%@开服提醒",dic[@"kaifuname"]];
    notification.alertBody = [NSString stringWithFormat:@"%@%@，%@", @"尊敬的用户，您预约的新游：".localized, self.dataDic[@"game_info"][@"game_name"], @"即将开服，请及时下载，祝您玩的开心！".localized];
    
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    //    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
    NSDictionary *userDict = @{@"key":[NSString stringWithFormat:@"%@%@，%@", @"尊敬的用户，您预约的新游：".localized, self.dataDic[@"game_info"][@"game_name"], @"即将开服，请及时下载，祝您玩的开心！".localized],
        @"gameId":self.dataDic[@"game_info"][@"game_id"],
        @"start_date": self.dataDic[@"game_info"][@"starting_time"],
        @"new_image": self.dataDic[@"game_info"][@"game_image"][@"thumb"]};
    notification.userInfo = userDict;
    
    [self writeNotifyMessage:userDict];
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = 0;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = 0;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)writeNotifyMessage:(NSDictionary*)userInfo
{
    //我的消息数据源
    NSDictionary *dic = @{@"title":userInfo[@"key"],
                          @"type":@"preview",
        @"gameId": userInfo[@"gameId"],
        @"time":[self getCurrentTimes],
        @"start_date": [userInfo objectForKey:@"start_date"],
        @"new_image": [userInfo objectForKey:@"new_image"]};
    NSData *data = [FileUtils readDataFromFile:@"PushPreview"];
    NSMutableArray *retArray = nil;
    if (data) {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:(NSArray *)jsonObject];
        NSMutableArray *array =[NSMutableArray arrayWithArray:arr];
        for (NSDictionary *dict in array) {
            if ([dict[@"gameId"] isEqualToString:userInfo[@"gameId"]])
            {
                [arr removeObject:dict];
                NSLog(@"KaifuOpen---过滤重复消息=========成功");
            }
        }
        
        retArray = [[NSMutableArray alloc] initWithArray:arr];
        [retArray addObject:dic];
    }else {
        retArray = [[NSMutableArray alloc] init];
        [retArray addObject:dic];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:retArray options:NSJSONWritingPrettyPrinted error:nil];
    BOOL ret =  [FileUtils writeDataToFile:@"Push" data:jsonData];
    if (ret) {
        NSLog(@"DetailGame---开服通知写入=========成功");
    }else{
        NSLog(@"DetailGame---开服通知写入=========不成功");
        [retArray addObject:dic];
        
    }
}

-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

- (NSDate*)timeDateWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString *str = [formatter stringFromDate:date];
    NSDate *newData = [formatter dateFromString:str];
    NSLog(@"new date=%@",newData);
    return date;
}

//游戏详情页面的相关操作统计
- (void)gameDetailClickStatistic:(NSString *)methodName
{
//    NSString * str = [self.dataDic[@"ab_test_stage"] integerValue] == 1 ? self.dataDic[@"ab_test_game_detail_welfare"] : self.dataDic[@"ab_test_game_detail_download"];
//    NSDictionary * dic = @{@"ab_test1":[NSString stringWithFormat:@"%@", str]};
//    [MyAOPManager gameRelateStatistic:methodName GameInfo:self.dataDic[@"game_info"] Add:[self.dataDic[@"is_985"] boolValue] ? dic : @{}];
}

- (void)stageABTest
{
    StageABTestApi * api = [[StageABTestApi alloc] init];
    api.name = @"ab_test_game_detail_download";
    api.value = [NSString stringWithFormat:@"%@", self.dataDic[[self.dataDic[@"ab_test_stage"] integerValue] == 1 ? @"ab_test_game_detail_welfare" : @"ab_test_game_detail_download"]];
    api.ab_test_stage = [NSString stringWithFormat:@"%@", self.dataDic[@"ab_test_stage"]];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - 显示云游戏的引导
- (void)showGuidePageView
{
    NSString * userCenter = [YYToolModel getUserdefultforKey:@"GameCloudGuidePageView"];
    if (userCenter != NULL)
    {
        return;
    }
    [YYToolModel saveUserdefultValue:@"1" forKey:@"GameCloudGuidePageView"];
    
    NSMutableArray * array = [NSMutableArray array];
    CGRect frame = CGRectMake(kScreenW - 75, kScreenW * 9 / 16 + 17.5, 60, 60);
    WKStepMaskModel * model = [WKStepMaskModel creatModelWithFrame:frame cornerRadius:0 step:1];
    [array addObject:model];
    
    MyCloudGameGuideView * guideView = [[MyCloudGameGuideView alloc] initWithModels:array];
    [guideView showInView:[UIApplication sharedApplication].keyWindow isShow:YES];
}

@end
