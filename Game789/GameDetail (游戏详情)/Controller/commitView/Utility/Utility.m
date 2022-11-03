//
//  Utility.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "Utility.h"

@implementation Utility

#pragma mark - 时间戳转换
+ (NSString *)getDateFormatByTimestamp:(long long)timestamp
{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval nowTimestamp = [dat timeIntervalSince1970] ;
    long long int timeDifference = nowTimestamp - timestamp;
    long long int secondTime = timeDifference;
    long long int minuteTime = secondTime/60;
    long long int hoursTime = minuteTime/60;
    long long int dayTime = hoursTime/24;
    long long int monthTime = dayTime/30;
    long long int yearTime = monthTime/12;
    
    if (1 <= yearTime) {
        return [NSString stringWithFormat:@"%lld%@",yearTime, @"年前".localized];
    }
    else if(1 <= monthTime) {
        return [NSString stringWithFormat:@"%lld%@",monthTime, @"月前".localized];
    }
    else if(1 <= dayTime) {
        return [NSString stringWithFormat:@"%lld%@",dayTime, @"天前".localized];
    }
    else if(1 <= hoursTime && 24 > hoursTime) {
        return [NSString stringWithFormat:@"%lld%@",hoursTime, @"小时前".localized];
    }
    else if(1 <= minuteTime && 60 > minuteTime) {
        return [NSString stringWithFormat:@"%lld%@",minuteTime, @"分钟前".localized];
    }
    else if(1 <= secondTime && secondTime < 60) {
        return [NSString stringWithFormat:@"%lld%@",secondTime, @"秒前".localized];
    }
    else if(0 == secondTime ) {
        return @"刚刚".localized;
    }
    else {
        return [NSDate detailTimeStringWithTs:timestamp];
    }
}

#pragma mark - 获取单张图片的实际size
+ (CGSize)getSingleSize:(CGSize)singleSize
{
    CGFloat max_width = k_screen_width - 150;
    CGFloat max_height = k_screen_width - 130;
    CGFloat image_width = singleSize.width;
    CGFloat image_height = singleSize.height;
    
    CGFloat result_width = 0;
    CGFloat result_height = 0;
    if (image_height/image_width > 3.0) {
        result_height = max_height;
        result_width = result_height/2;
    }  else  {
        result_width = max_width;
        result_height = max_width*image_height/image_width;
        if (result_height > max_height) {
            result_height = max_height;
            result_width = max_height*image_width/image_height;
        }
    }
    return CGSizeMake(result_width, result_height);
}


@end
