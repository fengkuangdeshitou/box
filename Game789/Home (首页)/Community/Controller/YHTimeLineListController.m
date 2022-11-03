//
//  YHQAListController.m
//  github:  https://github.com/samuelandkevin
//
//  Created by samuelandkevin on 16/8/29.
//  Copyright © 2016年 HKP. All rights reserved.
//

#import "YHTimeLineListController.h"
#import "CellForWorkGroup.h"
#import "CellForWorkGroupRepost.h"
#import "YHRefreshTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "YHWorkGroup.h"
#import "YHUserInfoManager.h"
#import "YHUtils.h"
#import "YHSharePresentView.h"
#import "WRCustomNavigationBar.h"
#import "HGCommunityTHV.h"
#import "HGCommunityPushVC.h"
#import "HGCommunityDetailVC.h"
#import "SJVideoPlayer.h"
#import "HGThemeGoruminvitViewController.h"
#import "UserPersonalCenterController.h"

#import "MyCommunityRequestApi.h"
@class MyCommunityDisagreeApi;
@class MyCommunityCancleDisagreeApi;
@class MyCommunityAgreeApi;
@class MyCommunityCancleAgreeApi;
@class MyCommunityThemeRequestApi;

@interface YHTimeLineListController ()<UITableViewDelegate,UITableViewDataSource,CellForWorkGroupDelegate,CellForWorkGroupRepostDelegate,SJVideoPlayerControlLayerDelegate,HGCommunityTHVDelegate,HGThemeGoruminvitViewControllerDelegate,HGCommunityDetailVCDelegate>{
    int _currentRequestPage; //当前请求页面
    BOOL _reCalculate;
}

@property (nonatomic, strong) YHRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) HGCommunityTHV *tableHV;
@property (nonatomic, assign) NSDictionary *thvDataDic;
@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) CellForWorkGroupRepost * currentPlayingCell;
@property (nonatomic, assign) float tableViewOffY;  //记录tableview将要开始滑动时候的偏移量
//@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation YHTimeLineListController

