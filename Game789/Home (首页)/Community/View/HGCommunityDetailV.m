//
//  HGCommunityDetailV.m
//  Game789
//
//  Created by Maiyou on 2018/10/29.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "HGCommunityDetailV.h"
#import <MLLabel.h>
#import "HGMMImageListView.h"
#import "SJPlayView.h"
#import "UserPersonalCenterController.h"

#import "MyCommunityRequestApi.h"
@class MyCommunityDisagreeApi;
@class MyCommunityAgreeApi;
@class MyCommunityCancleAgreeApi;
@class MyCommunityCancleDisagreeApi;

@interface HGCommunityDetailV ()

@property (nonatomic,strong)SJPlayView * videoView;
@property (nonatomic,strong)UIButton * muteButton;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@end

@implementation HGCommunityDetailV

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"HGCommunityDetailV" owner:self options:nil].firstObject;
        
        [self.sortBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
        [self.imageViewList addSubview:self.videoView];
        [self.imageViewList addSubview:self.muteButton];
        [self.muteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.width.height.mas_equalTo(44);
        }];
    }
    return self;
}

- (UIButton *)muteButton
{
    if (!_muteButton)
    {
        _muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _muteButton.frame = CGRectMake(0, 0, 44, 44);
        [_muteButton setImage:[UIImage imageNamed:@"video_voice_no"] forState:UIControlStateSelected];
        [_muteButton setImage:[UIImage imageNamed:@"video_voice_yes"] forState:UIControlStateNormal];
        [_muteButton addTarget:self action:@selector(muteChange:) forControlEvents:UIControlEventTouchUpInside];
        _muteButton.hidden = YES;
    }
    return _muteButton;
}

- (IBAction)usericonBtnClick:(id)sender
{
//    UserPersonalCenterController * center = [UserPersonalCenterController new];
//    center.user_id = self.moment.Id;
//    [[YYToolModel getCurrentVC].navigationController pushViewController:center animated:YES];
}

- (void)muteChange:(UIButton *)button
{
    button.selected = !button.selected;
    self.player.mute = button.selected;
}

- (SJPlayView *)videoView
{
    if (!_videoView)
    {
        _videoView = [[SJPlayView alloc] init];
        _videoView.layer.cornerRadius = 8;
        _videoView.layer.masksToBounds = YES;
    }
    return _videoView;
}

- (SJVideoPlayer *)player
{
    if (!_player)
    {
        WEAKSELF
        _player = [SJVideoPlayer lightweightPlayer];
        _player.mute = NO;
        _player.disableAutoRotation = YES;
        _player.autoPlayWhenPlayStatusIsReadyToPlay = YES;
        _player.placeholderImageView.image = self.videoView.coverImageView.image;
        _player.generatePreviewImages = NO; // 生成预览缩略图, 大概20张
        _player.playTimeDidChangeExeBlok = ^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
            if (videoPlayer.currentTime == videoPlayer.totalTime)
            {
                [weakSelf.player replay];
            }
        };
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 49)];
        customView.backgroundColor = [UIColor clearColor];
        SJEdgeControlButtonItem *customItem = [[SJEdgeControlButtonItem alloc] initWithCustomView:customView tag:10];
        [_player.defaultEdgeControlLayer.bottomAdapter addItem:customItem];
    }
    return _player;
}

- (void)setMoment:(Moment *)moment {
    _moment = moment;
    self.dislikeBtn.selected = moment.isDisagreed;
    self.likeBtn.selected = moment.isAgreed;
    self.likeCount.text = [NSString stringWithFormat:@"%ld", moment.agreeCount];
    self.dislikeCount.text = [NSString stringWithFormat:@"%ld", moment.disagreeCount];
}

