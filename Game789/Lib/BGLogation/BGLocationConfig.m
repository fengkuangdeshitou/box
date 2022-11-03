//
//  BGLocationConfig.m
//  ZOOM
//
//  Created by 张雷 on 2017/11/28.
//  Copyright © 2017年 Weshape3D. All rights reserved.
//

#import "BGLocationConfig.h"
#import "BGLogation.h"
#import "BGTask.h"

@interface BGLocationConfig()
@property (strong , nonatomic) BGTask *task;
@property (strong , nonatomic) BGLogation *bgLocation;

@end

@implementation BGLocationConfig

static BGLocationConfig *instance = nil;
+ (instancetype)ShareInstance{
    
    @synchronized(self){
        if (nil == instance) {
            instance = [[super allocWithZone:nil] init]; // 避免死循环
        }
    }
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [BGLocationConfig ShareInstance];
}

- (id)copy
{
    return self;
}

- (id)mutableCopy
{
    return self;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}

#pragma mark <后台定位>
/**
 开启后台定位
 */
- (void)BGRunSeting
{
    _task = [BGTask shareBGTask];
    NSString * noticeOnce = [YYToolModel getUserdefultforKey:@"BGRefreshDataOnce"];
    if([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusDenied && noticeOnce == NULL){
        [YYToolModel saveUserdefultValue:@"once" forKey:@"BGRefreshDataOnce"];
        UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"请开启后台应用刷新".localized message:@"如未开启后台应用刷新，下载游戏过程中若退出APP，游戏可能会停止下载，建议您开启此功能!开启方式:设置->通用->后台应用刷新开启".localized preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消".localized style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        }];
        [alertControler addAction:noAction];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"去开启".localized style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            CGFloat systemVersion =  [[[UIDevice currentDevice] systemVersion] floatValue];
            if (systemVersion >= 8.0 && systemVersion < 10.0) {  // iOS8.0 和 iOS9.0
                
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }else if (systemVersion >= 10.0) {  // iOS10.0及以后
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        }];
                    }
                }
            }
        }];
        [alertControler addAction:yesAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControler animated:YES completion:nil];
    }
    else if ([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusRestricted){
        MYLog(@"请打开定位");
    }
    //    else{
    //        self.bgLocation = [[BGLogation alloc]init];
    //    }
    if (nil == self.bgLocation) {
        self.bgLocation = [[BGLogation alloc] init];
    }
    [self.bgLocation startLocation];
    
}

+ (void)starBGLocation{
    [[BGLocationConfig ShareInstance] BGRunSeting];
}
@end
