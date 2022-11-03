//
//  MyVideoPlayerManager.h
//  Game789
//
//  Created by yangyongMac on 2020/2/24.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SJVideoPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyVideoPlayerManager : NSObject

@property (nonatomic, strong) NSMutableArray<SJVideoPlayer *>   *playerArray;
@property (nonatomic, strong) NSMutableArray<OCBarrageManager *>   *barrageArray;

+ (MyVideoPlayerManager *)shareManager;
+ (void)setAudioMode;
- (void)play:(SJVideoPlayer *)player barrage:(OCBarrageManager*)barrageManager;
- (void)pause:(SJVideoPlayer *)player;
- (void)pauseAll;
- (void)replay:(SJVideoPlayer *)player barrage:(OCBarrageManager*)barrageManager;
- (void)removeAllPlayers;

@end

NS_ASSUME_NONNULL_END
