//
//  MyVideoPlayerManager.m
//  Game789
//
//  Created by yangyongMac on 2020/2/24.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyVideoPlayerManager.h"

@implementation MyVideoPlayerManager

+ (MyVideoPlayerManager *)shareManager {
    static dispatch_once_t once;
    static MyVideoPlayerManager *manager;
    dispatch_once(&once, ^{
        manager = [MyVideoPlayerManager new];
    });
    return manager;
}

+ (void)setAudioMode {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _playerArray = [NSMutableArray array];
        _barrageArray = [NSMutableArray array];
    }
    
    return self;
}
- (void)play:(SJVideoPlayer *)player barrage:(nonnull OCBarrageManager *)barrageManager {
    [_playerArray enumerateObjectsUsingBlock:^(SJVideoPlayer * obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
    [_barrageArray enumerateObjectsUsingBlock:^(OCBarrageManager * obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
    if(![_playerArray containsObject:player]) {
        [_playerArray addObject:player];
    }
    if(![_barrageArray containsObject:barrageManager]) {
        [_barrageArray addObject:barrageManager];
    }
    [player play];
}

- (void)pause:(SJVideoPlayer *)player {
//    if([_playerArray containsObject:player]) {
        [player pause];
//    }
}

- (void)pauseAll {
    [_playerArray enumerateObjectsUsingBlock:^(SJVideoPlayer * obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
}

- (void)replay:(SJVideoPlayer *)player barrage:(nonnull OCBarrageManager *)barrageManager {
    [_playerArray enumerateObjectsUsingBlock:^(SJVideoPlayer * obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
    [_barrageArray enumerateObjectsUsingBlock:^(OCBarrageManager * obj, NSUInteger idx, BOOL *stop) {
        [obj pause];
    }];
    if([_playerArray containsObject:player]) {
        [player seekToTime:0 completionHandler:^(BOOL finished) {
            
        }];
        [self play:player barrage:barrageManager];
    }else {
        [_playerArray addObject:player];
        [self play:player barrage:barrageManager];
    }
    if([_barrageArray containsObject:barrageManager]) {
        [self play:player barrage:barrageManager];
    }else {
        [_barrageArray addObject:barrageManager];
        [self play:player barrage:barrageManager];
    }
}

- (void)removeAllPlayers {
    [_playerArray removeAllObjects];
}

@end
