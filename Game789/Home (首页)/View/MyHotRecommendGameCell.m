//
//  MyHotRecommendGameCell.m
//  Game789
//
//  Created by Maiyou on 2018/12/10.
//  Copyright © 2018 yangyong. All rights reserved.
//

#import "MyHotRecommendGameCell.h"
#import "GameDownLoadApi.h"

@interface MyHotRecommendGameCell ()

@end

@implementation MyHotRecommendGameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.disHot.layer.borderColor = [UIColor colorWithHexString:@"#FF00FF"].CGColor;
    self.disHot.layer.borderWidth = 0.5;
    
    self.hotRecommend.layer.borderColor = [UIColor redColor].CGColor;
    self.hotRecommend.layer.borderWidth = 0.5;
    
    [self addCircleProgressView];
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

- (IBAction)downLoadPress:(id)sender
{
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
    else
    {
        //如果已经下载或者安装直接打开
        if ([self existedGameIpaInstallOrOpen])
        {
            return;
        }
        else if ([MyResignTimeTask sharedManager].isResign)
        {
            [MBProgressHUD showToast:@"已有正在下载任务，请稍后！"];
            return;
        }
    
        //1、默认下载方式；2、通过safari打开vip_ios_url；3、内部下载安装游戏（个人签名版）
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
            else{
                YCDownloadItem * item = [YCDownloadManager itemWithFileId:dic[@"maiyou_gameid"]];
                //删除当前任务
                [YCDownloadManager stopDownloadWithItem:item];
                self.buttonGradient.backgroundColor = ORANGE_COLOR;
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
                    [self.buttonGradient setTitle:@"暂停".localized forState:0];
                }
                break;
                
            case YCDownloadStatusDownloading:
                if (![[DeviceInfo shareInstance] isGameVip])
                {
                    [YCDownloadManager pauseDownloadWithItem:self.downloadItem];
                    [self.buttonGradient setTitle:@"继续".localized forState:0];
                }
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
    
    NSString * url = self.routeURL;
    if ([url hasPrefix:Down_Game_Url])
    {
        if ([DeviceInfo shareInstance].downLoadStyle == 0)//先下载再安装
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
        if ([DeviceInfo shareInstance].downLoadStyle == 0)//先下载再安装
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
            self.buttonGradient.backgroundColor = ORANGE_COLOR;
            [self.buttonGradient setTitle:@"下载".localized forState:0];
            YCDownloadItem * item = [YCDownloadManager itemWithFileId:self.data[@"maiyou_gameid"]];
            //删除当前任务
            [YCDownloadManager stopDownloadWithItem:item];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.currentVC.view];
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


- (void)setModelDic:(NSDictionary *)dic
{
    self.data = dic;
    self.routeURL = [dic[@"gama_url"] objectForKey:@"ios_url"];
    NSString *url = [[dic objectForKey:@"game_image"]objectForKey:@"thumb"];
    
    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"game_icon"]];
    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"game_icon"] options:SDWebImageHighPriority];
    NSString *class_type =  dic[@"game_classify_type"];
    self.titleLabel.text = dic[@"game_name"];
    
    //返回福利标签或是一句话  如果有详情介绍，显示，没有显示送VIP送福利
    if ([YYToolModel isBlankString:dic[@"introduction"]])
    {
        self.introduction.hidden = YES;
        NSString *desc = dic[@"game_desc"];
        if ([YYToolModel isBlankString:desc])
        {
            self.firstTagLabel.hidden = YES;
            self.secondTagLabel.hidden = YES;
        }
        else
        {
            NSArray *tagArray = [desc componentsSeparatedByString:@"+"];
            if (tagArray.count >= 2)
            {
                self.firstTagLabel.hidden = NO;
                self.secondTagLabel.hidden = NO;
                self.firstTagLabel.text  = [tagArray objectAtIndex:0];
                self.secondTagLabel.text = [tagArray objectAtIndex:1];
            }
        }
    }
    else
    {
        self.introduction.hidden = NO;
        _introduction.text = dic[@"introduction"];
        self.firstTagLabel.hidden = YES;
        self.secondTagLabel.hidden = YES;
    }
    
    /*******  判断是模块（数据需求与其他列表不同）*******/
    NSString * detailStr = @"";
    //BT游戏
    if ([dic[@"game_species_type"] isEqualToString:@"1"])
    {
        if (!self.isHotGame)
        {
            //判断热推是否有数据
            NSString * hotStr = dic[@"label"];
            if ([YYToolModel isBlankString:hotStr])
            {
                self.hotLabels.text = @"";
            }
            else
            {
                NSString * nul = @" ";
                self.hotLabels.text = [NSString stringWithFormat:@"%@ %@",dic[@"label"],nul];
            }
        }
        else
        {
            self.hotLabels.text = @"";
        }
        
        detailStr = [NSString stringWithFormat:@"%@%@%@ · %@", dic[@"game_download_num"], @"次".localized, @"下载".localized, class_type];
    }
    else if ([dic[@"game_species_type"] isEqualToString:@"2"])//折扣
    {
        NSString * disStr = dic[@"discount"];
        CGFloat   value = [disStr floatValue];
        value = value * 10;
        NSString *disValue = [NSString stringWithFormat:@"%0.1f",value];
        if ([dic[@"discount"] floatValue] < 1 && [dic[@"discount"] floatValue] > 0)
        {
            NSString * nul = @" ";
            self.hotLabels.text = [NSString stringWithFormat:@" %@折%@",disValue,nul];
        }
        else
        {
            self.hotLabels.text = @"";
        }
        //判断热推是否有数据
        NSString * hotStr = dic[@"label"];
        if ([YYToolModel isBlankString:hotStr])
        {
            self.disHot.text = @"";
        }
        else
        {
            NSString * nul = @" ";
            self.disHot.hidden = NO;
            self.disHot.text = [NSString stringWithFormat:@"%@ %@", dic[@"label"],nul];
        }
        detailStr = [NSString stringWithFormat:@"%@%@%@ · %@", dic[@"game_download_num"], @"次".localized, @"下载".localized, class_type];
    }
    else if([dic[@"game_species_type"] isEqualToString:@"3"])//H5
    {
        //当h5游戏有折扣时显示没有就不显示
        if ([dic[@"discount"] floatValue] < 1 && [dic[@"discount"] floatValue] > 0)
        {
            self.hotLabels.text = [NSString stringWithFormat:@" %.1f折 ", [dic[@"discount"] floatValue] * 10];
        }
        else
        {
            self.hotLabels.text = @"";
        }
        detailStr = [NSString stringWithFormat:@"%@", class_type];
    }
    
    //是否显示评论数量
    if ([dic[@"game_comment_num"] integerValue] > 0)
    {
        detailStr = [NSString stringWithFormat:@"%@%@%@ · %@", dic[@"game_comment_num"], @"条".localized, @"评论".localized, class_type];
        self.commentIcon_width.constant = 15;
        self.detailLabel_left.constant = 5;
    }
    else
    {
        self.commentIcon_width.constant = 0;
        self.detailLabel_left.constant = 0;
    }
    
    //根据下载状态显示
    if ([self.data[@"game_species_type"] integerValue] == 3)//H5游戏
    {
        [self.buttonGradient setTitle:@"开始".localized forState:0];
    }
    else
    {
        //更新签名下载状态
        if ([MyResignTimeTask sharedManager].isResign && [[MyResignTimeTask sharedManager].maiyou_gameid isEqualToString:self.data[@"maiyou_gameid"]])
        {
            self.buttonGradient.backgroundColor = [UIColor clearColor];
            [self.buttonGradient setTitle:[MyResignTimeTask sharedManager].statusTitle forState:0];
            [MyResignTimeTask sharedManager].delegate = self;
        }
        else
        {
            //获取下载状态
            [self getGameDownloadStatus:[YCDownloadManager itemWithFileId:self.data[@"maiyou_gameid"]]];
        }
    }
    self.detailLabel.text = detailStr;
    
    //热门推荐
    [self.recommendImageView sd_setImageWithURL:[NSURL URLWithString:self.data[@"recomment"][@"ad_image"][@"source"]] placeholderImage:[UIImage imageNamed:@"banner_photo"]];
    self.showDetail.text = self.data[@"recomment"][@"ad_name"];
    
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
                [self.progressView setProgress:(float)self.downloadItem.downloadedSize / self.downloadItem.fileSize];
                [self.buttonGradient setTitle:@"继续".localized forState:0];
                break;
            case YCDownloadStatusDownloading:
                self.buttonGradient.backgroundColor = [UIColor clearColor];
                [self.progressView setProgress:(float)self.downloadItem.downloadedSize / self.downloadItem.fileSize];
                [self.buttonGradient setTitle:[DeviceInfo shareInstance].isGameVip ? @"下载中".localized : @"暂停".localized forState:0];
                break;
            case YCDownloadStatusWaiting:
                self.buttonGradient.backgroundColor = [UIColor clearColor];
                [self.progressView setProgress:(float)self.downloadItem.downloadedSize / self.downloadItem.fileSize];
                [self.buttonGradient setTitle:@"等待中".localized forState:0];
                break;
            case YCDownloadStatusFinished:
            {
                self.buttonGradient.backgroundColor = ORANGE_COLOR;
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
        self.buttonGradient.backgroundColor = ORANGE_COLOR;
    }
}

/**  删除失败状态/未知状态下的任务  */
- (void)removeFailedAndUnknowItem
{
    [YCDownloadManager stopDownloadWithItem:self.downloadItem];
    self.buttonGradient.backgroundColor = ORANGE_COLOR;
    [self.buttonGradient setTitle:@"下载".localized forState:0];
}

- (IBAction)viewHotRecommendGameAction:(id)sender
{
    NSString * game_id = self.data[@"recomment"][@"link_info"][@"link_value"];
    MYLog(@">>>>>>>>>>%@", game_id);
    GameDetailInfoController * detailVC = [[GameDetailInfoController alloc] init];
    detailVC.gameID = game_id;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:detailVC animated:YES];
}

@end
