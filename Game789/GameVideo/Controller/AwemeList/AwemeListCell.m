//
//  AwemeListCell.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "AwemeListCell.h"
#import "Aweme.h"
#import "AVPlayerView.h"
#import "HoverTextView.h"
#import "CircleTextView.h"
#import "FocusView.h"
#import "MusicAlbumView.h"
#import "FavoriteView.h"
#import "CommentsPopView.h"
#import "SharePopView.h"
#import "NetworkHelper.h"
#import "MyGameInfoView.h"
#import "GameCommitApi.h"
#import "MyVideoLikeApi.h"
#import "MyVideoShareApi.h"
#import "GameDownLoadApi.h"

static const NSInteger kAwemeListLikeCommentTag = 0x01;
static const NSInteger kAwemeListLikeShareTag   = 0x02;

@interface AwemeListCell()<SendTextDelegate, HoverTextViewDelegate, AVPlayerUpdateDelegate, SJVideoPlayerControlLayerDelegate>

@property (nonatomic, strong) UIView                   *container;
@property (nonatomic ,strong) CAGradientLayer          *gradientLayer;
@property (nonatomic ,strong) UIImageView              *pauseIcon;
@property (nonatomic, strong) UIView                   *playerStatusBar;
@property (nonatomic ,strong) UIImageView              *musicIcon;
@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;
@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, assign) CGPoint                  lastTapPoint;

@end

@implementation AwemeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorBlackAlpha1;
        _lastTapTime = 0;
        _lastTapPoint = CGPointZero;
        _showIndex = 0;
        [self initSubViews];

        [self addBarrageView];
    }
    return self;
}

- (void)addBarrageView
{
    self.barrageManager = [[OCBarrageManager alloc] init];
    [self.contentView addSubview:self.barrageManager.renderView];
    self.barrageManager.renderView.frame = CGRectMake(0.0, kNavigationBarHeight, kScreenW, 180);
//    self.barrageManager.renderView.center = self.view.center;
    self.barrageManager.renderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.barrageManager start];
    
    [self.barrageManager.renderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).inset(IS_IPhoneX_All ? kStatusBarAndNavigationBarHeight : kNavigationBarHeight);
        make.width.mas_equalTo(kScreenW);
        make.height.mas_equalTo(150);
    }];
}

- (void)addFixedSpeedAnimationCell
{
    //防止数组越界
    if (self.showIndex >= self.aweme.commentArray.count)
    {
        return;
    }
    NSString * content = [NSString stringWithFormat:@"%@", self.aweme.commentArray[self.showIndex]];
    //过滤为空的弹幕内容
    if ([YYToolModel isBlankString:content] || [content isEqualToString:@"(null)"])
    {
        return;
    }
    
    OCBarrageGradientBackgroundColorDescriptor *gradientBackgroundDescriptor = [[OCBarrageGradientBackgroundColorDescriptor alloc] init];
    gradientBackgroundDescriptor.text = content;
    gradientBackgroundDescriptor.textColor = [UIColor whiteColor];
    gradientBackgroundDescriptor.positionPriority = OCBarragePositionMiddle;
    gradientBackgroundDescriptor.textFont = [UIFont systemFontOfSize:15.0];
    gradientBackgroundDescriptor.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    gradientBackgroundDescriptor.strokeWidth = -1;
    gradientBackgroundDescriptor.fixedSpeed = 15.0;//用fixedSpeed属性设定速度
    gradientBackgroundDescriptor.barrageCellClass = [OCBarrageGradientBackgroundColorCell class];
    gradientBackgroundDescriptor.gradientColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.barrageManager renderBarrageDescriptor:gradientBackgroundDescriptor];
    
    self.showIndex ++;
    if (self.showIndex < self.aweme.commentArray.count)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addFixedSpeedAnimationCell];
        });
    }
    else
    {
//        self.showIndex = 0;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.barrageManager stop];
//        });
    }
}

