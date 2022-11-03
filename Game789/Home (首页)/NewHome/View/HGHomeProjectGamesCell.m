//
//  HGHomeRecommendGamesCell.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGHomeProjectGamesCell.h"
#import "HGHotGamesListCell.h"
#import "MyPopularityListCollectionCell.h"
#import "MyShowProjectGameCell.h"
#import "MyHotGameClassifyCell.h"

@implementation HGHomeProjectGamesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyShowProjectGameCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyShowProjectGameCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyHotGameClassifyCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyHotGameClassifyCell"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.moreBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
    
    self.collectionView.layer.cornerRadius = 13;
    self.collectionView.layer.masksToBounds = YES;
    
}

- (void)setType:(NSString *)type
{
    _type = type;
    
    if ([self.type isEqualToString:@"project"])
    {
        self.moreBtn.hidden = NO;
    }
    else if ([self.type isEqualToString:@"banner"])
    {
        self.showTitle_top.constant = 15;
        self.showTitle_left.constant = 15;
        self.moreBtn.hidden = NO;
        self.colorView.backgroundColor = BackColor;
        self.collectionView.backgroundColor = UIColor.whiteColor;
        self.collectionView_bottom.constant = 0;
        self.moreBurron_right.constant = 15;
    }
    else if ([self.type isEqualToString:@"classify"]) {
        self.showTitle_top.constant = 20;
        self.collectionView_bottom.constant = 0;
        self.collectionView.backgroundColor = BackColor;
        self.titleImageLeftConstraint.constant = 0;
    }
    else
    {
        self.moreBtn.hidden = YES;
    }
    self.collectionView_left.constant = 15;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showTitle.text = dataDic[@"game_classify_name"];
    
    self.dataArray = dataDic[@"game_list"];
    
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    if ([self.type isEqualToString:@"project"] || [self.type isEqualToString:@"banner"])
    {
        return self.dataArray.count > 6 ? 6 : self.dataArray.count;
    }
    else
    {
        return self.dataArray.count;
    }
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToString:@"project"] || [self.type isEqualToString:@"banner"])
    {
        static NSString *cellIndentifer = @"MyShowProjectGameCell";
        MyShowProjectGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
        cell.type = self.type;
        cell.dataDic = self.dataArray[indexPath.item];
        return cell;
    }
    else if ([self.type isEqualToString:@"classify"])
    {
        static NSString *cellIndentifer = @"MyHotGameClassifyCell";
        MyHotGameClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
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
    if ([self.type isEqualToString:@"project"])
    {
        return CGSizeMake((kScreenW - 30 - 46) / 3, 107 + 20);
    }
    else if ([self.type isEqualToString:@"banner"])
    {
        return CGSizeMake((kScreenW - 30 - 80) / 3, 109 + 20);
    }
    else if ([self.type isEqualToString:@"classify"])
    {
        return CGSizeMake((collectionView.width - 30) / 3, 43);
    }
    return CGSizeMake(kScreenW - 15 * 2 - 10 - 15, collectionView.height);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([self.type isEqualToString:@"project"])
    {
        return UIEdgeInsetsMake(0, 13, 0, 13);
    }
    else if ([self.type isEqualToString:@"classify"])
    {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else if ([self.type isEqualToString:@"banner"])
    {
        return UIEdgeInsetsMake(10, 0, 10, 0);
    }
    else{
        return UIEdgeInsetsMake(12.5, 0, 15, 0);
    }
}

/**  分区内cell之间的最小行间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if ([self.type isEqualToString:@"project"])
    {
        return 10;
    }else if ([self.type isEqualToString:@"classify"]){
        return 10;
    }
    return 10;
}

/**  分区内cell之间的最小列间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if ([self.type isEqualToString:@"project"])
    {
        return 0;
    }
    else if ([self.type isEqualToString:@"classify"])
    {
        return 10;
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
        
        NSDictionary * dic = self.dataArray[indexPath.item];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"selectGameType" object:dic[@"game_classify_id"]];
        });
        
        //点击分类跳转到游戏大厅，若游戏大厅没有初始化存储
        if (![DeviceInfo shareInstance].isClickGameHall)
        {
            [YYToolModel saveUserdefultValue:dic[@"game_classify_id"] forKey:@"HomeGameTypeClick"];
        }
        //专题游戏的点击统计
        [MyAOPManager relateStatistic:@"ClickThePopularCategories" Info:@{@"title":dic[@"game_classify_name"]}];
        //专题统计
        [MyAOPManager relateStatistic:@"ClickTheGameInTheTopic" Info:@{@"title":self.showTitle.text}];
    }
    else if ([self.type isEqualToString:@"project"] || [self.type isEqualToString:@"banner"])
    {
        if ([self.type isEqualToString:@"project"])
        {//专题游戏的点击统计
            [MyAOPManager gameRelateStatistic:@"ClickTheGameInTheTopic" GameInfo:self.dataArray[indexPath.row] Add:@{@"title":self.showTitle.text, @"clickIndex":@"home"}];
        }
        else
        {//游戏大厅游戏的点击统计
            [MyAOPManager gameRelateStatistic:@"ClickSelectedFeature" GameInfo:self.dataArray[indexPath.row] Add:@{@"title":self.showTitle.text}];
        }
        
        GameDetailInfoController * info = [GameDetailInfoController new];
        info.hidesBottomBarWhenPushed = YES;
        info.gameID = self.dataArray[indexPath.row][@"game_id"];
        [self.currentVC.navigationController pushViewController:info animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
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
}

- (void)controlLayerNeedAppear:(__kindof SJBaseVideoPlayer *)videoPlayer
{
    
}

- (void)controlLayerNeedDisappear:(__kindof SJBaseVideoPlayer *)videoPlayer
{
    
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
}

@end
