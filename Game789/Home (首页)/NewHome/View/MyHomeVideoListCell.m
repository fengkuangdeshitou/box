//
//  MyHomeVideoListCell.m
//  Game789
//
//  Created by Maiyou on 2020/8/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyHomeVideoListCell.h"

@interface MyHomeVideoListCell ()

@property(nonatomic,assign)NSInteger index;

@end

@implementation MyHomeVideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = UIColor.whiteColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (WSLRollView *)pageRollView
{
    if (!_pageRollView)
    {
        CGFloat viewWidth = kScreenW - 15 * 2 - 2 * 13 - 42;
        WSLRollView * pageRollView = [[WSLRollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, (viewWidth * 9 / 16) + 74)];
        pageRollView.sourceArray = [NSMutableArray arrayWithArray:self.dataArray];
        pageRollView.backgroundColor = [UIColor whiteColor];
        pageRollView.scrollStyle = WSLRollViewScrollStylePage;
        pageRollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        pageRollView.interval = 0;
        pageRollView.loopEnabled = NO;
        pageRollView.delegate = self;
        pageRollView.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [pageRollView registerNib:[UINib nibWithNibName:@"MyNewGameReserveListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PageRollID"];
        [self.backView addSubview:pageRollView];
        _pageRollView = pageRollView;
        
        [self.contentView layoutIfNeeded];
    }
    return _pageRollView;
}

- (void)setType:(NSString *)type
{
    _type = type;
    
    self.moreView.hidden = [type isEqualToString:@"video"];
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    
    if (dataArray.count > 0)
    {
        self.pageRollView.sourceArray = [NSMutableArray arrayWithArray:dataArray];
        [self.pageRollView reloadData];
    }
}

#pragma mark - WSLRollViewDelegate
//返回itemSize
- (CGSize)rollView:(WSLRollView *)rollView sizeForItemAtIndex:(NSInteger)index{
    
    CGFloat viewWidth = kScreenW - 15 * 2 - 13 * 2 - 42;
    return CGSizeMake(viewWidth, (viewWidth * 9 / 16) + 74);
}

//间隔
- (CGFloat)spaceOfItemInRollView:(WSLRollView *)rollView
{
    return 15;
}

//内边距
- (UIEdgeInsets)paddingOfRollView:(WSLRollView *)rollView
{
    return UIEdgeInsetsMake(0,15,0,15);
}

//点击事件
- (void)rollView:(WSLRollView *)rollView didSelectItemAtIndex:(NSInteger)index
{
    self.index = index;
    //专题游戏的点击统计
    [MyAOPManager gameRelateStatistic:@"ClickTheGameInTheTopic" GameInfo:self.dataArray[index] Add:@{@"title":self.showTitle.text}];
    WEAKSELF;
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.hidesBottomBarWhenPushed = YES;
    info.isReserve = [self.type isEqualToString:@"reserve"] ? YES : NO;
    info.gameID = self.dataArray[index][@"game_id"];
    info.previewAction = ^(BOOL isReserved) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:self.dataArray[self.index]];
        dic[@"is_reserve"] = [NSNumber numberWithBool:isReserved];
        [weakSelf.dataArray replaceObjectAtIndex:index withObject:dic];
        [rollView.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    };
    [self.currentVC.navigationController pushViewController:info animated:YES];
}

//返回自定义cell样式
-(WSLRollViewCell *)rollView:(WSLRollView *)rollView cellForItemAtIndex:(NSInteger)index
{
    MyNewGameReserveListCell * cell = (MyNewGameReserveListCell *)[rollView dequeueReusableCellWithReuseIdentifier:@"PageRollID" forIndex:index];
    cell.type = self.type;
    cell.dataDic = self.dataArray[index];
    cell.playBtnAction = ^{
        self.player.view.hidden = NO;
        [self.player play];
    };
    WEAKSELF;
    cell.receiveBtnAction = ^(BOOL receive) {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:self.dataArray[index]];
        dic[@"is_reserve"] = [NSNumber numberWithBool:receive];
        [weakSelf.dataArray replaceObjectAtIndex:index withObject:dic];
        [rollView.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    };
    return cell;
}

- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath
{
    MyNewGameReserveListCell * cell = (MyNewGameReserveListCell *)[self.pageRollView.collectionView cellForItemAtIndexPath:indexPath];
    
    if (![cell isKindOfClass:[MyNewGameReserveListCell class]] || self.currentPlayingCell == cell) return;
    if ( !_player || !_player.isFullScreen ) {
        _currentPlayingCell = nil;
        [_player stopAndFadeOut]; // 让旧的播放器淡出
        _player = [SJVideoPlayer player]; // 创建一个新的播放器
        _player.generatePreviewImages = NO; // 生成预览缩略图, 大概20张
    }
    if ([cell.dataDic[@"video_url"] isBlankString])
    {
        return;
    }
#ifdef SJMAC
    _player.disablePromptWhenNetworkStatusChanges = YES;
#endif
    
    WEAKSELF
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:cell.dataDic[@"video_url"]] playModel:[SJPlayModel UICollectionViewCellPlayModelWithPlayerSuperviewTag:100 atIndexPath:indexPath collectionView:self.pageRollView.collectionView]];
    _player.mute = YES;