- (void)initSubViews
{
    //init player view;
    _player = [SJVideoPlayer lightweightPlayer];
    _player.controlLayerDelegate = self;
    _player.generatePreviewImages = YES;
    [self.contentView addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    /// 替换旋转管理类
    _rotationManager = [[SJVCRotationManager alloc] initWithViewController:self.currentVC];
    _player.rotationManager = _rotationManager;
    _player.supportedOrientation = SJAutoRotateSupportedOrientation_LandscapeLeft;
    /// update device orientation
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    _player.disableAutoRotation = YES;
    _player.enableFilmEditing = NO;
    _player.showResidentBackButton = NO;
    _player.hideBackButtonWhenOrientationIsPortrait = YES;
    _player.hideBottomProgressSlider = YES;
    _player.generatePreviewImages = YES;
    
    //init hover on player view container
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [_container addGestureRecognizer:_singleTapGesture];
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[(__bridge id)ColorClear.CGColor, (__bridge id)ColorBlackAlpha20.CGColor, (__bridge id)ColorBlackAlpha40.CGColor];
    _gradientLayer.locations = @[@0.3, @0.6, @1.0];
    _gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    _gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
    [_container.layer addSublayer:_gradientLayer];
    
    _pauseIcon = [[UIImageView alloc] init];
    _pauseIcon.image = [UIImage imageNamed:@"icon_play_pause"];
    _pauseIcon.contentMode = UIViewContentModeCenter;
    _pauseIcon.layer.zPosition = 3;
    _pauseIcon.hidden = YES;
    [_container addSubview:_pauseIcon];
    
    //init player status bar
    _playerStatusBar = [[UIView alloc]init];
    _playerStatusBar.backgroundColor = ColorWhite;
    [_playerStatusBar setHidden:YES];
    [_container addSubview:_playerStatusBar];
    
    WEAKSELF
    _gameInfoView = [[MyGameInfoView alloc] init];
    _gameInfoView.ViewGameInfoClick = ^(BOOL isDown) {
        if ([DeviceInfo shareInstance].isOpenYouthMode)
        {
            [MBProgressHUD showToast:@"当前为青少年模式暂不能访问！" toView:weakSelf.contentView];
            return;
        }
//        if (isDown)
//        {
//            [weakSelf getMessageApiRequestWithUrl:weakSelf.aweme.gama_url[@"ios_url"]];
//        }
//        else
//        {
            GameDetailInfoController * info = [GameDetailInfoController new];
            info.hidesBottomBarWhenPushed = YES;
            info.gameID = weakSelf.aweme.game_id;
            [weakSelf.currentVC.navigationController pushViewController:info animated:YES];
//        }
    };
    [_container addSubview:_gameInfoView];
    
    //init share、comment、like action view
    _share = [[UIImageView alloc]init];
    _share.contentMode = UIViewContentModeCenter;
    _share.image = [UIImage imageNamed:@"icon_home_share"];
    _share.userInteractionEnabled = YES;
    _share.tag = kAwemeListLikeShareTag;
    [_share addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [_container addSubview:_share];
    
    _shareNum = [[UILabel alloc]init];
    _shareNum.text = @"0";
    _shareNum.textColor = ColorWhite;
    _shareNum.font = SmallFont;
    [_container addSubview:_shareNum];
    
    _comment = [[UIImageView alloc]init];
    _comment.contentMode = UIViewContentModeCenter;
    _comment.image = [UIImage imageNamed:@"icon_home_comment"];
    _comment.userInteractionEnabled = YES;
    _comment.tag = kAwemeListLikeCommentTag;
    [_comment addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [_container addSubview:_comment];
    
    _commentNum = [[UILabel alloc]init];
    _commentNum.text = @"0";
    _commentNum.textColor = ColorWhite;
    _commentNum.font = SmallFont;
    [_container addSubview:_commentNum];
    
    _favorite = [FavoriteView new];
    _favorite.FavoriteAction = ^(BOOL isLike) {
        [weakSelf videoLikeRequest];
    };
    [_container addSubview:_favorite];
    
    _favoriteNum = [[UILabel alloc]init];
    _favoriteNum.text = @"0";
    _favoriteNum.textColor = ColorWhite;
    _favoriteNum.font = SmallFont;
    [_container addSubview:_favoriteNum];
    
    
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(100);
    }];

    //make constraintes
    [_playerStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).inset(0.5f);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_gameInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self).inset(10);
        make.right.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    
    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.gameInfoView.mas_top).inset(50);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_shareNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.share.mas_bottom);
        make.centerX.equalTo(self.share);
    }];
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.share.mas_top).inset(25);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comment.mas_bottom);
        make.centerX.equalTo(self.comment);
    }];
    [_favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.comment.mas_top).inset(25);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    
    [_favoriteNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorite.mas_bottom);
        make.centerX.equalTo(self.favorite);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _gradientLayer.frame = CGRectMake(0, self.frame.size.height - 500, self.frame.size.width, 500);
    [CATransaction commit];
}

