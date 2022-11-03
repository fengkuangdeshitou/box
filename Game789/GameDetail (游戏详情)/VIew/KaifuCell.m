//
//  KaifuCell.m
//  Game789
//
//  Created by Maiyou on 2018/8/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "KaifuCell.h"
#import "FileUtils.h"

@implementation KaifuCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.hsowType.layer.borderColor = MAIN_COLOR.CGColor;
    self.hsowType.layer.borderWidth = 0.5;
}

- (void)setKaifuDic:(NSDictionary *)kaifuDic
{
    _kaifuDic = kaifuDic;
    
    self.showTime.text = [self timeWithTimeIntervalString:kaifuDic[@"starttime"]];
    
    self.hsowType.text = kaifuDic[@"kaifuname"];
    
    //当为动态开服的时候,隐藏开服时间和状态
    if ([kaifuDic[@"starttime"] isEqualToString:@"0"] || [kaifuDic[@"starttime"] integerValue] == 0)
    {
        self.remindButton.hidden = YES;
        self.showTime.hidden = YES;
        self.hsowType.text = ![YYToolModel isBlankString:kaifuDic[@"kaifuname"]] ? kaifuDic[@"kaifuname"] : @"动态开服".localized;
    }
    
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    for (UILocalNotification *notification in localNotifications)
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[@"kaifuid"];
            // 如果找到需要取消的通知，则取消
            if (info != nil && [info isEqualToString:kaifuDic[@"kaifuid"]])
            {
                [self.remindButton setTitle:@"取消提醒".localized forState:UIControlStateNormal];
            }
        }
    }
    int result = [self compareOneDay:[self timeDateWithTimeIntervalString:kaifuDic[@"starttime"]]];
    NSLog(@"result info =%d",result);
    if (result == -1)
    {
        [self.remindButton setBackgroundColor:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0]];
        self.remindButton.enabled = NO;
        [self.remindButton setTitle:@"已开服".localized forState:UIControlStateNormal];
    }
}

- (int)compareOneDay:(NSDate *)oneDay
{
    NSDate *anotherDay = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
    
}

- (NSDate*)timeDateWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString *str = [formatter stringFromDate:date];
    NSDate *newData = [formatter dateFromString:str];
    NSLog(@"new date=%@",newData);
    return date;
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM.dd HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (IBAction)remindButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"取消提醒".localized])
    {
        [button setTitle:@"提醒".localized forState:UIControlStateNormal];
        [self deleteNoticeState:self.kaifuDic[@"kaifuid"]];
    }
    else {
        [button setTitle:@"取消提醒".localized forState:UIControlStateNormal];
        [self registerLocalNotification:[self timeDateWithTimeIntervalString:self.kaifuDic[@"starttime"]]];
    }
}

//取消提醒
- (void)deleteNoticeState:(NSString *)value {
    
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[@"kaifuid"];
            
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
    notification.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    // 时区
    //    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    //    notification.repeatInterval = kCFCalendarUnitSecond;
    notification.repeatInterval = 0;
    
    // 通知内容 《你来吗英雄》双线一区 开服啦，快来体验吧
    //    notification.alertBody = [NSString stringWithFormat:@"%@开服提醒",dic[@"kaifuname"]];
    notification.alertBody = [NSString stringWithFormat:@"《%@》%@%@",self.game_info[@"game_name"], self.kaifuDic[@"kaifuname"], @"开服啦，快来体验吧".localized];
    
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    //    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
    NSDictionary *userDict = @{@"key":[NSString stringWithFormat:@"《%@》%@%@",self.game_info[@"game_name"], self.kaifuDic[@"kaifuname"], @"开服啦，快来体验吧".localized],@"kaifuid":self.kaifuDic[@"kaifuid"],@"gameId":self.game_info[@"game_id"],@"kaifu_start_date": [self.kaifuDic objectForKey:@"starttime"],@"new_image": self.game_info[@"game_image"][@"thumb"]};
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
    NSDictionary *dic = @{@"title":userInfo[@"key"],@"type":@"kaifu",@"id":userInfo[@"gameId"],@"kaifuid":userInfo[@"kaifuid"],@"time":[self getCurrentTimes],@"kaifu_start_date": [userInfo objectForKey:@"kaifu_start_date"],@"new_image": [userInfo objectForKey:@"new_image"]};
    NSData *data = [FileUtils readDataFromFile:@"Push"];
    NSMutableArray *retArray = nil;
    if (data) {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:(NSArray *)jsonObject];
        NSMutableArray *array =[NSMutableArray arrayWithArray:arr];
        for (NSDictionary *dict in array) {
            if ([dict[@"kaifuid"] isEqualToString:userInfo[@"kaifuid"]]) {
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
@end