- (void)community:(HGCommunityTHV *)community didSelectedItem:(NSDictionary *)item{
    HGThemeGoruminvitViewController * vc = [[HGThemeGoruminvitViewController alloc] init];
    vc.navBar.title = item[@"themename"];
    vc.themeId = item[@"id"];
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (HGCommunityTHV *)tableHV {
    if (_tableHV == nil) {
        _tableHV = [[HGCommunityTHV alloc]init];
        _tableHV.frame = CGRectMake(0, 0, kScreenW, _tableHV.view_height);
        _tableHV.delegate = self;
    }
    return _tableHV;
}

#pragma mark- HGThemeGoruminvitViewControllerDelegate
- (void)themeGoruminvitDidchangeLike:(HGThemeModel *)model{
    for (int i=0; i<self.dataArray.count; i++) {
        YHWorkGroup * workGroup = self.dataArray[i];
        if ([workGroup.dynamicId integerValue] == [model.dynamicId integerValue]) {
            workGroup.likeCount = model.agreeCount;
            workGroup.isAgreed = model.isAgreed;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

- (void)themeGoruminvitDidchangeDisLike:(HGThemeModel *)model{
    for (int i=0; i<self.dataArray.count; i++) {
        YHWorkGroup * workGroup = self.dataArray[i];
        if ([workGroup.dynamicId integerValue] == [model.dynamicId integerValue]) {
            workGroup.disagreeCount = model.disagreeCount;
            workGroup.isDisagreed = model.isDisagreed;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    [self upViewData];
    
    [self getCommunityData:YES];
}

- (void)upViewData
{
    WEAKSELF
    MyCommunityThemeRequestApi * api = [[MyCommunityThemeRequestApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSDictionary *dataDic = [request.data deleteAllNullValue];
            weakSelf.thvDataDic = dataDic;
            weakSelf.tableHV.dataDic = dataDic;
            weakSelf .tableView.tableHeaderView = weakSelf.tableHV;
            weakSelf.tableHV.frame = CGRectMake(0, 0, kScreenW, _tableHV.view_height);
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)initUI
{
    WEAKSELF
    self.navBar.title = self.user_name ? self.user_name : @"游戏圈子";
    [self.navBar wr_setRightButtonWithImage:MYGetImage(@"community_chatList")];
    [self.navBar setOnClickRightButton:^{
        [weakSelf pushCommunityAction];
    }];
}

- (YHRefreshTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[YHRefreshTableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kNavigationBarHeight + kTabbarHeight, 0);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[CellForWorkGroup class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroup class])];
        [_tableView registerClass:[CellForWorkGroupRepost class] forCellReuseIdentifier:NSStringFromClass([CellForWorkGroupRepost class])];
        self.view.backgroundColor = [UIColor whiteColor];
        _tableView.hidden = YES;
        
        _tableView.mj_header = [MFRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentRequestPage = 1;
            [self getCommunityData:NO];
        }];
        
        _tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _currentRequestPage ++;
            [self getCommunityData:NO];
        }];
    }
    return _tableView;
}

#pragma mark - Lazy Load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
//- (NSMutableArray *)listArray{
//    if (!_listArray) {
//        _listArray = [NSMutableArray array];
//    }
//    return _listArray;
//}

//发布话题
- (void)pushCommunityAction {
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
    HGCommunityPushVC * info = [HGCommunityPushVC new];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifity = @"CellForWorkGroupRepost";
    CellForWorkGroupRepost *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
    if (cell == nil) {
        cell = [[CellForWorkGroupRepost alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifity];
    }
    YHWorkGroup *model  = self.dataArray[indexPath.row];
    cell.indexPath = indexPath;
    cell.model = model;
    cell.delegate = self;
    return cell;
}

- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath
{
    CellForWorkGroupRepost *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (![cell isKindOfClass:[CellForWorkGroupRepost class]] || self.currentPlayingCell == cell)
    {
        return;
    }
        
    self.currentPlayingCell = nil;
    [_player stopAndFadeOut]; // 让旧的播放器淡出
    _player = [SJVideoPlayer player]; // 创建一个新的播放器
    _player.generatePreviewImages = NO; // 生成预览缩略图, 大概20张
    
    YHWorkGroup *model  = self.dataArray[indexPath.row];
    if (![model.video isKindOfClass:[NSDictionary class]] || model.video.allValues.count == 0)
    {
        return;
    }
    
//    if (![model.video isKindOfClass:[NSDictionary class]])
//    {
//        return;
//    }
//    else
//    {
//        if (self.currentPlayingCell)
//        {
//            self.currentPlayingCell.voiceBtn.hidden = YES;
//            self.currentPlayingCell.videoTimeView.hidden = YES;
//        }
//        cell.voiceBtn.hidden = NO;
//        cell.videoTimeView.hidden = NO;
//    }
#ifdef SJMAC
    _player.disablePromptWhenNetworkStatusChanges = YES;
#endif
    WEAKSELF
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:model.video[@"video"]] playModel:[SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:cell.videoView.coverImageView.tag atIndexPath:indexPath tableView:self.tableView]];
    _player.mute = YES;
//    _player.lockedScreen = YES;
    _player.disableAutoRotation = YES;
    _player.controlLayerDelegate = self;
    _player.autoPlayWhenPlayStatusIsReadyToPlay = YES;
    _player.placeholderImageView.image = cell.videoView.coverImageView.image;
//    cell.videoTimeLabel.text = _player.currentTimeStr;
//    _player.playTimeDidChangeExeBlok = ^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
//        cell.videoTimeLabel.text = videoPlayer.currentTimeStr;
//
////        HGLog(@"==============%lu", (unsigned long)videoPlayer.playStatus);
//        if (videoPlayer.playStatus == (SJVideoPlayerPlayStatusPlaying | SJVideoPlayerPlayStatusReadyToPlay) && weakSelf.currentPlayingCell != cell)
//        {
//
//        }
//    };
    
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

- (void)controlLayerNeedAppear:(__kindof SJBaseVideoPlayer *)videoPlayer
{
    YHWorkGroup *model = self.currentPlayingCell.model;
    HGCommunityDetailVC *info = [HGCommunityDetailVC new];
    info.commit_id = model.dynamicId;
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

- (void)videoPlayerWillDisappearInScrollView:(__kindof SJBaseVideoPlayer *)videoPlayer{
    self.currentPlayingCell = nil;
    [_player stopAndFadeOut]; // 让旧的播放器淡出
    _player = [SJVideoPlayer player]; // 创建一个新的播放器
    _player.generatePreviewImages = NO; // 生成预览缩略图, 大概20张
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
    //在可见cell中找到第一个有视频的cell
    CellForWorkGroupRepost  * videoCell = nil;
    for (CellForWorkGroupRepost *cell in visiableCells)
    {
        if ([cell.model.video isKindOfClass:[NSDictionary class]] && cell.model.video.allValues.count > 0)
        {
            videoCell = cell;
            break;
        }
    }
    //如果找到了, 就开始播放视频
    if (videoCell)
    {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:videoCell];
        [self sj_playerNeedPlayNewAssetAtIndexPath:indexPath];
    }
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

- (void)handleScroll
{
    NSIndexPath * middleIndexPath = [self.tableView  indexPathForRowAtPoint:CGPointMake(0, self.tableView.contentOffset.y + self.tableView.frame.size.height/2)];
    CellForWorkGroupRepost * cell = [self.tableView cellForRowAtIndexPath:middleIndexPath];
//    if ([cell.model.video isKindOfClass:[NSDictionary class]]) {
        [self sj_playerNeedPlayNewAssetAtIndexPath:middleIndexPath];
//    }
    
    return;
  // 找到下一个要播放的cell(最在屏幕中心的)
  CellForWorkGroupRepost *finnalCell = nil;
  NSArray *visiableCells = [self.tableView visibleCells];
  NSMutableArray *indexPaths = [NSMutableArray array];
  CGFloat gap = MAXFLOAT;
  for (CellForWorkGroupRepost *cell in visiableCells)
  {
      NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
      [indexPaths addObject:indexPath];
      if ([cell.model.video isKindOfClass:[NSDictionary class]] && cell.model.video.allValues.count > 0)
      { // 如果这个cell有视频
        CGPoint coorCentre = [cell.superview convertPoint:cell.center toView:nil];
        CGFloat delta = fabs(coorCentre.y-[UIScreen mainScreen].bounds.size.height*0.5);
        if (delta < gap) {
          gap = delta;
          finnalCell = cell;
        }
      }
   }
    if ([finnalCell isKindOfClass:[CellForWorkGroupRepost class]])
    {
        CellForWorkGroupRepost * cell = (CellForWorkGroupRepost *)finnalCell;
        if ([cell.model.video isKindOfClass:[NSDictionary class]] && cell.model.video.allValues.count > 0)
        {
            NSIndexPath * indexPath = [self.tableView indexPathForCell:finnalCell];
            [self sj_playerNeedPlayNewAssetAtIndexPath:indexPath];
            return;
        }
    }
    if ( !_player || !_player.isFullScreen ) {
        self.currentPlayingCell = nil;
        [_player stopAndFadeOut]; // 让旧的播放器淡出
        _player = [SJVideoPlayer player]; // 创建一个新的播放器
        _player.generatePreviewImages = NO; // 生成预览缩略图, 大概20张
        
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    if (indexPath.row < self.dataArray.count) {
        
        //原创cell
//        Class currentClass  = [CellForWorkGroup class];
        YHWorkGroup *model  = self.dataArray[indexPath.row];
        
        //转发cell
        if (model.type == DynType_Forward) {
            static NSString * cellIdentifity = @"CellForWorkGroupRepost";
            CellForWorkGroupRepost *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
            if (cell == nil) {
                return 0;
            }//第一版没有转发,因此这样稍该一下
            CGFloat tempHeight = [self.tableView fd_heightForCellWithIdentifier:cellIdentifity configuration:^(CellForWorkGroupRepost *cell) {
                [self configureRepostCell:cell atIndexPath:indexPath];
            }];
            return tempHeight;
        }
        else{
            CGFloat tempHeight = [self.tableView fd_heightForCellWithIdentifier:@"CellForWorkGroup" configuration:^(CellForWorkGroup *cell) {
                [self configureOriCell:cell atIndexPath:indexPath];
            }];
            return tempHeight;
        }
    }
    else{
        return 44.0f;
    }
}

- (void)configureOriCell:(CellForWorkGroup *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    if (indexPath.row < _dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    
}

- (void)configureRepostCell:(CellForWorkGroupRepost *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    if (indexPath.row < _dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YHWorkGroup *model = self.dataArray[indexPath.row];
    HGCommunityDetailVC *info = [HGCommunityDetailVC new];
    info.commit_id = model.dynamicId;
    info.delegate = self;
      info.hidesBottomBarWhenPushed = YES;
      [self.navigationController pushViewController:info animated:YES];
}

- (void)communityDetailDidChangeLikeStatus:(Moment *)model{
    for (int i=0; i<self.dataArray.count; i++) {
        YHWorkGroup *modelGroup = self.dataArray[i];
        if ([model.Id integerValue] == [modelGroup.dynamicId integerValue]) {
            modelGroup.isAgreed = model.isAgreed;
            modelGroup.likeCount = model.agreeCount;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

- (void)communityDetailDidChangeDisLikeStatus:(Moment *)model{
    for (int i=0; i<self.dataArray.count; i++) {
        YHWorkGroup *modelGroup = self.dataArray[i];
        if ([model.Id integerValue] == [modelGroup.dynamicId integerValue]) {
            modelGroup.isDisagreed = model.isDisagreed;
            modelGroup.disagreeCount = model.disagreeCount;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

#pragma mark - 网络请求
- (void)foruminvitListWithRequest
{
    
}

- (void)getCommunityData:(BOOL)isShow
{
    MyCommunityRequestApi * api = [[MyCommunityRequestApi alloc] init];
    api.pageNumber = _currentRequestPage;
    api.count = 10;
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSDictionary *dataDic = [request.data deleteAllNullValue];
             self.hasNextPage = [dataDic[@"paginated"][@"more"] boolValue];
             NSArray *array = dataDic[@"list"];
             if (_currentRequestPage == 1) {
                 [self.dataArray removeAllObjects];
             }
            for (int i = 0; i < array.count; i++) {
                 YHWorkGroup *model = [YHWorkGroup new];
                 [self randomModel:model dic:array[i]];
                 [self.dataArray addObject:model];
             }
            self.tableView.hidden = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            [self setFooterViewState:self.tableView Data:dataDic[@"paginated"] FooterView:[self creatFooterView]];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - 数据源
- (void)randomModel:(YHWorkGroup *)model dic:(NSDictionary *)dic{
    model.type = DynType_Forward;
    NSArray *array = dic[@"comments"];
    if (array.count > 0) {
        NSDictionary *dic = array[0];
        model.forwardModel = [YHWorkGroup new];
        [self creatCellModel:model.forwardModel dic:dic];
        model.commentsCell = 0;
    }else {
        model.commentsCell = 1;
    }
    [self creatOriModel:model dic:dic];
}

//评论cell的数据
- (void)creatCellModel:(YHWorkGroup *)model dic:(NSDictionary *)dic{
    model.likeCount = [dic[@"agreeCount"] intValue];
    model.msgContent = dic[@"content"];
    model.dynamicId = dic[@"id"];
    model.status = dic[@"status"];
    model.isAgreed = [dic[@"isAgreed"] boolValue];
    model.agreeCount = [dic[@"agreeCount"] intValue];
    model.publishTime = dic[@"publishTime"];
    YHUserInfo *userInfo = [YHUserInfo new];
    model.userInfo = userInfo;
    userInfo.userName = dic[@"user"][@"nickname"];
    userInfo.avatarUrl = dic[@"user"][@"avatar"];
    userInfo.uid = dic[@"user"][@"id"];
}
    
- (void)creatOriModel:(YHWorkGroup *)model dic:(NSDictionary *)dic
{
    YHUserInfo *userInfo = [YHUserInfo new];
    model.userInfo = userInfo;
    userInfo.userName = dic[@"user"][@"nickname"];
    userInfo.avatarUrl = dic[@"user"][@"avatar"];
    userInfo.uid = dic[@"user"][@"id"];
    userInfo.user_level = dic[@"user"][@"user_level"];
    
    model.video = dic[@"video"];
    model.themename = dic[@"themename"];
    model.themeId = dic[@"themeid"];
    model.dynamicId = dic[@"id"];
    model.msgContent = dic[@"content"];
    model.publishTime = dic[@"createtime"];
    model.likeCount = [dic[@"agreeCount"] intValue];
    model.agreeCount = [dic[@"agreeCount"] intValue];
    model.disagreeCount = [dic[@"disagreeCount"] intValue];
    model.commentCount = [dic[@"commentCount"] intValue];  //评论数
    model.isGodCom = [dic[@"isGodCom"] boolValue];
    NSArray *tempArray = dic[@"imgs"];
    model.isAgreed = [dic[@"isAgreed"] boolValue];
    model.isDisagreed = [dic[@"isDisagreed"] boolValue];
    model.publishTime = dic[@"publishTime"];
    NSMutableArray *oriPArr   = [NSMutableArray new];
    NSMutableArray *thumbPArr = [NSMutableArray new];
    for (int i = 0; i < tempArray.count; i++) {
        NSDictionary * dic = tempArray[i];
        NSString * original = dic[@"original"];
        NSString * medium   = dic[@"medium"];
        [oriPArr addObject:[NSURL URLWithString:original]];
        [thumbPArr addObject:[NSURL URLWithString:medium]];
    }
    
    model.originalPicUrls  = oriPArr;
    model.thumbnailPicUrls = thumbPArr;
}

#pragma mark - YHRefreshTableViewDelegate
- (void)refreshTableViewLoadNew:(YHRefreshTableView*)view
{
    
}

- (void)refreshTableViewLoadmore:(YHRefreshTableView*)view
{
    
}

#pragma mark - CellForWorkGroupDelegate
- (void)onAvatarInCell:(CellForWorkGroup *)cell
{
    
}

- (void)onMoreInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        model.isOpening = !model.isOpening;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)onCommentInCell:(CellForWorkGroup *)cell{

}

- (void)onLikeInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        
        BOOL isLike = !model.isLike;
        
        model.isLike = isLike;
        if (isLike) {
            model.likeCount += 1;
            
        }else{
            model.likeCount -= 1;
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }

}

- (void)onShareInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]){
        [self _shareWithCell:cell];
    }
}


- (void)onDeleteInCell:(CellForWorkGroup *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        [self _deleteDynAtIndexPath:cell.indexPath dynamicId:cell.model.dynamicId];
    }
}

#pragma mark - CellForWorkGroupRepostDelegate

- (void)onAvatarInRepostCell:(CellForWorkGroupRepost *)cell
{
//    UserPersonalCenterController * center = [UserPersonalCenterController new];
//    center.user_id = cell.model.userInfo.uid;
//    [self.navigationController pushViewController:center animated:YES];
}


- (void)onTapRepostViewInCell:(CellForWorkGroupRepost *)cell
{
    
}

- (void)onCommentInRepostCell:(CellForWorkGroupRepost *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        
        if (![YYToolModel isAlreadyLogin]) {
            return;
        }
        WEAKSELF
        if (!model.isDisagreed)
        {
            MyCommunityDisagreeApi * api = [[MyCommunityDisagreeApi alloc] init];
            api.isShow = YES;
            api.detailId = model.dynamicId;
            [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
                if (request.success == 1)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        model.disagreeCount = model.disagreeCount + 1;
                        cell.viewBottom.dislikeCount.text = [NSString stringWithFormat:@"%d", model.disagreeCount];
                        model.isDisagreed = YES;
                        cell.viewBottom.dislikeBtn.selected = model.isAgreed;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    });
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        model.disagreeCount = model.disagreeCount - 1;
                        cell.viewBottom.dislikeCount.text = [NSString stringWithFormat:@"%d", model.disagreeCount];
                        model.isDisagreed = NO;
                        cell.viewBottom.dislikeBtn.selected = model.isAgreed;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    });
                }
                else
                {
                    [MBProgressHUD showToast:api.error_desc toView:self.view];
                }
            } failureBlock:^(BaseRequest * _Nonnull request) {
                
            }];
        }
    }
}

