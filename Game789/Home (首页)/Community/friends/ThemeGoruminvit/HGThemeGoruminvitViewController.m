//
//  HGThemeGoruminvitViewController.m
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGThemeGoruminvitViewController.h"
#import "HGThemeHeaderCell.h"
#import "HGContentCell.h"
#import "HGPhotosCell.h"
#import "HGVideoCell.h"
#import "HGEvaluationCell.h"
#import "HGActionCell.h"
#import "SJVideoPlayer.h"
#import "HGCommunityDetailVC.h"

#import "MyCommunityRequestApi.h"

@interface HGThemeGoruminvitViewController ()<UITableViewDelegate,UITableViewDataSource,HKPBotViewDelegate,HGCommunityDetailVCDelegate>

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * tableViewTop;
@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) HGVideoCell * currentPlayingCell;
@property (nonatomic, strong) NSDictionary * pagination;

@end

@implementation HGThemeGoruminvitViewController{
    NSInteger _page;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _page = 1;
    self.tableViewTop.constant = kNavigationBarHeight;
    [self.tableView registerNib:[UINib nibWithNibName:@"HGThemeHeaderCell" bundle:nil] forCellReuseIdentifier:@"HGThemeHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HGContentCell" bundle:nil] forCellReuseIdentifier:@"HGContentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HGPhotosCell" bundle:nil] forCellReuseIdentifier:@"HGPhotosCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HGVideoCell" bundle:nil] forCellReuseIdentifier:@"HGVideoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HGEvaluationCell" bundle:nil] forCellReuseIdentifier:@"HGEvaluationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HGActionCell" bundle:nil] forCellReuseIdentifier:@"HGActionCell"];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"Group" titleStr:@"该话题暂无评论" detailStr:@""];
    self.tableView.ly_emptyView.contentView.hidden = YES;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.mj_header = [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadData];
    }];
    
    self.tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self loadData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)loadData
{
    MyCommunityRequestApi * api = [[MyCommunityRequestApi alloc] init];
    api.themeid = self.themeId;
    api.pageNumber = _page;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            if (_page == 1) {
                self.dataArray = [[NSMutableArray alloc] init];
            }
            NSArray * jsonArray = request.data[@"list"];
            self.pagination = request.data[@"paginated"];
            self.hasNextPage = [self.pagination[@"more"] boolValue];
            NSArray * modelArray = [HGThemeModel mj_objectArrayWithKeyValuesArray:jsonArray];
            [self loadMoreData:modelArray];
            _tableView.ly_emptyView.contentView.hidden = NO;
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

- (void)loadMoreData:(NSArray *)dataArray{
    for (HGThemeModel * model in dataArray) {
        [self.dataArray addObject:model];
    }
    [self endRefresh];
}

- (void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playVideoInVisiableCells];
    });
    [self setFooterViewState:self.tableView Data:self.pagination FooterView:[self creatFooterView]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HGThemeModel * model = self.dataArray[indexPath.section];
    if (indexPath.row == 0) {
        static NSString * cellIdentifity = @"HGThemeHeaderCell";
        HGThemeHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity forIndexPath:indexPath];
        [cell.avatarImageView sd_setImageWithURL:model.user[@"avatar"] placeholderImage:[UIImage imageNamed:@"common_avatar_120px"]];
        cell.nickNameLabel.text = model.user[@"nickname"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@", [Utility getDateFormatByTimestamp:[model.publishTime doubleValue]]];
        cell.dataDic = model.user;
        return cell;
    }else if (indexPath.row == 1){
        static NSString * cellIdentifity = @"HGContentCell";
        HGContentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity forIndexPath:indexPath];
        
        CGFloat contentHeight = [model.content boundingRectWithSize:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.contentLabel.font} context:nil].size.height + 1;
        
        if (contentHeight > 110) {
            cell.moreLabel.hidden = NO;
            if (model.isOpening) {
                cell.contentLabel.text  = model.content;
                cell.moreLabel.text = @"收起";
            }else{
                cell.moreLabel.text = @"更多";
                // 计算第3行换行位置
                NSInteger index = 1;
                for (int i=0; i<model.content.length; i++) {
                    NSString * string = [model.content substringWithRange:NSMakeRange(0, index)];
                    CGFloat labelHeight = [string boundingRectWithSize:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.contentLabel.font} context:nil].size.height;
                    
                    if (labelHeight > 110) {
                        break;
                    }else{
                        index ++;
                    }
                }
                
                // 计算第二行截取长度
                NSInteger variable = 0;
                for (int i=index; i>0; i--) {
                    NSString * string = [model.content substringWithRange:NSMakeRange(i, index-i)];
                    CGFloat stringWidth = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.contentLabel.font} context:nil].size.width;
                    if (stringWidth > 70) {
                        variable = index-i;
                        break;
                    }
                }
                cell.contentLabel.text = [NSString stringWithFormat:@"%@...",[model.content substringWithRange:NSMakeRange(0, index-variable)]];
            }
        }else{
            cell.contentLabel.text  = model.content;
            cell.moreLabel.hidden = YES;
        }
        model.showContentText = cell.contentLabel.text;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentChange:)];
        [cell.moreLabel addGestureRecognizer:tap];
        return cell;
    }else if (indexPath.row == 2){
        if ([model.video isKindOfClass:[NSDictionary class]] && model.video.allValues.count > 0) {
            static NSString * cellIdentifity = @"HGVideoCell";
            HGVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity forIndexPath:indexPath];
            cell.video = model.video;
            return cell;
        }else{
            static NSString * cellIdentifity = @"HGPhotosCell";
            HGPhotosCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity forIndexPath:indexPath];
            NSMutableArray * thumbArrayArray = [[NSMutableArray alloc] init];
            NSMutableArray * originalArray = [[NSMutableArray alloc] init];
            for (NSDictionary * item in model.imgs) {
                [thumbArrayArray addObject:[NSURL URLWithString:item[@"thumb"]]];
                [originalArray addObject:[NSURL URLWithString:item[@"original"]]];
            }
            cell.thumbArray = thumbArrayArray;
            cell.originalArray = originalArray;
            return cell;
        }
    }else if (indexPath.row == 3){
        static NSString * cellIdentifity = @"HGEvaluationCell";
        HGEvaluationCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity forIndexPath:indexPath];
        NSArray * comments = model.comments;
        Comment * comment = comments.firstObject;
        [cell.avatarImageView sd_setImageWithURL:comment.user[@"avatar"] placeholderImage:[UIImage imageNamed:@"common_avatar_120px"]];
        cell.nickNameLabel.text = comment.user[@"nickname"];
        cell.contentLabel.text = comment.content;
        [cell.likeButton setTitle:[NSString stringWithFormat:@" %d",comment.agreeCount] forState:UIControlStateNormal];
        cell.evaluationImageView.hidden = !comment.isGodCom;
        [cell.likeButton addTarget:self action:@selector(evaluationLike:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        static NSString * cellIdentifity = @"HGActionCell";
        HGActionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity forIndexPath:indexPath];
        cell.botView.tagLabel.text = [NSString stringWithFormat:@"# %@#", model.themename];
        cell.botView.commitCount.text = [NSString stringWithFormat:@"%d",model.commentCount];
        
        cell.botView.likeCount.text = [NSString stringWithFormat:@"%d",model.agreeCount];
        cell.botView.dislikeCount.text = [NSString stringWithFormat:@"%d",model.disagreeCount];
        
        cell.botView.likeBtn.selected = model.isAgreed;
        cell.botView.dislikeBtn.selected = model.isDisagreed;

        [cell.botView.likeBtn addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [cell.botView.dislikeBtn addTarget:self action:@selector(disLike:) forControlEvents:UIControlEventTouchUpInside];
        [cell.botView.commitBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HGThemeModel * model = self.dataArray[indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HGCommunityDetailVC *info = [HGCommunityDetailVC new];
    info.commit_id = model.dynamicId;
    info.delegate = self;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)comment:(UIButton *)comment{
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    
    HGEvaluationCell * cell = [[[comment superview] superview] superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    HGThemeModel *model = self.dataArray[indexPath.section];
    HGCommunityDetailVC *info = [HGCommunityDetailVC new];
    info.commit_id = model.dynamicId;
    [self.navigationController pushViewController:info animated:YES];
    
}

// 评论点赞
- (void)evaluationLike:(UIButton *)likeBtn{
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    
    HGEvaluationCell * cell = [[[likeBtn superview] superview] superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    HGThemeModel *model = self.dataArray[indexPath.section];
    Comment * comment = model.comments.firstObject;
    NSDictionary * dic = @{@"replyid":comment.Id};

    if (!comment.isAgreed) {
//        [YYBaseApi yy_Post:@"/agreeForuminvitAppraisal" parameters:dic swpNetworkingSuccess:^(id  _Nonnull resultObject) {
//            comment.agreeCount = comment.agreeCount + 1;
//            [cell.likeButton setTitle:[NSString stringWithFormat:@" %ld", comment.agreeCount] forState:UIControlStateNormal];
//            comment.isAgreed = !comment.isAgreed;
//            cell.likeButton.selected = !cell.likeButton.selected;
//        } swpNetworkingError:^(NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
//
//        } Hud:YES];
    } else {
//        [YYBaseApi yy_Post:@"/cancelAgreeForuminvitAppraisal" parameters:dic swpNetworkingSuccess:^(id  _Nonnull resultObject) {
//            comment.agreeCount = comment.agreeCount - 1;
//            [cell.likeButton setTitle:[NSString stringWithFormat:@" %ld", comment.agreeCount] forState:UIControlStateNormal];
//            comment.isAgreed = !comment.isAgreed;
//            cell.likeButton.selected = !cell.likeButton.selected;
//        } swpNetworkingError:^(NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
//
//        } Hud:YES];
    }
}

#pragma mark- 帖子喜欢
- (void)like:(UIButton *)likeBtn {
    
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    
    HGActionCell * cell = [[[likeBtn superview] superview] superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    HGThemeModel *model = self.dataArray[indexPath.section];
    
    NSDictionary * dic = @{@"id":model.dynamicId};
    if (!model.isAgreed)
    {
        MyCommunityAgreeApi * api = [[MyCommunityAgreeApi alloc] init];
        api.isShow = YES;
        api.detailId = model.dynamicId;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                model.agreeCount = model.agreeCount + 1;
                cell.botView.likeCount.text = [NSString stringWithFormat:@"%ld", model.agreeCount];
                model.isAgreed = YES;
                cell.botView.likeBtn.selected = model.isAgreed;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                if (self.delegate && [self.delegate respondsToSelector:@selector(themeGoruminvitDidchangeLike:)]) {
                    [self.delegate themeGoruminvitDidchangeLike:model];
                }
            }
            else
            {
                [MBProgressHUD showToast:api.error_desc toView:self.view];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
    else
    {
        MyCommunityCancleAgreeApi * api = [[MyCommunityCancleAgreeApi alloc] init];
        api.isShow = YES;
        api.detailId = model.dynamicId;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                model.agreeCount = model.agreeCount - 1;
                cell.botView.likeCount.text = [NSString stringWithFormat:@"%d", model.agreeCount];
                model.isAgreed = NO;
                cell.botView.likeBtn.selected = model.isAgreed;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                if (self.delegate && [self.delegate respondsToSelector:@selector(themeGoruminvitDidchangeLike:)]) {
                    [self.delegate themeGoruminvitDidchangeLike:model];
                }
            }
            else
            {
                [MBProgressHUD showToast:api.error_desc toView:self.view];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
}

#pragma mark- 不喜欢
- (void)disLike:(UIButton *)disLike{
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    
    HGActionCell * cell = [[[disLike superview] superview] superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    HGThemeModel *model = self.dataArray[indexPath.section];
    if (!model.isDisagreed)
    {
        MyCommunityDisagreeApi * api = [[MyCommunityDisagreeApi alloc] init];
        api.isShow = YES;
        api.detailId = model.dynamicId;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                model.disagreeCount = model.disagreeCount + 1;
                cell.botView.dislikeCount.text = [NSString stringWithFormat:@"%d", model.disagreeCount];
                model.isDisagreed = YES;
                cell.botView.dislikeBtn.selected = model.isAgreed;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                if (self.delegate && [self.delegate respondsToSelector:@selector(themeGoruminvitDidchangeDisLike:)]) {
                    [self.delegate themeGoruminvitDidchangeDisLike:model];
                }
            }
            else
            {
                [MBProgressHUD showToast:api.error_desc toView:self.view];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];

    }
    else
    {
        MyCommunityCancleDisagreeApi * api = [[MyCommunityCancleDisagreeApi alloc] init];
        api.isShow = YES;
        api.detailId = model.dynamicId;
        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
            if (request.success == 1)
            {
                model.disagreeCount = model.disagreeCount - 1;
                cell.botView.dislikeCount.text = [NSString stringWithFormat:@"%ld", model.disagreeCount];
                model.isDisagreed = NO;
                cell.botView.dislikeBtn.selected = model.isAgreed;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                if (self.delegate && [self.delegate respondsToSelector:@selector(themeGoruminvitDidchangeDisLike:)]) {
                    [self.delegate themeGoruminvitDidchangeDisLike:model];
                }
            }
            else
            {
                [MBProgressHUD showToast:api.error_desc toView:self.view];
            }
        } failureBlock:^(BaseRequest * _Nonnull request) {
            
        }];
    }
}

- (void)contentChange:(UITapGestureRecognizer *)tap{
    HGContentCell * cell = [[tap.view superview] superview];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    HGThemeModel *model = self.dataArray[indexPath.section];
    model.isOpening = !model.isOpening;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HGThemeModel * model = self.dataArray[indexPath.section];
    if (indexPath.row == 0){
        return 70;
    }else if (indexPath.row == 1) {
        CGFloat contentHeight = [model.showContentText boundingRectWithSize:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]} context:nil].size.height + 1;
        return contentHeight;
    }else if (indexPath.row == 2) {
        if ([model.video isKindOfClass:[NSDictionary class]] && model.video.allValues.count > 0) {
            CGFloat videoWidth = [model.video[@"width"] floatValue];
            CGFloat videoHeight = [model.video[@"height"] floatValue];
            if (videoWidth < videoHeight) {
                return 194 + 13;
            }else{
                if (videoWidth > (ScreenWidth - 30)) {
                    return videoHeight * (ScreenWidth-30) / videoWidth + 13;
                }else{
                    return 194 + 13;
                }
            }
        }else{
            if (model.imgs.count == 0) {
                return 0.0001;
            }else{
                return model.imgs.count % 3 == 0 ? model.imgs.count / 3 * 100 + 10: (model.imgs.count / 3 + 1) * 100 + 10;
            }
        }
    }else if (indexPath.row == 3){
        NSArray * comments = model.comments;
        Comment * comment = comments.firstObject;
        if (comments.count == 0 || [comment.status intValue] == 1) {
            return 0.00001;
        }else{
            CGFloat contentHeight = [comment.content boundingRectWithSize:CGSizeMake(ScreenWidth-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14]} context:nil].size.height + 1;
            return contentHeight > 44 ? 107 : 90 ;
        }
    }else{
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
    return footer;
}


- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath
{

    HGThemeModel *model  = self.dataArray[indexPath.section];
    if (self.currentPlayingCell) {
        NSIndexPath * oldIndexPath = [self.tableView indexPathForCell:self.currentPlayingCell];
        HGThemeModel * oldModel = self.dataArray[oldIndexPath.section];
        if (oldIndexPath.section == indexPath.section && self.player.playStatus == SJVideoPlayerPlayStatusPlaying) {
            return;
        }
    }
    
    if ( !_player || !_player.isFullScreen ) {
        self.currentPlayingCell = nil;
        [_player stopAndFadeOut]; // 让旧的播放器淡出
        _player = [SJVideoPlayer player]; // 创建一个新的播放器
        _player.generatePreviewImages = NO; // 生成预览缩略图, 大概20张
        
    }
    NSIndexPath * videoIndexPath = [NSIndexPath indexPathForRow:2 inSection:indexPath.section];
    HGVideoCell * cell = [self.tableView cellForRowAtIndexPath:videoIndexPath];

#ifdef SJMAC
    _player.disablePromptWhenNetworkStatusChanges = YES;
#endif
    WEAKSELF
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:model.video[@"video"]] playModel:[SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:cell.videoView.coverImageView.tag atIndexPath:videoIndexPath tableView:self.tableView]];
    _player.mute = YES;
//    _player.lockedScreen = YES;
    _player.disableAutoRotation = YES;
    _player.controlLayerDelegate = self;
    _player.autoPlayWhenPlayStatusIsReadyToPlay = YES;
//    [_player.placeholderImageView sd_setImageWithURL:[NSURL URLWithString:model.video[@"videoImg"]] placeholderImage:nil];
    _player.placeholderImageView.image = cell.videoView.coverImageView.image;
    
    // fade in(淡入)
    weakSelf.player.view.alpha = 0.001;
    [UIView animateWithDuration:0.6 animations:^{
        weakSelf.player.view.alpha = 1;
    }];
    [cell.videoView.coverImageView addSubview:weakSelf.player.view];
    [weakSelf.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    weakSelf.currentPlayingCell = cell;
}

- (void)videoPlayerWillDisappearInScrollView:(__kindof SJBaseVideoPlayer *)videoPlayer{
    self.currentPlayingCell = nil;
    [_player stopAndFadeOut]; // 让旧的播放器淡出
    _player = [SJVideoPlayer player]; // 创建一个新的播放器
    _player.generatePreviewImages = NO; // 生成预览缩略图, 大概20张
}

- (void)controlLayerNeedAppear:(__kindof SJBaseVideoPlayer *)videoPlayer
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:self.currentPlayingCell];
    HGThemeModel *model = self.dataArray[indexPath.section];
    HGCommunityDetailVC *info = [HGCommunityDetailVC new];
    info.commit_id = model.dynamicId;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
    
    if (self.currentPlayingCell && _player)
    {
        [self.player play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (BOOL)prefersStatusBarHidden {
    return [self.player vc_prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.player vc_preferredStatusBarStyle];
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}


- (void)playVideoInVisiableCells
{
    NSArray *visiableCells = [self.tableView visibleCells];
//    在可见cell中找到第一个有视频的cell
    HGVideoCell  * videoCell = nil;
    for (UITableViewCell *cell in visiableCells)
    {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
        HGThemeModel * model = self.dataArray[indexPath.section];
        if ([model.video isKindOfClass:[NSDictionary class]] && model.video.allValues.count > 0)
        {
            NSIndexPath * videoIndexPath = [NSIndexPath indexPathForRow:2 inSection:indexPath.section];
            videoCell = [self.tableView cellForRowAtIndexPath:videoIndexPath];
            break;
        }
        
    }
    //如果找到了, 就开始播放视频
    if (videoCell)
    {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:videoCell];
        [self sj_playerNeedPlayNewAssetAtIndexPath:indexPath];
        self.currentPlayingCell = videoCell;
    }
}

- (void)handleScroll
{
    NSIndexPath * middleIndexPath = [self.tableView  indexPathForRowAtPoint:CGPointMake(0, self.tableView.contentOffset.y + self.tableView.frame.size.height/2)];
    if (!middleIndexPath) return;
    HGThemeModel * model = self.dataArray[middleIndexPath.section];
    if ([model.video isKindOfClass:[NSDictionary class]] && model.video.allValues.count > 0) {
        [self sj_playerNeedPlayNewAssetAtIndexPath:middleIndexPath];
    }else{
        self.currentPlayingCell = nil;
        [_player stopAndFadeOut];
    }
}

// 松手时已经静止,只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO)
    {
        // scrollView已经完全静止
        [self handleScroll];
    }
}

// 松手时还在运动, 先调用scrollViewDidEndDragging,在调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //scrollView已经完全静止
    [self handleScroll];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance && !self.isLoading && self.hasNextPage) {
        self.isLoading = YES;
        [self.tableView.mj_footer beginRefreshing];
    } else {
        if (self.isLoading) {
            self.isLoading = NO;
        }
    }
}

- (void)communityDetailDidChangeLikeStatus:(Moment *)model{
    for (int i=0; i<self.dataArray.count; i++) {
        HGThemeModel *modelGroup = self.dataArray[i];
        if ([model.Id integerValue] == [modelGroup.dynamicId integerValue]) {
            modelGroup.isAgreed = model.isAgreed;
            modelGroup.agreeCount = model.agreeCount;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:i]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

- (void)communityDetailDidChangeDisLikeStatus:(Moment *)model{
    for (int i=0; i<self.dataArray.count; i++) {
        HGThemeModel *modelGroup = self.dataArray[i];
        if ([model.Id integerValue] == [modelGroup.dynamicId integerValue]) {
            modelGroup.isDisagreed = model.isDisagreed;
            modelGroup.disagreeCount = model.disagreeCount;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:i]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
