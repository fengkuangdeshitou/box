//
//  HomeListTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2017/9/2.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "HomeListTableViewCell.h"
#import "GameDownLoadApi.h"
#import "SmallAccountApi.h"
#import "NSString+Phone.h"

#import "PayViewController.h"
#import "LoadGameViewController.h"
#import "MyTransferDescController.h"

@interface HomeListTableViewCell () <YCDownloadItemDelegate, MyResignTimeTaskDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentIcon_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabel_left;
@property (weak, nonatomic) IBOutlet UIImageView *commentIcon;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourTagLabel;
@property (strong, nonatomic) NSString *routeURL;
@property (weak, nonatomic) IBOutlet UILabel *showDiscount;
@property (weak, nonatomic) IBOutlet UIImageView *discountBg;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *anthImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authImageView_width;

@property (strong, nonatomic) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UIButton *buttonGradient;
@property (weak, nonatomic) IBOutlet UILabel *disHot;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UIImageView *gameRankImge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankIndex_width;
@property (weak, nonatomic) IBOutlet UILabel *showTime1;
@property (weak, nonatomic) IBOutlet UILabel *showTime2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLoadBtn_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabel_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downButton_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downButton_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeBackView_width;
@property (weak, nonatomic) IBOutlet UIView *timeBackView;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) MyColorCircle *circleView;
@property (nonatomic, strong) YCDownloadItem * downloadItem;
/**  是否分包  */
@property (nonatomic, assign) BOOL isPackage;
@property (nonatomic, strong) NSMutableArray * xhListArray;

@end

@implementation HomeListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.disHot.layer.borderColor = [UIColor colorWithHexString:@"#FF00FF"].CGColor;
    self.disHot.layer.borderWidth = 0.5;
    
    self.gameRankImge.hidden = YES;
    self.rankIndext.hidden = YES;
    self.rankIndex_right.constant = 3;
    self.rankIndex_width.constant = 0;
    
    [self addCircleProgressView];
}

