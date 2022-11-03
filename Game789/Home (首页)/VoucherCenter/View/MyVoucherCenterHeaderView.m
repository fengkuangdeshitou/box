//
//  MyVoucherCenterHeaderView.m
//  Game789
//
//  Created by Maiyou on 2020/11/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyVoucherCenterHeaderView.h"
#import "MyTradeOfficialSelectionCell.h"
#import "MyRecentPlayGamesController.h"

@implementation MyVoucherCenterHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyVoucherCenterHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"MyTradeOfficialSelectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyTradeOfficialSelectionCell"];
        
        [self.moreBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
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
    return self.dataArray.count > 5 ? 5 : self.dataArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"MyTradeOfficialSelectionCell";
    MyTradeOfficialSelectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    cell.dataDic = self.dataArray[indexPath.item];
    return cell;
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(228, collectionView.height);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**  分区内cell之间的最小行间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

/**  分区内cell之间的最小列间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * gameInfo = self.dataArray[indexPath.row][@"game_info"];
    [MyAOPManager gameRelateStatistic:@"ClickTheRecommendationOfCouponCenter" GameInfo:gameInfo Add:@{@"title":self.showTitle.text}];
    
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.gameID = gameInfo[@"game_id"];
    info.hidesBottomBarWhenPushed = YES;
    info.isVoucherCenter = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:info animated:YES];
}

- (IBAction)moreBtnClick:(id)sender
{
    MyRecentPlayGamesController * play = [MyRecentPlayGamesController new];
    play.showTitle = self.showTitle.text;
    [[YYToolModel getCurrentVC].navigationController pushViewController:play animated:YES];
}


@end