//SendTextDelegate delegate
- (void)onSendText:(NSString *)text
{
    
}

//HoverTextViewDelegate delegate
-(void)hoverTextViewStateChange:(BOOL)isHover {
    _container.alpha = isHover ? 0.0f : 1.0f;
}

//gesture
- (void)handleGesture:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case kAwemeListLikeCommentTag: {
            CommentsPopView *popView = [[CommentsPopView alloc] initWithAwemeId:[self.aweme mj_keyValues]];
            popView.currentVC = self.currentVC;
            popView.dataDic = [self.aweme mj_keyValues];
            [popView show];
            break;
        }
        case kAwemeListLikeShareTag: {
//            SharePopView *popView = [[SharePopView alloc] init];
//            [popView show];
            [self shareAction];
            break;
        }
        default: {
            //获取点击坐标，用于设置爱心显示位置
            CGPoint point = [sender locationInView:_container];
            //获取当前时间
            NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
            //判断当前点击时间与上次点击时间的时间间隔
            if(time - _lastTapTime > 0.25f) {
                //推迟0.25秒执行单击方法
                [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.25f];
            }else {
                //取消执行单击方法
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object: nil];
                //执行连击显示爱心的方法
                [self showLikeViewAnim:point oldPoint:_lastTapPoint];
            }
            //更新上一次点击位置
            _lastTapPoint = point;
            //更新上一次点击时间
            _lastTapTime =  time;
            break;
        }
    }
}

#pragma mark - 分享
- (void)shareAction
{
    //未登录先登录
    if (![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    [self videoShareRequest];
    
    [[YYToolModel getCurrentVC].navigationController pushViewController:[MyInviteFriendsController new] animated:YES];
}

- (void)singleTapAction
{
    if([_hoverTextView isFirstResponder])
    {
        [_hoverTextView resignFirstResponder];
    }
    else
    {
        [self showPauseViewAnim:[_player rate]];
        if(_player.playStatus == 4 || _player.playStatus == 0 || _player.playStatus == 5) {
            [self play:NO];
        }else {
            [self pause];
        }
    }
}

//暂停播放动画
- (void)showPauseViewAnim:(CGFloat)rate {
    if(rate == 0) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.pauseIcon.alpha = 0.0f;
                         } completion:^(BOOL finished) {
                             [self.pauseIcon setHidden:YES];
                         }];
    }else {
        [_pauseIcon setHidden:NO];
        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
        _pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                            } completion:^(BOOL finished) {
                            }];
    }
}

