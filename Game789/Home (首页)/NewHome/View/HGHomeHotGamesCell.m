//
//  HGHomeRecommendGamesCell.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGHomeHotGamesCell.h"
#import "HGHotGamesListCell.h"
#import "MyPopularityListCollectionCell.h"
#import "MyHotGameClassifyCell.h"
#import "MyHomeHotGameListCell.h"
#import <SJBaseVideoPlayer+PlayStatus.h>
#import "MyGuessLikeGamesCell.h"
#import "HomeListTableViewCell.h"
#import "GameTableViewCell.h"
#import "HomeTypeApi.h"
#import "GameModel.h"
@class StageABTestApi;

#define HotGameContentOffWidth 45

@implementation HGHomeHotGamesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    footer.backgroundColor = UIColor.clearColor;
    self.tableView.tableFooterView = footer;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.clipsToBounds = NO;
    self.collectionView.layer.masksToBounds = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HGHotGamesListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HGHotGamesListCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyNewGameReserveListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyNewGameReserveListCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyPopularityListCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyPopularityListCollectionCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyHotGameClassifyCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyHotGameClassifyCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyGuessLikeGamesCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyGuessLikeGamesCell"];
    [self.collectionView registerClass:[MyHomeHotGameListCell class] forCellWithReuseIdentifier:@"MyHomeHotGameListCell"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:nil] forCellReuseIdentifier:@"GameTableViewCell"];
    
    [self.moreBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
}

- (XHPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[XHPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, 56 + 270, kScreenW, 20);
        _pageControl.delegate = self;
        _pageControl.otherColor = FontColorDE;
        _pageControl.currentColor = MAIN_COLOR;
//        _pageControl.backgroundColor = UIColor.redColor;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (void)setType:(NSString *)type
{
    _type = type;
    
    if ([self.type isEqualToString:@"hot"])
    {
        self.collectionView_left.constant = 0;
        self.collectionView_right.constant = 0;
        self.collectionView.pagingEnabled = YES;
        self.collectionView_top.constant = 10;
        self.collectionView_bottom.constant = 20;
        self.pageControl.hidden = NO;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //ab测试显示
        if (self.ab_test_index_swiper == 1)
        {
            self.pageControl.hidden = NO;
            self.collectionView.hidden = NO;
            self.tableView.hidden = YES;
        }
        else
        {
            self.pageControl.hidden = YES;
            self.collectionView.hidden = YES;
            self.tableView.hidden = NO;
        }
    }
    else if ([self.type isEqualToString:@"starting"])
    {
        self.collectionView_left.constant = 0;
        self.collectionView_right.constant = 0;
        self.collectionView_bottom.constant = 0;
        self.pageControl.hidden = YES;
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        self.collectionView.pagingEnabled = NO;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    }
    else
    {
        self.collectionView_left.constant = 15;
        self.collectionView_right.constant = 15;
        self.collectionView_top.constant = 20;
        self.collectionView_bottom.constant = 0;
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
        self.pageControl.hidden = YES;
        self.collectionView.pagingEnabled = NO;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([self.type isEqualToString:@"reserve"] || [self.type isEqualToString:@"starting"])
    {
        self.moreBtn.hidden = NO;
    }
    else
    {
        self.moreBtn.hidden = YES;
    }
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    if ([self.type isEqualToString:@"hot"])
    {
        NSInteger count = 0;
        for (int i = 0; i < dataArray.count; i ++)
        {
            count = dataArray.count / 3;
            NSInteger index = dataArray.count % 3;
            if (index > 0) count = count + 1;
        }
        self.pageControl.numberOfPages = count;
    }
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView setNeedsLayout];
        [self.tableView layoutIfNeeded];

        NSString * key = self.showTitle.text;
        CGFloat cacheHeight = [YYToolModel getHomeCellForKey:key];
        CGFloat contentHeight = floor(self.tableView.contentSize.height);
        if (cacheHeight != contentHeight) {
            [YYToolModel saveHeight:contentHeight forKey:key];
            if (self.UpdateRelatedGames) {
                self.UpdateRelatedGames();
            }
        }
    });
