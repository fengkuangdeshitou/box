//
//  AwemeListCell.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
//视频播放
#import <SJVideoPlayer.h>
#import <SJVCRotationManager.h>
#import <SJRouter/SJRouter.h>
#import "MyVideoPlayerManager.h"
#import "OCBarrageGradientBackgroundColorDescriptor.h"
#import "OCBarrageGradientBackgroundColorCell.h"

typedef void (^OnPlayerReady)(void);

@class Aweme;
@class AVPlayerView;
@class HoverTextView;
@class CircleTextView;
@class FocusView;
@class MusicAlbumView;
@class FavoriteView;
@class MyGameInfoView;

@interface AwemeListCell : UITableViewCell

@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) Aweme            *aweme;

@property (nonatomic, strong) AVPlayerView     *playerView;
@property (nonatomic, strong) HoverTextView    *hoverTextView;
@property (nonatomic, strong) MyGameInfoView   *gameInfoView;

@property (nonatomic, strong) CircleTextView   *musicName;
@property (nonatomic, strong) UILabel          *desc;
@property (nonatomic, strong) UILabel          *nickName;

@property (nonatomic, strong) UIImageView      *avatar;
@property (nonatomic, strong) FocusView        *focus;
@property (nonatomic, strong) MusicAlbumView   *musicAlum;

@property (nonatomic, strong) UIImageView      *share;
@property (nonatomic, strong) UIImageView      *comment;

@property (nonatomic, strong) FavoriteView     *favorite;

@property (nonatomic, strong) UILabel          *shareNum;
@property (nonatomic, strong) UILabel          *commentNum;
@property (nonatomic, strong) UILabel          *favoriteNum;

@property (nonatomic, strong) OnPlayerReady    onPlayerReady;
@property (nonatomic, assign) BOOL             isPlayerReady;

@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) SJVCRotationManager *rotationManager;
@property (nonatomic, strong) NSDictionary * parameters;
@property (nonatomic, strong) OCBarrageManager *barrageManager;
//用来控制播放那个弹幕
@property (nonatomic, assign) NSInteger showIndex;
//用来控制首次进入是否直接播放第一个
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger rowIndex;
//是否为足迹
@property (nonatomic, assign) BOOL isTrack;
//防止点击连续点击
@property (nonatomic, assign) BOOL isRepeatClick;


- (void)initData:(Aweme *)aweme;
- (void)changeLikeStatus:(Aweme *)aweme;
- (void)play:(BOOL)isOpenDanmu;
- (void)pause;
- (void)replay;
- (void)startDownloadBackgroundTask;
- (void)startDownloadHighPriorityTask;
- (void)getCommitApiRequest;

@end
