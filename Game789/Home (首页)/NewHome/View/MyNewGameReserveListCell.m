//
//  MyNewGameReserveListCell.m
//  Game789
//
//  Created by Maiyou on 2020/7/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyNewGameReserveListCell.h"
#import "MyGameReserveApi.h"
@class MyCancleGameReserveApi;

@implementation MyNewGameReserveListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setType:(NSString *)type
{
    _type = type;
    
    if ([type isEqualToString:@"video"])
    {//首页视频
        self.reserveBtn.hidden = YES;
        self.reserveTime.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    else if ([type isEqualToString:@"banner"])
    {//游戏大厅里面精选的banner
        self.playBtn.hidden = YES;
        self.reserveBtn.hidden = YES;
        self.reserveTime.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    else
    {//首页预约
        self.playBtn.hidden = YES;
        self.reserveBtn.hidden = NO;
        self.reserveTime.textColor = [UIColor colorWithHexString:@"#FF5E00"];
    }
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = [dataDic deleteAllNullValue];
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:_dataDic[@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    
    if ([self.type isEqualToString:@"banner"])
    { //游戏大厅里面精选的banner
        [self.coverImage yy_setImageWithURL:[NSURL URLWithString:_dataDic[@"image"]] placeholder:MYGetImage(@"banner_photo")];
    }
    else
    {//首页视频和预约
        [self.coverImage yy_setImageWithURL:[NSURL URLWithString:_dataDic[@"video_img_url"]] placeholder:MYGetImage(@"banner_photo")];
    }
    
    self.gameName.text = _dataDic[@"game_name"];
    
    if ([self.type isEqualToString:@"video"] || [self.type isEqualToString:@"banner"])
    {
        if ([_dataDic[@"game_species_type"] integerValue] == 3)
        {
            self.reserveTime.text = _dataDic[@"game_classify_type"];
        }
        else
        {
            self.reserveTime.text = [NSString stringWithFormat:@"%@ · %@", _dataDic[@"game_classify_type"], _dataDic[@"gama_size"][@"ios_size"]];
        }
    }
    else
    {
        self.reserveTime.text = [NSString stringWithFormat:@"%@首发", [NSDate dateWithFormat:@"MM月dd日 HH:mm" WithTS:[dataDic[@"starting_time"] doubleValue]]];
        self.reserveBtn.selected = [_dataDic[@"is_reserve"] boolValue];
        self.isReservedSucess = [_dataDic[@"is_reserve"] boolValue];
    }
    
    BOOL isNameRemark = [YYToolModel isBlankString:dataDic[@"nameRemark"]];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", dataDic[@"nameRemark"]];
    self.nameRemark.hidden = isNameRemark;
}

#pragma mark — 预约
- (IBAction)reserveBtnClick:(id)sender
{
    if ([YYToolModel isAlreadyLogin])
    {
        !self.isReservedSucess ? [self reserveGame] : [self cancleReserveGame];
    }
}

- (IBAction)playBtnClick:(id)sender
{
    if (self.playBtnAction)
    {
        self.playBtn.hidden = YES;
        self.playBtnAction();
    }
}

#pragma mark — 预约游戏
- (void)reserveGame
{
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
            if (self.receiveBtnAction) {
                self.receiveBtnAction(self.isReservedSucess);
            }
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
            if (self.receiveBtnAction) {
                self.receiveBtnAction(self.isReservedSucess);
            }
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
//    [self.reserveBtn setTitle:isSuccess ? @"已预约" : @"预约" forState:0];
    self.reserveBtn.selected = isSuccess;
//    if (self.PreviewGameAction)
//    {
//        self.PreviewGameAction(isSuccess);
//    }
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

- (NSString*)getCurrentTimes
{
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