- (void)setMomentDic:(NSDictionary *)momentDic {
    _momentDic = [momentDic deleteAllNullValue];

    if (momentDic == nil) {
        self.hidden = YES;
        return;
    }
    
    self.showContent.text = [NSString stringWithFormat:@"%@", _momentDic[@"content"]];
    self.showTime.text = [NSString stringWithFormat:@"%@", [Utility getDateFormatByTimestamp:[_momentDic[@"createtime"] doubleValue]]];
    
    self.userName.text = [NSString stringWithFormat:@"%@", _momentDic[@"user"][@"nickname"]];
    NSURL *avaterImageUrl = [NSURL URLWithString:_momentDic[@"user"][@"avatar"]];
    [self.user_icon yy_setImageWithURL:avaterImageUrl forState:0 placeholder:MYGetImage(@"user_icon")];
    self.userLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%@", _momentDic[@"user"][@"user_level"]]];
    
    NSDictionary * userDic = momentDic[@"user"];
    NSArray * array = [YYToolModel getUserdefultforKey:@"MyUserCommentList"];
    if (array == NULL)
    {
        self.attentionBtn.selected = NO;
        self.attentionBtn.layer.borderColor = [UIColor colorWithHexString:@"FFC000"].CGColor;
    }
    else
    {
        self.attentionBtn.selected = [array containsObject:userDic];
        self.attentionBtn.layer.borderColor = [UIColor colorWithHexString:[array containsObject:userDic] ? @"#DEDEDE" : @"FFC000"].CGColor;
    }

//    self.dislikeBtn.selected = _momentDic[@"isAgreed"];
//    self.likeBtn.selected = _momentDic[@"isDisagreed"];
//    self.likeCount.text = [NSString stringWithFormat:@"%ld", [_momentDic[@"agreeCount"] intValue]];
//    self.dislikeCount.text = [NSString stringWithFormat:@"%ld", [_momentDic[@"disagreeCount"] intValue]];
    self.replyLabel.text = [NSString stringWithFormat:@"%d", [_momentDic[@"commentCount"] intValue]];
    self.deviceName.text = [NSString stringWithFormat:@"#%@#", _momentDic[@"themename"]];
    
    CGSize attrStrSize = [YYToolModel sizeWithText:_momentDic[@"content"] size:CGSizeMake(kScreenW - 40, MAXFLOAT) font:self.showContent.font];
    self.showContent_height.constant = attrStrSize.height + self.showContent.font.lineHeight;
     NSArray *imageArray = _momentDic[@"imgs"];
    CGFloat imageList_height = 0;
    if ([momentDic[@"video"] isKindOfClass:[NSDictionary class]] && [momentDic[@"video"] allValues].count > 0) {
        
        CGFloat videoWidth = [momentDic[@"video"][@"width"] floatValue];
        CGFloat videoHeight = [momentDic[@"video"][@"height"] floatValue];
        CGFloat width = 0;
        CGFloat height = 0;
//        if (videoWidth < videoHeight) {
//            height = 194;
//            width  = 194*videoWidth/videoHeight;
//        }else{
//            if (videoWidth > (ScreenWidth - 40)) {
                width = ScreenWidth - 30;
                height = 9 * width / 16;
//            }else{
//                height = 194;
//                width = 194*videoWidth/videoHeight;
//            }
//        }
        
        self.videoView.frame = CGRectMake(0, 0, width, height);
        self.muteButton.hidden = NO;

        #ifdef SJMAC
        self.player.disablePromptWhenNetworkStatusChanges = YES;
        #endif
            WEAKSELF
        // [SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:self.videoView.coverImageView.tag atIndexPath:videoIndexPath tableView:self.tableView]
        self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:momentDic[@"video"][@"video"]] playModel:[[SJPlayModel alloc] init]];
        
        // fade in(淡入)
        weakSelf.player.view.alpha = 0.001;
        [UIView animateWithDuration:0.6 animations:^{
            weakSelf.player.view.alpha = 1;
        }];
        [self.videoView.coverImageView addSubview:weakSelf.player.view];
        [weakSelf.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
         
        self.imageViewList_height.constant = height;
        imageList_height = height;
        
    }else{
        if (imageArray.count == 0) {
            self.imageViewList_height.constant = 0;
        } else {
            HGMMImageListView * imageListView = [[HGMMImageListView alloc] initWithFrame:self.imageViewList.bounds];
            imageListView.isAll = YES;
            [self.imageViewList addSubview:imageListView];

            imageListView.momentDic = momentDic;
            self.imageViewList_height.constant = imageListView.height;

            imageList_height = imageListView.height;
        }
    }
    
    [self layoutIfNeeded];
    self.view_height = CGRectGetMaxY(self.replyView.frame);
}