- (void)onLikeInRepostCell:(CellForWorkGroupRepost *)cell
{
    if (cell.indexPath.row < [self.dataArray count])
    {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];

        if (![YYToolModel isAlreadyLogin]) {
            return;
        }
        WEAKSELF
        if (!model.isAgreed)
        {
            MyCommunityAgreeApi * api = [[MyCommunityAgreeApi alloc] init];
            api.isShow = YES;
            api.detailId = model.dynamicId;
            [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
                if (request.success == 1)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        model.likeCount = model.likeCount + 1;
                        cell.viewBottom.likeCount.text = [NSString stringWithFormat:@"%d", model.likeCount];
                        model.isAgreed = YES;
                        cell.viewBottom.likeBtn.selected = model.isAgreed;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    });
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
                    dispatch_async(dispatch_get_main_queue(), ^{
                        model.likeCount = model.likeCount - 1;
                        cell.viewBottom.likeCount.text = [NSString stringWithFormat:@"%d", model.likeCount];
                        model.isAgreed = NO;
                        cell.viewBottom.likeBtn.selected = model.isAgreed;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    });
                }
                else
                {
                    [MBProgressHUD showToast:api.error_desc toView:self.view];
                }
            } failureBlock:^(BaseRequest * _Nonnull request) {
                
            }];
        }
    }
}