- (void)setListType:(NSString *)listType
{
    _listType = listType;
    
    self.downLoadBtn_width.constant = 55;
    self.progressView.hidden   = YES;
    self.buttonGradient.hidden = NO;
    self.timeBackView.hidden = YES;
    self.timeBackView_width.constant = 0;
    if (listType.integerValue == 2 || listType.integerValue == 3)
    {
        self.rankIndex_right.constant = 8;
        self.rankIndext.hidden = NO;
        self.rankIndex_width.constant = 15;
        self.downLoadBtn_width.constant = 55;
        
        self.rankIndext.text = [NSString stringWithFormat:@"%ld", (self.listType.integerValue == 2) ? (_indexPath.row + 4) : _indexPath.row + 1];
    }
    else
    {
        if (listType.integerValue == 0)
        {
            self.buttonGradient.hidden = YES;
            self.downLoadBtn_width.constant = 0;
        }
        self.progressView.hidden   = YES;
        self.rankIndex_right.constant = 0;
        self.rankIndex_width.constant = 0;
    }
    //前三显示图片数字
    if (self.listType.integerValue == 3 && _indexPath.row < 3)
    {
        self.gameRankImge.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_game_rank%ld", _indexPath.row + 1]];
        
        self.gameRankImge.hidden = NO;
        self.rankIndext.hidden = YES;
        self.rankIndext.textColor = [UIColor colorWithHexString:@"#F80000"];
    }
    else
    {
        self.gameRankImge.hidden = YES;
        self.rankIndext.hidden = NO;
        self.rankIndext.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    
    if (self.listType.intValue == 4)
    {
        self.downLoadBtn_width.constant = 55;
        [self.buttonGradient setTitle:@"转游" forState:0];
    }
    
    //今日首发显示首发时间
    if (self.listType.intValue == 6)
    {
        self.timeBackView_width.constant = 45;
        self.timeBackView.hidden = NO;
    }
    
    //搜搜显示正版授权
    BOOL is_ocp = [self.data[@"is_ocp"] boolValue];
    if (self.listType.intValue == 7 && is_ocp)
    {
//        NSString * gifPathSource = [[NSBundle mainBundle] pathForResource:@"auth" ofType:@"gif"];
//        [self.anthImageView sd_setImageWithURL:[NSURL fileURLWithPath:gifPathSource]];
//        self.authImageView_width.constant = 69;
        self.anthImageView.hidden = NO;
    }
    else
    {
        self.anthImageView.hidden = YES;
//        self.authImageView_width.constant = 0;
    }
}

#pragma mark - 添加圆形加载view
- (void)addCircleProgressView
{
    CGFloat view_width = self.buttonGradient.height;
    MyColorCircle *circle = [[MyColorCircle alloc]initWithFrame:CGRectMake((self.buttonGradient.width - view_width) / 2, (self.buttonGradient.height - view_width) / 2, view_width, view_width)];
    circle.hidden = YES;
    [self.buttonGradient addSubview:circle];
    self.circleView = circle;
}

#pragma mark - 下载
- (IBAction)downLoadPress:(id)sender
{
    if ([DeviceInfo shareInstance].isOpenYouthMode)
    {
        [MBProgressHUD showToast:@"当前为青少年模式暂不能访问！" toView:[YYToolModel getCurrentVC].view];
        return;
    }
    //转游
    if (self.listType.intValue == 4)
    {
        MyTransferDescController * desc = [MyTransferDescController new];
        desc.dataDic = self.data;
        [[YYToolModel getCurrentVC].navigationController pushViewController:desc animated:YES];
        return;
    }
    
    if (self.listType.intValue == 5)
    {
        if (self.downloadBtnClick) {
            self.downloadBtnClick(self.data);
        }
    }
    else
    {
        //记录游戏列表点击下载按钮事件
        [MyAOPManager relateStatistic:@"GameListDownload" Info:@{@"gameName":self.data[@"game_name"]}];
    }
    
    if ([self.data[@"game_species_type"] integerValue] == 3)
    {
        //没有登陆
        if (![YYToolModel islogin])
        {
            LoginViewController * login = [LoginViewController new];
            login.hidesBottomBarWhenPushed = YES;
            [self.currentVC.navigationController pushViewController:login animated:YES];
            return;
        }
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
        LoadGameViewController * game = [[LoadGameViewController alloc] init];
        game.load_url = [NSString stringWithFormat:@"%@&username=%@", self.data[@"gama_url"][@"ios_url"], userName];
        game.hidesBottomBarWhenPushed = YES;
        game.hiddenNavBar = YES;
        [self.currentVC.navigationController pushViewController:game animated:YES];
    }
    else if ([self.data[@"game_species_type"] integerValue] == 4 && self.data[@"isGMAssisant"])//GM游戏助手
    {
        [self selectXh_username];
    }
    else
    {
        //如果已经下载或者安装直接打开
        if ([self existedGameIpaInstallOrOpen])
        {
            return;
        }
        else if ([MyResignTimeTask sharedManager].isResign)
        {
            [MBProgressHUD showToast:@"已有正在下载任务，请稍后！" toView:self.currentVC.view];
            return;
        } //1、默认下载方式；2、通过safari打开vip_ios_url；3、内部下载安装游戏（个人签名版）
        NSDictionary * dic = self.data;
        NSString * down_type = dic[@"down_type"];
        NSString * vip_ios_url = dic[@"vip_ios_url"];
        if (!down_type) {
            down_type = @"";
        }
        if (!vip_ios_url) {
            vip_ios_url = @"";
        }
        NSDictionary * vipDic = @{@"maiyou_gameid":dic[@"maiyou_gameid"], @"down_type":[NSString stringWithFormat:@"%@", down_type], @"vip_ios_url":vip_ios_url};
        BOOL isVip = [[YYToolModel shareInstance] vipDownloadGame:vipDic];
        WEAKSELF
        [YYToolModel shareInstance].VipDownUrl = ^(NSInteger code, NSString *url) {
            [[MyResignTimeTask sharedManager] timingPause];
            if (code == 1 && url.length > 0) {
                //获取VIP盒子游戏下载地址
                weakSelf.routeURL = url;
                [MyResignTimeTask sharedManager].url = url;
                [weakSelf creatNewTask];
            }
            else
            {
                YCDownloadItem * item = [YCDownloadManager itemWithFileId:dic[@"maiyou_gameid"]];
                //删除当前任务
                [YCDownloadManager stopDownloadWithItem:item];
                self.buttonGradient.backgroundColor = MAIN_COLOR;
                [self.buttonGradient setTitle:@"下载".localized forState:0];
            }
            [self.tableView reloadData];
        };
        if (isVip)
        {
            self.buttonGradient.backgroundColor = [UIColor clearColor];
            [self.buttonGradient setTitle:@"打包中".localized forState:0];
            [MyResignTimeTask sharedManager].delegate = self;
            [[MyResignTimeTask sharedManager] timingStart];
            [MyResignTimeTask sharedManager].maiyou_gameid = dic[@"maiyou_gameid"];
            [MyResignTimeTask sharedManager].dataDic = self.data;
        }
        
        if (down_type.integerValue != 2) {
            //下载ipa包的处理
            [self downloadGameIPa];
        }
    }
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
                }
                //                    [self.buttonGradient setTitle:@"暂停" forState:0];
                break;
                
            case YCDownloadStatusDownloading:
                if (![[DeviceInfo shareInstance] isGameVip])
                {
                    [YCDownloadManager pauseDownloadWithItem:self.downloadItem];
                }
                //                    [self.buttonGradient setTitle:@"继续" forState:0];
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
    
    NSInteger down_style = [DeviceInfo shareInstance].downLoadStyle;
    NSString * url = self.routeURL;
    if ([url hasPrefix:Down_Game_Url])
    {
        if (down_style == 0)//先下载再安装
        {
            self.buttonGradient.backgroundColor = [UIColor clearColor];
            [self.buttonGradient setTitle:[DeviceInfo shareInstance].isGameVip ? @"下载中".localized : @"暂停".localized forState:0];
            
            [YYToolModel getIpaDownloadUrl:url Data:self.data Vc:self.currentVC IsPackage:NO];
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
        if (down_style == 0)//先下载再安装
        {
            if (![DeviceInfo shareInstance].isGameVip)
            {
                //显示加载圈
                self.circleView.hidden = NO;
                [self.buttonGradient setTitle:@"" forState:0];
            }
            else
            {
                DownLoadManageController * manager = [DownLoadManageController new];
                manager.hidesBottomBarWhenPushed = YES;
                [self.currentVC.navigationController pushViewController:manager animated:YES];
            }
            //开始下载,做假下载处理
            [YYToolModel getIpaDownloadUrl:url Data:self.data Vc:self.currentVC IsPackage:NO];
        }
        if (![DeviceInfo shareInstance].isGameVip)
        {
            //未分包开始分包
            [self getMessageApiRequest];
        }
    }
    //通知首页下载管理是否显示红点
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetAllNoDownloadList" object:nil];
}

- (void)selectXh_username
{
    if (![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    [self getSmallAccount];
}

#pragma mark - 获取小号列表
- (void)getSmallAccount
{
    SmallAccountApi * api = [[SmallAccountApi alloc] init];
    api.count = 50;
    api.pageNumber = 1;
    api.maiyou_gameid = self.data[@"maiyou_gameid"];
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
                [MBProgressHUD showToast:@"暂无小号列表"];
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
    [BRStringPickerView showStringPickerWithTitle:@"请选择小号" dataSource:array defaultSelValue:array[0] isAutoSelect:NO resultBlock:^(id selectValue, NSInteger index)
     {
         NSDictionary * dic = self.xhListArray[index];
         NSString * userName = [YYToolModel getUserdefultforKey:@"user_name"];
         NSString * xh_username   = dic[@"xh_username"];
         NSString * cp_channel_id = self.data[@"cp_channel_id"];
         NSString * cp_game_id    = self.data[@"cp_game_id"];
         NSString * maiyou_gameid = self.data[@"maiyou_gameid"];
         
         NSString * sign = [NSString stringWithFormat:@"%@.%@.%@.%@", xh_username, cp_game_id, cp_channel_id, @"CnTTvUVITuMEtmge3asAqRiDKbG2ieRe"];
         NSString * url = [NSString stringWithFormat:@"http://h5.zyttx.com/gmapi/center.html?user_id=%@&username=%@&game_id=%@&channel_id=%@&sign=%@", xh_username, userName, cp_game_id, cp_channel_id, [sign md5HashToLower32Bit]];
         PayViewController * webview = [PayViewController new];
         webview.hidesBottomBarWhenPushed = YES;
         webview.requestStr = url;
         webview.gameid = maiyou_gameid;
         webview.xh_username = xh_username;
         [self.currentVC.navigationController pushViewController:webview animated:YES];
     }];
}

//获取当前下载任务
- (void)getCurrentDownTask
{
    self.downloadItem = [YCDownloadManager itemWithFileId:self.data[@"maiyou_gameid"]];
    self.downloadItem.delegate = self;
}

#pragma mark - 获取安装plist
- (void)getMessageApiRequest
{
    self.isPackage = YES;
    
    GameDownLoadApi *api = [[GameDownLoadApi alloc] init];
    if ([DeviceInfo shareInstance].downLoadStyle == 1)
        api.isShow = YES;
    api.urls = self.routeURL;
    api.requestTimeOutInterval = 60;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handle1NoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handle1NoticeSuccess:(GameDownLoadApi *)api
{
    self.isPackage = NO;
    if (api.success == 1)
    {
        self.routeURL = api.data[@"url"];
        if ([self.routeURL containsString:@"url="])
        {
            if ([DeviceInfo shareInstance].downLoadStyle == 0)
            {
                self.circleView.hidden = YES;
                self.buttonGradient.backgroundColor = [UIColor clearColor];
                [self.buttonGradient setTitle:@"暂停".localized forState:0];
                
                [self creatNewTask];
            }
            else
            {
                [self GameDownloadList];
            }
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
            self.buttonGradient.backgroundColor = MAIN_COLOR;
            [self.buttonGradient setTitle:@"下载".localized forState:0];
            YCDownloadItem * item = [YCDownloadManager itemWithFileId:self.data[@"maiyou_gameid"]];
            //删除当前任务
            [YCDownloadManager stopDownloadWithItem:item];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:[UIApplication sharedApplication].delegate.window];
        }
    }
}

- (void)creatNewTask
{
    NSDictionary * dic = self.data;
    NSString * url = self.routeURL;
    NSString * maiyou_gameid = self.data[@"maiyou_gameid"];
    //如果是至尊版盒子下载获取当前存储的下载信息
    if ([DeviceInfo shareInstance].isGameVip)
    {
        dic = [MyResignTimeTask sharedManager].dataDic;
        url = [MyResignTimeTask sharedManager].url;
        maiyou_gameid = [MyResignTimeTask sharedManager].maiyou_gameid;
    }
    
    YCDownloadItem * item = [YCDownloadManager itemWithFileId:maiyou_gameid];
    //删除当前任务
    [YCDownloadManager stopDownloadWithItem:item];
    //重新创建任务下载
    [YYToolModel getIpaDownloadUrl:url Data:dic Vc:self.currentVC IsPackage:YES];
    //获取当前新的任务
    [self getCurrentDownTask];
    //刷新下载页面
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StartDownloadIpa" object:nil];
}

#pragma mark - 加载plist安装
- (void)GameDownloadList
{
    [YYToolModel loadIpaUrl:self.currentVC Url:self.routeURL];
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
    
    MYLog(@"=======%f", (float)downloadedSize / totalSize);
}

#pragma mark - MyResignTimeTaskDelegate
- (void)resignTimingWithDownIpa:(CGFloat)progress
{
    self.progressView.progress = progress;
    
    [self.buttonGradient setTitle:[MyResignTimeTask sharedManager].statusTitle forState:0];
}

#pragma mark - 将数据赋值
- (void)setModelDic:(NSDictionary *)dic
{
    dic = [dic deleteAllNullValue];
    self.data = dic;
    NSString * ios_url = dic[@"gama_url"][@"ios_url"];
    if ([ios_url isKindOfClass:[NSNull class]] || !ios_url)
    {
        self.routeURL = @"";
    }
    else
    {
        self.routeURL = ios_url;
    }
    
    NSString *url = [[dic objectForKey:@"game_image"] objectForKey:@"thumb"];
    [self.imageViews yy_setImageWithURL:[NSURL URLWithString:url] placeholder:MYGetImage(@"game_icon")];
    
    NSString *class_type = dic[@"game_classify_type"];
    if ([class_type hasPrefix:@" "])
    {
        class_type = [class_type substringFromIndex:1];
    }
    self.titleLabel.text = dic[@"game_name"];
    
    //返回福利标签或是一句话  如果有详情介绍，显示，没有显示送VIP送福利
    if ([YYToolModel isBlankString:dic[@"introduction"]])
    {
        self.introduction.hidden = YES;
        self.firstTagLabel.hidden  = YES;
        self.secondTagLabel.hidden = YES;
        self.thirdTagLabel.hidden = YES;
        self.fourTagLabel.hidden  = YES;
        NSString *desc = dic[@"game_desc"];
        if ([YYToolModel isBlankString:desc])
        {
            //当没有描述和两个label
            self.titleLabel_top.constant = 11;
        }
        else
        {
            NSArray *tagArray = [desc componentsSeparatedByString:@"+"];
            for (int i = 0; i < tagArray.count; i ++)
            {
                NSString * str = [NSString stringWithFormat:@"%@", tagArray[i]];
                str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (i == 0)
                {
                    self.firstTagLabel.hidden = NO;
                    self.firstTagLabel.text  = str;
                }
                else if (i == 1)
                {
                    self.secondTagLabel.hidden = NO;
                    self.secondTagLabel.text = str;
                }
                else if (i == 2)
                {
                    self.thirdTagLabel.hidden = NO;
                    self.thirdTagLabel.text = str;
                }
                else if (i == 3)
                {
                    self.fourTagLabel.hidden = NO;
                    self.fourTagLabel.text = str;
                }
            }
        }
    }
    else
    {
        self.introduction.hidden = NO;
        _introduction.text = dic[@"introduction"];
        self.firstTagLabel.hidden = YES;
        self.secondTagLabel.hidden = YES;
        self.thirdTagLabel.hidden = YES;
        self.fourTagLabel.hidden = YES;
    }
    
   /*******  判断是模块（数据需求与其他列表不同）*******/
    //BT游戏
    if ([dic[@"game_species_type"] isEqualToString:@"1"] || [dic[@"game_species_type"] isEqualToString:@"4"])
    {
        self.discountBg.hidden = YES;
        self.showDiscount.hidden = YES;
        self.disHot.hidden = YES;
    }
    else if ([dic[@"game_species_type"] isEqualToString:@"2"])//折扣
    {
        NSString * disStr = dic[@"discount"];
        CGFloat   value = [disStr floatValue];
        if (value < 1 && value > 0)
        {
            value = value * 10;
            self.showDiscount.text = [NSString stringWithFormat:@" %.1f%@ ", value, @"折".localized];
            self.discountBg.hidden = NO;
            self.showDiscount.hidden = NO;
        }
        else
        {
            self.showDiscount.text = @"";
            self.discountBg.hidden = YES;
            self.showDiscount.hidden = YES;
        }
        //判断热推是否有数据
        NSString * hotStr = dic[@"label"];
        if ([YYToolModel isBlankString:hotStr])
        {
            self.disHot.text = @"";
            self.disHot.hidden = YES;
        }
        else
        {
            self.disHot.hidden = NO;
            self.disHot.text = dic[@"label"];
        }
    }
    else if([dic[@"game_species_type"] isEqualToString:@"3"])//H5
    {
        self.discountBg.hidden = YES;
        self.showDiscount.hidden = YES;
        self.disHot.hidden = YES;
    }
    
    //是否显示评论数量
//    if ([dic[@"game_comment_num"] integerValue] > 0)
//    {
//        detailStr = [NSString stringWithFormat:@"%@%@%@ · %@", dic[@"game_comment_num"], @"条", @"评论", class_type];
//        self.commentIcon_width.constant = 15;
//        self.detailLabel_left.constant = 5;
//        self.commentIcon.hidden = NO;
//    }
//    else
//    {
        //不显示评论数量
        self.commentIcon_width.constant = 0;
        self.detailLabel_left.constant = 0;
        self.commentIcon.hidden = YES;
//    }
    
    //根据下载状态显示
    if ([self.data[@"game_species_type"] integerValue] == 3)//H5游戏
    {
        [self.buttonGradient setTitle:@"开始".localized forState:0];
        self.progressView.hidden = YES;
    }
    else if ([self.data[@"game_species_type"] integerValue] == 4 && self.data[@"isGMAssisant"])//GM游戏
    {
        self.downLoadBtn_width.constant = 70;
        self.buttonGradient.backgroundColor = [UIColor colorWithHexString:@"#00D280"];
        [self.buttonGradient setTitle:@"进入权限".localized forState:0];
        self.buttonGradient.layer.borderColor = [UIColor colorWithHexString:@"#00D280"].CGColor;
        [self.buttonGradient setTitleColor:[UIColor whiteColor] forState:0];
        self.progressView.hidden = NO;
    }
    else
    {
        self.progressView.hidden = NO;
        //更新签名下载状态
        if ([MyResignTimeTask sharedManager].isResign && [[MyResignTimeTask sharedManager].maiyou_gameid isEqualToString:self.data[@"maiyou_gameid"]])
        {
            self.buttonGradient.backgroundColor = [UIColor clearColor];
            [self.buttonGradient setTitleColor:[UIColor whiteColor] forState:0];
            [self.buttonGradient setTitle:[MyResignTimeTask sharedManager].statusTitle forState:0];
            [MyResignTimeTask sharedManager].delegate = self;
        }
        else
        {
            //获取下载状态
            [self getGameDownloadStatus:[YCDownloadManager itemWithFileId:self.data[@"maiyou_gameid"]]];
            
            //云游的游戏显示去云游
            if ([self.data[@"isOpenCloudApp"] boolValue])
            {
                [self.buttonGradient setTitle:@"去云游".localized forState:0];
                self.buttonGradient.backgroundColor = MAIN_COLOR;
            }
        }
    }
    
    //为了适配开服列表，显示开服信息
    if (self.kaifuType.integerValue == 10 || self.kaifuType.integerValue == 20)
    {
        self.introduction.hidden = YES;
        self.firstTagLabel.hidden = NO;
        self.secondTagLabel.hidden = YES;
        self.thirdTagLabel.hidden = YES;
        self.fourTagLabel.hidden = YES;
        
        self.commentIcon_width.constant = 0;
        self.detailLabel_left.constant = 0;
        self.commentIcon.hidden = YES;
        self.firstTagLabel.text = dic[@"kaifu_name"];
    }
    else if (self.kaifuType.integerValue == 30)
    {
        self.introduction.hidden = YES;
        self.firstTagLabel.hidden = NO;
        self.secondTagLabel.hidden = NO;
        self.thirdTagLabel.hidden = YES;
        self.fourTagLabel.hidden = YES;
        
        self.commentIcon_width.constant = 0;
        self.detailLabel_left.constant = 0;
        self.commentIcon.hidden = YES;
        self.firstTagLabel.text = dic[@"kaifu_name"];
        self.secondTagLabel.text = [NSDate dateWithFormat:@"MM-dd HH:mm" WithTS:[dic[@"kaifu_start_date"] doubleValue]];
    }
    //显示游戏的属性，类型·大小
    NSString * gameSize = [YYToolModel isBlankString:dic[@"game_size"][@"ios_size"]] ? dic[@"gama_size"][@"ios_size"] : dic[@"game_size"][@"ios_size"];
    if ([dic[@"game_species_type"] integerValue] == 3 || [gameSize isEqualToString:@"0 MB"])
    {
       self.detailLabel.text = [NSString stringWithFormat:@"%@", class_type];
    }
    else
    {
       self.detailLabel.text = [NSString stringWithFormat:@"%@ · %@", class_type, gameSize];
    }
    
    //新游首发，今日首发显示时间
    if (self.listType.intValue == 6)
    {
        NSString * startTime = dic[@"start_time"];
        if ([startTime containsString:@":"])
        {
            NSArray * array = [startTime componentsSeparatedByString:@":"];
            self.showTime1.text = array[0];
            self.showTime2.text = array[1];
        }
    }
    [self layoutIfNeeded];
}

#pragma mark - 获取下载状态
- (void)getGameDownloadStatus:(YCDownloadItem *)item
{
    //根据现在状态显示
    self.downloadItem = item;
    if (self.downloadItem)
    {
        self.downloadItem.delegate = self;
        switch (self.downloadItem.downloadStatus) {
            case YCDownloadStatusPaused:
                self.buttonGradient.backgroundColor = [UIColor clearColor];
                [self.buttonGradient setTitleColor:[UIColor whiteColor] forState:0];
                [self.progressView setProgress:(float)self.downloadItem.downloadedSize / self.downloadItem.fileSize];
                [self.buttonGradient setTitle:@"继续".localized forState:0];
                break;
            case YCDownloadStatusDownloading:
                self.buttonGradient.backgroundColor = [UIColor clearColor];
                [self.buttonGradient setTitleColor:[UIColor whiteColor] forState:0];
                [self.progressView setProgress:(float)self.downloadItem.downloadedSize / self.downloadItem.fileSize];
                [self.buttonGradient setTitle:[DeviceInfo shareInstance].isGameVip ? @"下载中".localized : @"暂停".localized forState:0];
                break;
            case YCDownloadStatusWaiting:
                self.buttonGradient.backgroundColor = [UIColor clearColor];
                [self.buttonGradient setTitleColor:[UIColor whiteColor] forState:0];
                [self.progressView setProgress:(float)self.downloadItem.downloadedSize / self.downloadItem.fileSize];
                [self.buttonGradient setTitle:@"等待中".localized forState:0];
                break;
            case YCDownloadStatusFinished:
            {
                self.buttonGradient.backgroundColor = MAIN_COLOR;
                [self.buttonGradient setTitleColor:UIColor.whiteColor forState:0];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSString * title = [YYToolModel getIpaDownloadStatus:self.downloadItem];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.buttonGradient setTitle:title forState:0];
                    });
                });
            }
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
        
        //当是至尊版和暂停状态删除当前任务
        if ([DeviceInfo shareInstance].isGameVip && (self.downloadItem.downloadStatus == YCDownloadStatusPaused || self.downloadItem.downloadStatus == YCDownloadStatusFailed))
        {
            [self removeFailedAndUnknowItem];
        }
    }
    else
    {
        [self.buttonGradient setTitle:@"下载".localized forState:0];
        self.buttonGradient.backgroundColor = MAIN_COLOR;
    }
}

/**  删除失败状态/未知状态下的任务  */
- (void)removeFailedAndUnknowItem
{
    [YCDownloadManager stopDownloadWithItem:self.downloadItem];
    self.buttonGradient.backgroundColor = MAIN_COLOR;
    [self.buttonGradient setTitle:@"下载".localized forState:0];
}

- (void)loadProjectColor
{
    self.titleLabel.textColor = UIColor.whiteColor;
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    self.firstTagLabel.backgroundColor = UIColor.clearColor;
    self.secondTagLabel.backgroundColor = UIColor.clearColor;
    self.thirdTagLabel.backgroundColor = UIColor.clearColor;
    
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.detailLabel.font = [UIFont systemFontOfSize:12];
    self.firstTagLabel.font = [UIFont systemFontOfSize:12];
    self.secondTagLabel.font = [UIFont systemFontOfSize:12];
    self.thirdTagLabel.font = [UIFont systemFontOfSize:12];
}

@end
