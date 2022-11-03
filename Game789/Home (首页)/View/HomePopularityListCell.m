//
//  HomePopularityListCell.m
//  Game789
//
//  Created by Maiyou on 2018/12/4.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "HomePopularityListCell.h"
#import "MyProjectGameController.h"
#import "MyPopularityListCollectionCell.h"
#import "GameDetailInfoController.h"
#import "SegmentTypeApi.h"

@implementation HomePopularityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"MyPopularityListCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyPopularityListCollectionCell"];
}

- (void)setModelDic:(NSDictionary *)dic
{
    self.dataDic = dic;
    
    self.showTitle.text = [dic[@"project_title"] localized];
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:dic[@"game_list"]];
    self.dataArray = [NSMutableArray arrayWithArray:dic[@"game_list"]];
    NSDictionary * data = [SegmentTypeApi sharedInstance].data;
    NSInteger is_open_discount = [[data valueForKey:@"is_open_discount"] integerValue];
    NSInteger is_open_h5       = [[data valueForKey:@"is_open_h5"] integerValue];
    for (NSDictionary * dic in array)
    {
        NSInteger game_species_type = [dic[@"game_species_type"] integerValue];
        if (game_species_type == 2 && is_open_discount == 0)
        {
            [self.dataArray removeObject:dic];
        }
        else if (game_species_type == 3 && is_open_h5 == 0)
        {
            [self.dataArray removeObject:dic];
        }
    }
    [self.collectionView reloadData];
}

- (IBAction)moreButtonAction:(id)sender
{
    [self pushProjectGames];
}

- (void)pushProjectGames
{
    MyProjectGameController * project = [MyProjectGameController new];
    project.dataDic = self.dataDic;
    project.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:project animated:YES];
}

- (void)viewClick:(UITapGestureRecognizer *)tap
{
    UIView * view = tap.view;
    
    NSArray * game_list = self.dataDic[@"game_list"];
    NSDictionary * dic = game_list[view.tag - 10];
    [self gameContentTableCellBtn:dic];
}

- (void)gameContentTableCellBtn:(NSDictionary *)dic
{
    GameDetailInfoController * detailVC = [[GameDetailInfoController alloc] init];
    detailVC.gameID = dic[@"game_id"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:detailVC animated:YES];
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
    return self.dataArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"MyPopularityListCollectionCell";
    MyPopularityListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    cell.dataDic = self.dataArray[indexPath.row];
    return cell;
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(128, collectionView.height);
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
    return 0;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld分item",(long)indexPath.item);
    
    NSDictionary * dic = self.dataArray[indexPath.row];
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.hidesBottomBarWhenPushed = YES;
    info.gameID = dic[@"game_id"];
    [self.currentVC.navigationController pushViewController:info animated:YES];
}

@end
