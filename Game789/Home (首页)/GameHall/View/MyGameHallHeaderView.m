//
//  MyGameHallHeaderView.m
//  Game789
//
//  Created by Maiyou on 2020/9/28.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameHallHeaderView.h"
#import "MyGameHallBannerCell.h"

@implementation MyGameHallHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithHexString:@"F5F6F8"];
//        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;

    self.pageControl.numberOfPages = dataArray.count;
    [self addSubview:self.cycleScrollView];
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:@""];
    }];
    self.cycleScrollView.imageURLStringsGroup = arr;

    if (dataArray.count > 0)
    {
        [MyAOPManager gameRelateStatistic:@"ShowFeaturedBannerOfGameHall" GameInfo:dataArray[0] Add:@{}];
    }
}

- (XHPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[XHPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, self.cycleScrollView.bottom, self.width, 20);
        _pageControl.delegate = self;
        _pageControl.otherColor = FontColorDE;
        _pageControl.currentColor = MAIN_COLOR;
//        _pageControl.backgroundColor = UIColor.redColor;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(15, 15, kScreenW - 72 - 30, self.height - 40) delegate:self placeholderImage:nil];
        _cycleScrollView.layer.cornerRadius = 8;
        _cycleScrollView.clipsToBounds = true;
        _cycleScrollView.backgroundColor = UIColor.whiteColor;
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.showPageControl = false;
    }
    return _cycleScrollView;
}

- (UINib *)customCollectionViewCellNibForCycleScrollView:(SDCycleScrollView *)view{
    return [UINib nibWithNibName:@"MyGameHallBannerCell" bundle:nil];
}

- (void)setupCustomCell:(MyGameHallBannerCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view{
    cell.dataDic = self.dataArray[index];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [MyAOPManager gameRelateStatistic:@"ClickFeaturedBannerOfGameHall" GameInfo:self.dataArray[index] Add:@{}];
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.hidesBottomBarWhenPushed = YES;
    info.gameID = self.dataArray[index][@"game_id"];
    [[YYToolModel getCurrentVC].navigationController pushViewController:info animated:YES];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.pageControl.currentPage = index;
}

//- (UICollectionView *)collectionView
//{
//    if (!_collectionView)
//    {
//        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 15, kScreenW - 72 - 30, self.height - 40) collectionViewLayout:flowLayout];
//        self.collectionView.delegate = self;
//        self.collectionView.dataSource = self;
//        self.collectionView.pagingEnabled = YES;
//        self.collectionView.backgroundColor = [UIColor whiteColor];
//        self.collectionView.showsHorizontalScrollIndicator = NO;
//
//        [self.collectionView registerNib:[UINib nibWithNibName:@"MyNewGameReserveListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyNewGameReserveListCell"];
//    }
//    return _collectionView;
//}
//
//#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
///**  分区个数  */
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//
///** 每个分区item的个数  */
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return self.dataArray.count;
//}
//
///**  创建cell  */
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellID = @"MyNewGameReserveListCell";
//    MyNewGameReserveListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    cell.type = @"banner";
//    cell.dataDic = self.dataArray[indexPath.item];
//    return cell;
//}
//
///**  cell的大小  */
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(collectionView.width, collectionView.height);
//}
//
///**  每个分区的内边距（上左下右） */
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
///**  分区内cell之间的最小行间距  */
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
//
///**  分区内cell之间的最小列间距  */
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}
//
///**
// 点击某个cell
// */
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"点击了第%ld分item", (long)indexPath.item);
//
//    [MyAOPManager gameRelateStatistic:@"ClickFeaturedBannerOfGameHall" GameInfo:self.dataArray[indexPath.item] Add:@{}];
////
//    GameDetailInfoController * info = [GameDetailInfoController new];
//    info.hidesBottomBarWhenPushed = YES;
//    info.gameID = self.dataArray[indexPath.row][@"game_id"];
//    [[YYToolModel getCurrentVC].navigationController pushViewController:info animated:YES];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSInteger index = scrollView.contentOffset.x / scrollView.width;
//    self.pageControl.currentPage = index;
//
//    [MyAOPManager gameRelateStatistic:@"ShowFeaturedBannerOfGameHall" GameInfo:self.dataArray[index] Add:@{}];
//}
//
//#pragma mark ——— XHPageControlDelegate
//- (void)xh_PageControlClick:(XHPageControl*)pageControl index:(NSInteger)clickIndex
//{
//    self.collectionView.contentOffset = CGPointMake(self.collectionView.width * clickIndex, 0);
//
//    [MyAOPManager gameRelateStatistic:@"ShowFeaturedBannerOfGameHall" GameInfo:self.dataArray[clickIndex] Add:@{}];
//}

@end