//连击爱心动画
- (void)showLikeViewAnim:(CGPoint)newPoint oldPoint:(CGPoint)oldPoint {
    UIImageView *likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home_like_after"]];
    CGFloat k = ((oldPoint.y - newPoint.y)/(oldPoint.x - newPoint.x));
    k = fabs(k) < 0.5 ? k : (k > 0 ? 0.5f : -0.5f);
    CGFloat angle = M_PI_4 * -k;
    likeImageView.frame = CGRectMake(newPoint.x, newPoint.y, 80, 80);
    likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 0.8f, 1.8f);
    [_container addSubview:likeImageView];
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 1.0f, 1.0f);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5f
                                               delay:0.5f
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 3.0f, 3.0f);
                                              likeImageView.alpha = 0.0f;
                                          }
                                          completion:^(BOOL finished) {
                                              [likeImageView removeFromSuperview];
                                          }];
                     }];
    if (!self.aweme.videoIsLiked && !self.isRepeatClick)
    {
        [self videoLikeRequest];
        
        self.isRepeatClick = YES;
    }
}

//加载动画
-(void)startLoadingPlayItemAnim:(BOOL)isStart
{
    if (isStart)
    {
        _playerStatusBar.backgroundColor = ColorWhite;
        [_playerStatusBar setHidden:NO];
        [_playerStatusBar.layer removeAllAnimations];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.duration = 0.5;
        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.x";
        scaleAnimation.fromValue = @(1.0f);
        scaleAnimation.toValue = @(1.0f * ScreenWidth);
        
        CABasicAnimation * alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(1.0f);
        alphaAnimation.toValue = @(0.5f);
        [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
        [self.playerStatusBar.layer addAnimation:animationGroup forKey:nil];
    } else {
        [self.playerStatusBar.layer removeAllAnimations];
        [self.playerStatusBar setHidden:YES];
    }
}

// update method
- (void)initData:(Aweme *)aweme
{
    _aweme = aweme;
    
    [_favoriteNum setText:[NSString formatCount:aweme.videoLikeNum]];
    
    [_commentNum setText:[NSString formatCount:aweme.game_comment_num.integerValue]];
    
    [_shareNum setText:[NSString formatCount:aweme.videoShareNum]];
    
    _favorite.isLike = aweme.videoIsLiked;
    
    _gameInfoView.dataDic = [aweme mj_keyValues];
    
    [_player.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:aweme.video_img_url]];
}

#pragma mark - 获取安装plist
- (void)getMessageApiRequestWithUrl:(NSString *)url
{
    GameDownLoadApi *api = [[GameDownLoadApi alloc] init];
    if ([DeviceInfo shareInstance].downLoadStyle == 1)
        api.isShow = YES;
    api.requestTimeOutInterval = 60;
    api.urls = url;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handle1NoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handle1NoticeSuccess:(GameDownLoadApi *)api
{
    if (api.success == 1){
        NSString * routeUrl = api.data[@"url"];
        [YYToolModel loadIpaUrl:self.currentVC Url:routeUrl];
    }else{
        [MBProgressHUD showToast:api.error_desc toView:self];
    }
}

- (void)changeLikeStatus:(Aweme *)aweme
{
    _favorite.isLike = aweme.videoIsLiked;
    [_favoriteNum setText:[NSString formatCount:aweme.videoLikeNum]];

}

- (void)play:(BOOL)isOpenDanmu
{
    [[MyVideoPlayerManager shareManager] play:_player barrage:self.barrageManager];
    [_pauseIcon setHidden:YES];
    
    NSNumber * num = [YYToolModel getUserdefultforKey:@"SaveDanmuStatus"];
    if (num != NULL && num.boolValue)
    {
        if (self.aweme.commentArray.count == 0)
        {
            [self getCommitApiRequest];
        }
        else
        {
            if (self.showIndex >= self.aweme.commentArray.count - 1)
            {
                self.showIndex = 0;

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self addFixedSpeedAnimationCell];
                });
            }
            
            [self.barrageManager start];
            
            if (self.showIndex == 0 && isOpenDanmu)
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self addFixedSpeedAnimationCell];
                });
            }
            
//            if (self.showIndex == 0)
//            {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self addFixedSpeedAnimationCell];
//                });
//            }
        }
    }
}