//        NSString * contentHeight = [NSString stringWithFormat:@"%.0f",floor(self.tableView.contentSize.height)];
//        if (![NSUserDefaults.standardUserDefaults objectForKey:key]) {
//            [NSUserDefaults.standardUserDefaults setObject:contentHeight forKey:key];
//            [NSUserDefaults.standardUserDefaults synchronize];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (self.UpdateRelatedGames) {
//                    self.UpdateRelatedGames();
//                }
//            });
//        }else{
//            CGFloat height = [[NSUserDefaults.standardUserDefaults objectForKey:key] floatValue];
//            if (height != contentHeight.floatValue) {
//                [NSUserDefaults.standardUserDefaults removeObjectForKey:key];
//                if (self.UpdateRelatedGames) {
//                    self.UpdateRelatedGames();
//                }
//            }
//        }
//    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"GameTableViewCell";
    GameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    NSDictionary * data = self.dataArray[indexPath.section];
    cell.currentVC = self.currentVC;
    cell.source = self.source;
    [cell setModelDic:data];
    cell.downloadBtnClick = ^(NSDictionary *dic) {
        NSDictionary * dic1 = @{@"gameName":dic[@"game_name"]};
        NSDictionary * dic2 = @{@"gameName":dic[@"game_name"], @"ab_test1":[NSString stringWithFormat:@"%ld", (long)self.ab_test_index_swiper]};
        [MyAOPManager relateStatistic:@"DownloadGameFromTheHomePageTopic" Info:self.is_985 ? dic2 : dic1];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * gameName = self.dataArray[indexPath.section][@"game_name"];
    NSDictionary * dic = @{@"title":self.showTitle.text,@"gameName":gameName};
    NSDictionary * dic1 = @{@"title":self.showTitle.text, @"ab_test1":[NSString stringWithFormat:@"%ld", (long)self.ab_test_index_swiper]};
    [MyAOPManager relateStatistic:@"ClickTheGameInTheTopic" Info:self.is_985 ? dic1 : dic];
    
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.hidesBottomBarWhenPushed = YES;
    info.gameID = self.dataArray[indexPath.section][@"game_id"];
    [self.currentVC.navigationController pushViewController:info animated:YES];
    
//    if (self.is_985)
//    {
//        [self stageABTest];
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView\
{
    return self.dataArray.count > 6 ? 6 : self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * data = self.dataArray[indexPath.section];
    GameModel * model = [GameModel mj_objectWithKeyValues:data];
    return model.cellHeight + 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    view.backgroundColor = UIColor.clearColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    view.backgroundColor = UIColor.clearColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
/**  分区个数  */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/** 每个分区item的个数  */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.type isEqualToString:@"hot"])
    {
        NSInteger count = self.dataArray.count / 3;
        NSInteger index = self.dataArray.count % 3;
        if (index > 0) count = count + 1;
        return count;
//        return 1;
    }
    else if ([self.type isEqualToString:@"youLike"])
    {
        return self.dataArray.count > 3 ? 3 : self.dataArray.count;
    }
    else
    {
        return self.dataArray.count;
    }
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToString:@"hot"])
    {
        static NSString *cellIndentifer = @"HGHotGamesListCell";
        HGHotGamesListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
        NSInteger count = self.dataArray.count / 3;
        NSInteger index = self.dataArray.count % 3;
        NSMutableArray * array = [NSMutableArray array];
        if (indexPath.item < count)
        {
            [array addObject:self.dataArray[indexPath.item * 3]];
            [array addObject:self.dataArray[indexPath.item * 3 + 1]];
            [array addObject:self.dataArray[indexPath.item * 3 + 2]];
            cell.backView2.hidden = NO;
            cell.backView3.hidden = NO;
        }
        else
        {
            if (index == 1)
            {
                [array addObject:self.dataArray[indexPath.item * 3]];
                cell.backView2.hidden = YES;
                cell.backView3.hidden = YES;
            }
            else if (index == 2)
            {
                [array addObject:self.dataArray[indexPath.item * 3]];
                [array addObject:self.dataArray[indexPath.item * 3 + 1]];
                cell.backView2.hidden = NO;
                cell.backView3.hidden = YES;
            }
        }
        cell.is_985 = self.is_985;
        cell.ab_test_index_swiper = self.ab_test_index_swiper;
        cell.dataArray = array;
        cell.showTitle = self.showTitle.text;
        
//        static NSString *cellIndentifer = @"MyHomeHotGameListCell";
//        MyHomeHotGameListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
//        cell.dataArray = self.dataArray;
        return cell;
    }
    else if ([self.type isEqualToString:@"reserve"])
    {
        static NSString *cellID = @"MyNewGameReserveListCell";
        MyNewGameReserveListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.type = self.type;
        cell.dataDic = self.dataArray[indexPath.item];
        return cell;
    }
    else if ([self.type isEqualToString:@"starting"])
    {
        static NSString *cellIndentifer = @"MyPopularityListCollectionCell";
        MyPopularityListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
        cell.type = self.type;
        cell.dataDic = self.dataArray[indexPath.item];
        return cell;
    }
    else if ([self.type isEqualToString:@"youLike"])
    {
        static NSString *cellIndentifer = @"MyGuessLikeGamesCell";
        MyGuessLikeGamesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
        cell.dataDic = self.dataArray[indexPath.item];
        return cell;
    }
    else
    {
        static NSString *cellIndentifer = @"cell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
        return cell;
    }
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToString:@"video"] || [self.type isEqualToString:@"reserve"])
    {
        return CGSizeMake(kScreenW - 15 * 2 - 10 - 15, collectionView.height);
    }
    else if ([self.type isEqualToString:@"starting"])
    {
        return CGSizeMake(128, collectionView.height);
    }
    else if ([self.type isEqualToString:@"hot"])
    {
        return CGSizeMake(kScreenW - HotGameContentOffWidth, collectionView.height);
    }
    else if ([self.type isEqualToString:@"project"])
    {
        return CGSizeMake(84, 120);
    }
    else if ([self.type isEqualToString:@"classify"])
    {
        return CGSizeMake((collectionView.width - 3 * 16.5) / 4, 32);
    }
    else if ([self.type isEqualToString:@"youLike"])
    {
        CGFloat cellWidth = (collectionView.width - 2 * 10) / 3;
        return CGSizeMake(cellWidth, collectionView.height);
    }
    return CGSizeMake(kScreenW - 15 * 2 - 10 - 15, collectionView.height);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**  分区内cell之间的最小行间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if ([self.type isEqualToString:@"classify"])
    {
        return 15;
    }
    else if ([self.type isEqualToString:@"hot"])
    {
        return 0;
    }
    return 10;
}

