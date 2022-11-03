//
//  MyResignTimeTask.m
//  Game789
//
//  Created by Maiyou on 2019/9/5.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyResignTimeTask.h"

@implementation MyResignTimeTask

static MyResignTimeTask *_sharedManger;

+ (MyResignTimeTask *)sharedManager{
    static dispatch_once_t onceRunSingle;
    dispatch_once(&onceRunSingle, ^{
        if (!_sharedManger) {
            _sharedManger = [[MyResignTimeTask alloc]init];
        }
    });
    return _sharedManger;
}

- (instancetype)init
{
    if ([super init])
    {
        self.resginCount = 0;
//        [self.resginTimer fire];
    }
    return self;
}

//开始
- (void)timingStart
{
    [self.resginTimer setFireDate:[NSDate distantPast]];
    self.resginCount = 0;
    self.isResign = YES;
}

//暂停
- (void)timingPause
{
    [self.resginTimer setFireDate:[NSDate distantFuture]];
    self.isResign = NO;
}

//个签需要的时间进度
- (NSTimer *)resginTimer
{
    if (nil == _resginTimer)
    {
        _resginTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(showResginTimer) userInfo:nil repeats:YES];
        NSRunLoop *curRun = [NSRunLoop currentRunLoop];
        [curRun addTimer:_resginTimer forMode:NSRunLoopCommonModes];
    }
    return _resginTimer;
}

- (void)showResginTimer
{
    CGFloat progress = self.resginCount / RESIGN_TIME * 0.3;
    self.resginProgress = progress;
    
    NSInteger index = self.resginCount / 8;
    if (index == 0)
    {
        self.statusTitle = @"打包中".localized;
    }
    else if (index == 1)
    {
        self.statusTitle = @"签名中".localized;
    }
    
    self.resginCount ++;
    if (progress >= 0.3)
    {
        [self timingPause];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(resignTimingWithDownIpa:)])
    {
        [self.delegate resignTimingWithDownIpa:progress];
    }
    MYLog(@"%f", progress);
}

@end