- (void)onShareInRepostCell:(CellForWorkGroupRepost *)cell{
    //评论按钮
    if (cell.indexPath.row < [self.dataArray count]){
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        HGCommunityDetailVC *info = [HGCommunityDetailVC new];
        info.commit_id = model.dynamicId;
        info.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:info animated:YES];
    }
}

- (void)onDeleteInRepostCell:(CellForWorkGroupRepost *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        [self _deleteDynAtIndexPath:cell.indexPath dynamicId:cell.model.dynamicId];
    }
}

- (void)onMoreInRespostCell:(CellForWorkGroupRepost *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        model.isOpening = !model.isOpening;
        [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)onTagTapRespostCell:(CellForWorkGroupRepost *)cell{
    if (cell.indexPath.row < [self.dataArray count]) {
        YHWorkGroup *model = self.dataArray[cell.indexPath.row];
        HGThemeGoruminvitViewController * theme = [[HGThemeGoruminvitViewController alloc] init];
        theme.themeId = model.themeId;
        theme.delegate = self;
        theme.navBar.title = model.themename;
        theme.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:theme animated:YES];
    }
}

#pragma mark - private
- (void)_deleteDynAtIndexPath:(NSIndexPath *)indexPath dynamicId:(NSString *)dynamicId{
    
    WEAKSELF
    [YHUtils showAlertWithTitle:@"删除动态" message:@"您确定要删除此动态?" okTitle:@"确定" cancelTitle:@"取消" inViewController:self dismiss:^(BOOL resultYes) {
        
        if (resultYes)
        {

            MYLog(@"delete row is %ld",(long)indexPath.row);
                    
            [weakSelf.dataArray removeObjectAtIndex:indexPath.row];
     
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
   
        }
    }];
    
}