/**  分区内cell之间的最小列间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if ([self.type isEqualToString:@"project"])
    {
        return (kScreenW - 30 - 20 - 84 * 3) / 3;
    }
    else if ([self.type isEqualToString:@"classify"])
    {
        return 16.5;
    }
    return 0;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld分item", (long)indexPath.item);
    
    if ([self.type isEqualToString:@"classify"])
    {
        UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
        [nav.tabBarController setSelectedIndex:1];
        //如果游戏大厅控制器没有初始化
        if ([DeviceInfo shareInstance].isClickGameHall)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectGameType" object:self.dataArray[indexPath.item][@"game_classify_id"]];
        }
        else
        {
            [YYToolModel saveUserdefultValue:[NSString stringWithFormat:@"%@", self.dataArray[indexPath.item][@"game_classify_id"]] forKey:@"game_classify_id"];
        }
    }
    else if ([self.type isEqualToString:@"video"] || [self.type isEqualToString:@"reserve"] || [self.type isEqualToString:@"starting"] || [self.type isEqualToString:@"youLike"])
    {
        [MyAOPManager relateStatistic:@"ClickTheGameInTheTopic" Info:@{@"title":self.showTitle.text}];
        
        GameDetailInfoController * info = [GameDetailInfoController new];
        info.hidesBottomBarWhenPushed = YES;
        info.isReserve = [self.type isEqualToString:@"reserve"] ? YES : NO;
        info.gameID = self.dataArray[indexPath.row][@"game_id"];
        [self.currentVC.navigationController pushViewController:info animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    NSLog(@">>>>>>>%.1f",targetContentOffset->x);
    if ([self.type isEqualToString:@"hot"])
    {
        
    }
}

- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath
{
    MyNewGameReserveListCell * cell = (MyNewGameReserveListCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
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
        _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:cell.dataDic[@"video_url"]] playModel:[SJPlayModel UICollectionViewCellPlayModelWithPlayerSuperviewTag:100 atIndexPath:indexPath collectionView:self.collectionView]];
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
        [weakSelf.player play];
}

- (void)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer statusDidChanged:(SJVideoPlayerPlayStatus)status
{
    MYLog(@"---------%lu", (unsigned long)status);
    if (status == 5)
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
    NSArray *visiableCells = [self.collectionView visibleCells];
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
    if (videoCell)
    {
        NSIndexPath * indexPath = [self.collectionView indexPathForCell:videoCell];
        [self sj_playerNeedPlayNewAssetAtIndexPath:indexPath];
    }
}

- (void)handleScroll
{
  // 找到下一个要播放的cell(最在屏幕中心的)
  MyNewGameReserveListCell *finnalCell = nil;
  NSArray *visiableCells = [self.collectionView visibleCells];
  NSMutableArray *indexPaths = [NSMutableArray array];
  CGFloat gap = MAXFLOAT;
  for (MyNewGameReserveListCell *cell in visiableCells)
  {
      NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
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
            NSIndexPath * indexPath = [self.collectionView indexPathForCell:finnalCell];
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
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO && [self.type isEqualToString:@"video"])
    {
        // scrollView已经完全静止
        [self handleScroll];
    }
}

// 松手时还在运动, 先调用scrollViewDidEndDragging,在调用scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //scrollView已经完全静止
    if ([self.type isEqualToString:@"video"])
    {
        [self handleScroll];
    }
    else if ([self.type isEqualToString:@"hot"])
    {
        NSInteger page = scrollView.contentOffset.x / scrollView.width;
        NSInteger count = self.dataArray.count / 3;
        NSInteger index = self.dataArray.count % 3;
        if (index > 0) count = count + 1;
        //分页控制器
        self.pageControl.currentPage = page;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.collectionView setContentOffset:CGPointMake((ScreenWidth-HotGameContentOffWidth)*page, 0)];
//            self.collectionView_right.constant = page == (count - 1) ? HotGameContentOffWidth : 0;
        }completion:^(BOOL finished) {
            self.collectionView_right.constant = page == (count - 1) ? HotGameContentOffWidth : 0;
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.type isEqualToString:@"hot"])
    {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.collectionView_right.constant = HotGameContentOffWidth;
//        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        if ([self.type isEqualToString:@"hot"]){
            self.collectionView_right.constant = HotGameContentOffWidth;
        }
    }
}

- (void)stageABTest
{
    StageABTestApi * api = [[StageABTestApi alloc] init];
    api.name = @"ab_test_index_swiper";
    api.value = [NSString stringWithFormat:@"%ld", (long)self.ab_test_index_swiper];
    api.ab_test_stage = @"2";
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

@end