- (IBAction)likeBtnClick:(id)sender
{
    if (![YYToolModel isAlreadyLogin])
    {
        return;
    }
    UIButton * button = sender;
    WEAKSELF
    NSString * detailId = self.momentDic[@"id"];
   if (!weakSelf.moment.isAgreed)
    {
        MyCommunityAgreeApi * api = [[MyCommunityAgreeApi alloc] init];
        api.isShow = YES;
        api.detailId = detailId;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                weakSelf.moment.agreeCount = weakSelf.moment.agreeCount + 1;
                weakSelf.likeCount.text = [NSString stringWithFormat:@"%ld", weakSelf.moment.agreeCount];
                weakSelf.moment.isAgreed = YES;
                button.selected = weakSelf.moment.isAgreed;
                if (self.delegate && [self.delegate respondsToSelector:@selector(onLikeChange:)]){
                    [self.delegate onLikeChange:weakSelf.moment];
                }
            }
            else
            {
                [MBProgressHUD showToast:request.error_desc];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
   else
   {
       MyCommunityCancleAgreeApi * api = [[MyCommunityCancleAgreeApi alloc] init];
       api.isShow = YES;
       api.detailId = detailId;
       [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
           if (request.success == 1)
           {
               weakSelf.moment.agreeCount = weakSelf.moment.agreeCount - 1;
               weakSelf.likeCount.text = [NSString stringWithFormat:@"%ld", weakSelf.moment.agreeCount];
               weakSelf.moment.isAgreed = NO;
               button.selected = weakSelf.moment.isAgreed;
               if (self.delegate && [self.delegate respondsToSelector:@selector(onLikeChange:)]){
                   [self.delegate onLikeChange:weakSelf.moment];
               }
           }
           else
           {
               [MBProgressHUD showToast:request.error_desc];
           }
       } failureBlock:^(BaseRequest * _Nonnull request) {
           
       }];
    }
}

- (IBAction)dislikeBtnClick:(id)sender
{
    if (![YYToolModel isAlreadyLogin])
    {
        return;
    }
    UIButton * button = sender;
    WEAKSELF
    NSString * detailId = self.momentDic[@"id"];
    if (!weakSelf.moment.isDisagreed)
    {
        MyCommunityDisagreeApi * api = [[MyCommunityDisagreeApi alloc] init];
        api.isShow = YES;
        api.detailId = detailId;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                weakSelf.moment.disagreeCount = weakSelf.moment.disagreeCount + 1;
                weakSelf.dislikeCount.text = [NSString stringWithFormat:@"%ld", weakSelf.moment.disagreeCount];
                weakSelf.moment.isDisagreed = YES;
                button.selected = weakSelf.moment.isDisagreed;
                if (self.delegate && [self.delegate respondsToSelector:@selector(onDisLikeChange:)]){
                    [self.delegate onDisLikeChange:weakSelf.moment];
                }
            }
            else
            {
                [MBProgressHUD showToast:request.error_desc];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
    else
    {
        MyCommunityCancleDisagreeApi * api = [[MyCommunityCancleDisagreeApi alloc] init];
        api.isShow = YES;
        api.detailId = detailId;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                weakSelf.moment.disagreeCount = weakSelf.moment.disagreeCount - 1;
                weakSelf.dislikeCount.text = [NSString stringWithFormat:@"%ld", weakSelf.moment.disagreeCount];
                weakSelf.moment.isDisagreed = NO;
                button.selected = weakSelf.moment.isDisagreed;
                if (self.delegate && [self.delegate respondsToSelector:@selector(onDisLikeChange:)]){
                    [self.delegate onDisLikeChange:weakSelf.moment];
                }
            }
            else
            {
                [MBProgressHUD showToast:request.error_desc];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
}

- (IBAction)replyAction:(id)sender
{
    
}

#pragma mark — 排序
- (IBAction)sortBtnClick:(id)sender
{
    UIButton * button = sender;
    button.selected = !button.selected;
    if (self.selectSortAction)
    {
        self.selectSortAction(button.selected);
    }
}

#pragma mark - 查看用户个人信息
- (IBAction)viewUserDetailAction:(id)sender
{
    
}

- (IBAction)attentionBtnClick:(id)sender
{
    UIButton * btn = sender;
    
    btn.selected = !btn.selected;
    NSArray * array = [YYToolModel getUserdefultforKey:@"MyUserCommentList"];
    NSMutableArray * list = [NSMutableArray array];
    if (array != NULL)
    {
        list = [NSMutableArray arrayWithArray:array];
    }
    NSDictionary * userDic = self.momentDic[@"user"];
    if (btn.isSelected)
    {
        btn.layer.borderColor = [UIColor colorWithHexString:@"#DEDEDE"].CGColor;
        if (![list containsObject:userDic])
        {
            [list addObject:userDic];
        }
    }
    else
    {
        btn.layer.borderColor = MAIN_COLOR.CGColor;
        
        if ([list containsObject:userDic])
        {
            [list removeObject:userDic];
        }
    }
    [YYToolModel saveUserdefultValue:list forKey:@"MyUserCommentList"];
}

@end
