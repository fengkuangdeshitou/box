//
//  MyGamePreviewCell.m
//  Game789
//
//  Created by Maiyou on 2019/10/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGamePreviewCell.h"
#import "MyShowGameImageListCell.h"
//视频播放
#import <SJVideoPlayer.h>
#import <SJVCRotationManager.h>
#import <SJRouter/SJRouter.h>
#import <SJRouteRequest.h>
#import "MyGameReserveApi.h"
#import "GameModel.h"

@class MyCancleGameReserveApi;
@class MyCancleCollectionGameApi;

@implementation MyGamePreviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MyShowGameImageListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyShowGameImageListCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUrlArray:(NSArray *)urlArray
{
    _urlArray = urlArray;
    
    [self.collectionView reloadData];
}

- (void)setModelDic:(NSDictionary *)dic
{
    self.dataDic = dic;
    
    GameModel * gameModel = [GameModel mj_objectWithKeyValues:dic];
    
    NSString *url = [[dic objectForKey:@"game_image"]objectForKey:@"thumb"];
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:url] placeholder:MYGetImage(@"game_icon")];
    self.gameName.text = dic[@"game_name"];
//    self.gameType.text =  dic[@"game_classify_type"];
    
    //显示游戏类型和游戏名后缀
    for (UILabel * label in self.stackView.subviews) {
        label.text = @"";
    }
    for (int i=0; i<gameModel.game_classify_typeArray.count; i++) {
        UILabel * label = [self.stackView viewWithTag:i+10];
        label.backgroundColor = [UIColor colorWithHexString:@"#F1F5F8"];
        label.text = [NSString stringWithFormat:@" %@ ", gameModel.game_classify_typeArray[i]];
    }
    self.nameRemark.text = [NSString stringWithFormat:@"%@  ", gameModel.nameRemark];
    self.nameRemark.hidden = [YYToolModel isBlankString:gameModel.nameRemark];
    
    self.reservedCount.text = [NSString stringWithFormat:@"%@", dic[@"reserved_total"]];
    if (![dic[@"label"] isBlankString])
    {
        self.startingTime.text = [NSString stringWithFormat:@"%@    ", dic[@"label"]];
        self.startingBgImg.hidden = NO;
    }
    else
    {
        self.startingTime.text = @"";
        self.startingBgImg.hidden = YES;
    }
    [dic[@"is_reserved"] integerValue] == 0 ? [self.reserveButton setTitle:@"预约".localized forState:0] : [self.reserveButton setTitle:@"已预约".localized forState:0];
    self.isReservedSucess = [dic[@"is_reserved"] integerValue];
    
    //返回福利标签或是一句话  如果有详情介绍，显示，没有显示送VIP送福利
    if ([YYToolModel isBlankString:dic[@"introduction"]])
    {
        self.introduction.hidden = YES;
        NSString *desc = dic[@"game_desc"];
        if ([YYToolModel isBlankString:desc])
        {
            self.firstTagLabel.hidden = YES;
            self.secondTagLabel.hidden = YES;
            self.thirdTagLabel.hidden = YES;
        }
        else
        {
            NSArray *tagArray = [desc componentsSeparatedByString:@"+"];
            for (int i = 0; i < tagArray.count; i ++)
            {
                if (i == 0)
                {
                    self.firstTagLabel.hidden = NO;
                    self.firstTagLabel.text  = [NSString stringWithFormat:@"%@  ", tagArray[i]];
                }
                else if (i == 1)
                {
                    self.secondTagLabel.hidden = NO;
                    self.secondTagLabel.text = [NSString stringWithFormat:@"%@  ", tagArray[i]];
                }
                else if (i == 2)
                {
                    self.thirdTagLabel.hidden = NO;
                    self.thirdTagLabel.text = [NSString stringWithFormat:@"%@  ", tagArray[i]];
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
    }
}

- (IBAction)reserveButtonClick:(id)sender
{
    if (![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    !self.isReservedSucess ? [self reserveGame] : [self cancleReserveGame];
//    GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
//    detailVC.isReserve = YES;
//    detailVC.gameID = self.dataDic[@"game_id"];
//    detailVC.hidesBottomBarWhenPushed = YES;
//    [self.currentVC.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
/**  分区个数  */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/** 每个分区item的个数  */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.urlArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"MyShowGameImageListCell";
    MyShowGameImageListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    [cell.gameScreenIamge sd_setImageWithURL:[NSURL URLWithString:self.urlArray[indexPath.item]] placeholderImage:MYGetImage(@"game_shotscreen_bg")];
    cell.playButton.tag = indexPath.item;
    cell.playVideoAction = ^(NSInteger index) {
        [self showImageAction:index];
    };
    if (indexPath.item == 0 && self.video_url.length > 0)
    {
        cell.playButton.hidden = NO;
    }
    else
    {
        cell.playButton.hidden = YES;
    }
    return cell;
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, self.collectionView.height);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**  分区内cell之间的最小行间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

/**  分区内cell之间的最小列间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld分item",(long)indexPath.item);
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = self.imageArray;
    browser.currentPage = indexPath.item;
    [browser show];
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
        [self.urlArray enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 网络图片
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:obj];
            data.projectiveView = [self viewAtIndex:idx];
            data.allowSaveToPhotoAlbum = NO;
            [_imageArray addObject:data];
        }];
    }
    return _imageArray;
}

- (id)viewAtIndex:(NSInteger)index
{
    MyShowGameImageListCell *cell = (MyShowGameImageListCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cell ? cell.gameScreenIamge : nil;
}

#pragma mark - 查看大图
- (void)showImageAction:(NSInteger)index
{
    if (index == 0 && [self.video_url length] > 0)
    {
        self.currentVC.hidesBottomBarWhenPushed = YES;
        SJRouteRequest *reqeust = [[SJRouteRequest alloc] initWithPath:@"player/fullscreen" parameters:@{@"url":self.video_url, @"vc":self.currentVC}];
        [SJRouter.shared handleRequest:reqeust completionHandler:nil];
    }
}

#pragma mark — 预约游戏
- (void)reserveGame
{
    [MyAOPManager gameRelateStatistic:@"ClickToReserveNewGame" GameInfo:self.dataDic Add:@{}];
    
    MyGameReserveApi * api = [[MyGameReserveApi alloc] init];
    api.game_id = self.dataDic[@"maiyou_gameid"];
    api.reserveType = @"0";
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [MBProgressHUD showSuccess:@"预约成功"];
            [self changePreviewButtonTitle:YES];
            self.isReservedSucess = YES;
            
            NSString * time = [NSString stringWithFormat:@"%.f", [self.dataDic[@"starting_time"] doubleValue] - 30 * 60];
            [self registerLocalNotification:[self timeDateWithTimeIntervalString:time]];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}


#pragma mark — 取消预约游戏
- (void)cancleReserveGame
{
    MyCancleGameReserveApi * api = [[MyCancleGameReserveApi alloc] init];
    api.game_id = self.dataDic[@"maiyou_gameid"];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [MBProgressHUD showSuccess:@"取消成功"];
            [self changePreviewButtonTitle:NO];
            self.isReservedSucess = NO;
            [self deleteNoticeState:self.dataDic[@"game_id"]];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)changePreviewButtonTitle:(BOOL)isSuccess
{
    [self.reserveButton setTitle:isSuccess ? @"已预约" : @"预约" forState:0];
    NSInteger count = self.reservedCount.text.integerValue;
    isSuccess ? (count += 1) : (count -= 1);
    self.reservedCount.text = [NSString stringWithFormat:@"%ld", (long)count];
    
    if (self.PreviewGameAction)
    {
        self.PreviewGameAction(isSuccess);
    }
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
    notification.alertBody = [NSString stringWithFormat:@"%@%@，%@", @"尊敬的用户，您预约的新游：".localized, self.dataDic[@"game_name"], @"即将开服，请及时下载，祝您玩的开心！".localized];
    
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    //    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
    NSDictionary *userDict = @{@"key":[NSString stringWithFormat:@"%@%@，%@", @"尊敬的用户，您预约的新游：".localized, self.dataDic[@"game_name"], @"即将开服，请及时下载，祝您玩的开心！".localized],
                               @"gameId":self.dataDic[@"game_id"],
                               @"start_date": self.dataDic[@"starting_time"],
                               @"new_image": self.dataDic[@"game_image"][@"thumb"]};
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

@end