- (void)pause
{
    [[MyVideoPlayerManager shareManager] pause:_player];
    [_pauseIcon setHidden:NO];
    
    if (self.aweme.commentArray.count > 0)
    {
        [self.barrageManager pause];
    }
}

- (void)replay
{
    [[MyVideoPlayerManager shareManager] replay:_player barrage:self.barrageManager];
    [_pauseIcon setHidden:YES];
    
    self.showIndex = 0;
}

- (void)startDownloadBackgroundTask {
    NSString *playUrl = [NetworkHelper isWifiStatus] ? _aweme.video_url : _aweme.video_url;
//    [_playerView setPlayerWithUrl:playUrl];
    
    _player.assetURL = [NSURL URLWithString:playUrl];
    
    if (self.currentIndex == 0 && self.rowIndex == 0 && [NetworkHelper isWifiStatus])
    {
        [self play:NO];
    }
    else
    {
        [self pause];
    }
}

- (void)startDownloadHighPriorityTask {
    NSString *playUrl = [NetworkHelper isWifiStatus] ? _aweme.video_url : _aweme.video_url;
//    [_playerView startDownloadTask:[[NSURL alloc] initWithString:playUrl] isBackground:NO];
    _player.assetURL = [NSURL URLWithString:playUrl];
    [self pause];
}

/// 播放状态改变的回调
- (void)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer statusDidChanged:(SJVideoPlayerPlayStatus)status
{
    MYLog(@"---------%lu", (unsigned long)status);
    if (status == 5)
    {
        [self replay];
    }
}

- (void)videoLikeRequest
{
    if (![YYToolModel islogin])
    {
        LoginViewController * login = [LoginViewController new];
        login.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:login animated:YES];
        return;
    }
    
    MyVideoLikeApi * api = [[MyVideoLikeApi alloc] init];
    api.game_id = self.aweme.maiyou_gameid;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1) {
            NSInteger num = self.aweme.videoLikeNum;
            self.aweme.videoIsLiked ? num-- : num++;
            self.aweme.videoLikeNum = num;
            self.aweme.videoIsLiked = !self.aweme.videoIsLiked;
            [self.favorite setIsLike:self.aweme.videoIsLiked];
            self.favoriteNum.text = [NSString stringWithFormat:@"%ld", (long)self.aweme.videoLikeNum];
            //防止连续点击
            self.isRepeatClick = self.aweme.videoIsLiked;
            //如果为足迹列表修改了点赞状态，刷新当前的视频列表
            if (self.isTrack)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeCurrentVideoList" object:self.aweme];
            }
        } else {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)videoShareRequest
{
    MyVideoShareApi * api = [[MyVideoShareApi alloc] init];
    api.game_id = self.aweme.maiyou_gameid;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1) {
            NSInteger num = self.aweme.videoShareNum;
            num++;
            self.aweme.videoShareNum = num;
            self.shareNum.text = [NSString stringWithFormat:@"%ld", (long)self.aweme.videoShareNum];
        } else {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark --获取评论数据--
- (void)getCommitApiRequest
{
    GameCommitApi *api = [[GameCommitApi alloc] init];
    //    WEAKSELF
    api.topic_id = self.aweme.comment_topic_id;
    api.count = 50;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (api.success == 1)
        {
            NSArray * array = api.data[@"list"];;
            if (array.count > 0)
            {
                NSMutableArray * commentArray = [NSMutableArray array];
                for (NSDictionary * dic in array)
                {
                    NSString * str = dic[@"content"];
                    if (str.length > 20)
                    {
                        str = [NSString stringWithFormat:@"%@...", [str substringToIndex:19]];
                    }
                    [commentArray addObject:str];
                }
                self.aweme.commentArray = commentArray;
                
                if (commentArray.count > 0)
                {
                    self.showIndex = 0;
                    [self.barrageManager start];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self addFixedSpeedAnimationCell];
                    });
                }
            }
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

@end