//    _player.lockedScreen = YES;
    _player.disableAutoRotation = YES;
    _player.controlLayerDelegate = self;
    _player.autoPlayWhenPlayStatusIsReadyToPlay = YES;
    // fade in(淡入)
    weakSelf.player.view.alpha = 0.001;
    [UIView animateWithDuration:0.6 animations:^{
        weakSelf.player.view.alpha = 1;
    }];
    [cell.coverImage addSubview:weakSelf.player.view];
    [weakSelf.player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    weakSelf.currentPlayingCell = cell;
    if (self.player.networkStatus == SJNetworkStatus_ReachableViaWiFi)
    {
        weakSelf.player.view.hidden = NO;
        cell.playBtn.hidden = YES;
        [weakSelf.player play];
    }
    else
    {
        weakSelf.player.view.hidden = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.player pause];
        });
        cell.playBtn.hidden = NO;
    }
}

- (void)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer statusDidChanged:(SJVideoPlayerPlayStatus)status
{
    MYLog(@"---------%lu", (unsigned long)status);
    if (status == 5 && self.player.networkStatus == SJNetworkStatus_ReachableViaWiFi)
    {
        [self.player replay];
    }
}

- (void)controlLayerNeedAppear:(__kindof SJBaseVideoPlayer *)videoPlayer
{
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.hidesBottomBarWhenPushed = YES;
    info.gameID = self.currentPlayingCell.dataDic[@"game_id"];
    [self.currentVC.navigationController pushViewController:info animated:YES];
}

- (void)controlLayerNeedDisappear:(__kindof SJBaseVideoPlayer *)videoPlayer
{
    
}

- (void)playVideoInVisiableCells
{
    NSArray *visiableCells = [self.pageRollView.collectionView visibleCells];
    //在可见cell中找到第一个有视频的cell
    MyNewGameReserveListCell  * videoCell = nil;
    for (MyNewGameReserveListCell *cell in visiableCells)
    {
        if (![cell.dataDic[@"video_url"] isBlankString])
        {
            videoCell = cell;
            break;
        }
    }
    //如果找到了, 就开始播放视频
    if (videoCell && self.player.networkStatus == SJNetworkStatus_ReachableViaWiFi)
    {
        NSIndexPath * indexPath = [self.pageRollView.collectionView indexPathForCell:videoCell];
        [self sj_playerNeedPlayNewAssetAtIndexPath:indexPath];
    }
}

- (void)handleScroll
{
  // 找到下一个要播放的cell(最在屏幕中心的)
  MyNewGameReserveListCell *finnalCell = nil;
  NSArray *visiableCells = [self.pageRollView.collectionView visibleCells];
  NSMutableArray *indexPaths = [NSMutableArray array];
  CGFloat gap = MAXFLOAT;
  for (MyNewGameReserveListCell *cell in visiableCells)
  {
      NSIndexPath * indexPath = [self.pageRollView.collectionView indexPathForCell:cell];
      [indexPaths addObject:indexPath];
 
      if (![cell.dataDic[@"video_url"] isBlankString]) { // 如果这个cell有视频
        CGPoint coorCentre = [cell.superview convertPoint:cell.center toView:nil];
        CGFloat delta = fabs(coorCentre.x-[UIScreen mainScreen].bounds.size.width*0.5);
        if (delta < gap) {
          gap = delta;
          finnalCell = cell;
        }
      }
   }
    if ([finnalCell isKindOfClass:[MyNewGameReserveListCell class]])
    {
        MyNewGameReserveListCell * cell = (MyNewGameReserveListCell *)finnalCell;
        if (![cell.dataDic[@"video_url"] isBlankString])
        {
            NSIndexPath * indexPath = [self.pageRollView.collectionView indexPathForCell:finnalCell];
            [self sj_playerNeedPlayNewAssetAtIndexPath:indexPath];
            return;
        }
    }
    if ( !_player || !_player.isFullScreen ) {
        _currentPlayingCell = nil;
        [_player stopAndFadeOut]; // 让旧的播放器淡出
        _player = [SJVideoPlayer player]; // 创建一个新的播放器
        _player.generatePreviewImages = NO; // 生成预览缩略图, 大概20张
    }
}

// 松手时已经静止,只会调用scrollViewDidEndDragging
- (void)wSLRollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO && [self.type isEqualToString:@"video"])
    {
        // scrollView已经完全静止
        [self handleScroll];
    }
}

// 松手时还在运动, 先调用scrollViewDidEndDragging,在调用scrollViewDidEndDecelerating
- (void)wSLRollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //scrollView已经完全静止
    if ([self.type isEqualToString:@"video"])
    {
        [self handleScroll];
    }
}


@end