- (void)_shareWithCell:(UITableViewCell *)cell{
    
    CellForWorkGroup *cellOri     = nil;
    CellForWorkGroupRepost *cellRepost = nil;
    BOOL isRepost = NO;
    if ([cell isKindOfClass:[CellForWorkGroup class]]) {
        cellOri = (CellForWorkGroup *)cell;
    }
    else if ([cell isKindOfClass:[CellForWorkGroupRepost class]]) {
        cellRepost = (CellForWorkGroupRepost *)cell;
        isRepost   = YES;
    }
    else
        return;
    
    
    YHWorkGroup *model = [YHWorkGroup new];
    if (isRepost) {
        model = cellRepost.model.forwardModel;
    }
    else{
        model = cellOri.model;
    }
    
    YHSharePresentView *shareView = [[YHSharePresentView alloc] init];
    shareView.shareType = ShareType_WorkGroup;
    [shareView show];
    [shareView dismissHandler:^(BOOL isCanceled, NSInteger index) {
        if (!isCanceled) {
            switch (index)
            {
                case 2:
                {
                    MYLog(@"动态");
                }
                    break;
                case 3:
                {

                }
                    break;
                    
                case 0:
                {
                    //朋友圈
                    MYLog(@"朋友圈");
                    
                }
                    break;
                case 1:
                {
                    //微信好友
                    MYLog(@"微信好友");
                   
                }
                    break;
                default:
                    break;
            }
        }
    }];
}


#pragma mark - tableview没有数据时候的设置
- (void)setFooterViewState:(UITableView *)tableView Data:(NSDictionary *)dic FooterView:(UIView *)headerView {
   if (self.hasNextPage == 0){
        [tableView.mj_footer endRefreshingWithNoMoreData];
        tableView.mj_footer.state = MJRefreshStateNoMoreData;
        tableView.tableFooterView = [dic[@"totalCount"] integerValue] > 6 ? headerView : [UIView new];
    }else {
        tableView.tableFooterView = [UIView new];
    }
}
@end
