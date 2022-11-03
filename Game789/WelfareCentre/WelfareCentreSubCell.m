//
//  WelfareCentreSubCell.m
//  Game789
//
//  Created by maiyou on 2021/9/16.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WelfareCentreSubCell.h"
#import "WelfareCentreSpecialGiftCell.h"

@interface WelfareCentreSubCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak)IBOutlet UICollectionView * collectionView;
@property (nonatomic,strong) NSArray *tplArray;

@end

@implementation WelfareCentreSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"WelfareCentreSpecialGiftCell" bundle:nil] forCellWithReuseIdentifier:@"WelfareCentreSpecialGiftCell"];
    
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    self.tplArray = [MyWelfareCenterGameModel mj_objectArrayWithKeyValuesArray:dataArray];
    [self.collectionView reloadData];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WelfareCentreSpecialGiftCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WelfareCentreSpecialGiftCell" forIndexPath:indexPath];
    cell.gameModel = self.tplArray[indexPath.row];
//    cell.receiveSuccess = ^(MyWelfareCenterGameModel * _Nonnull model) {
//        self.dataArray
//    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tplArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(188, 120);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 11;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyWelfareCenterGameModel * model = self.tplArray[indexPath.item];
    [MyAOPManager relateStatistic:@"ClickSentFirsTrechargeOfWelfareCentrePage" Info:@{@"gameName":model.gameName}];
    GameDetailInfoController * detail = [GameDetailInfoController new];
    detail.gameID = model.gameId;
    [[YYToolModel getCurrentVC].navigationController pushViewController:detail animated:YES];
}

@end
