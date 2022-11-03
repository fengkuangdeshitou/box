//
//  HomeRecentlyPlayCell.m
//  Game789
//
//  Created by maiyou on 2021/6/22.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "HomeRecentlyPlayCell.h"
#import "RecentlyPlayCollectionViewCell.h"

@interface HomeRecentlyPlayCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak)IBOutlet UICollectionView * collectionView;

@end

@implementation HomeRecentlyPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecentlyPlayCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"RecentlyPlayCollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RecentlyPlayHeader"];
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecentlyPlayCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecentlyPlayCollectionViewCell" forIndexPath:indexPath];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-30-40-26)/5, self.collectionView.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, section == 0 ? 0 : 10, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(15, self.collectionView.height);
//}
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    if (kind == UICollectionElementKindSectionHeader) {
//        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RecentlyPlayHeader" forIndexPath:indexPath];
//        for (UIView * view in header.subviews) {
//            [view removeFromSuperview];
//        }
//        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, self.collectionView.height)];
//        title.numberOfLines = 0;
//        title.text = @"最\n近\n在\n玩";
//        title.textColor = [UIColor colorWithHexString:@"#282828"];
//        title.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
//        [header addSubview:title];
//        return header;
//    }else{
//        return nil;
//    }
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * data = self.dataArray[indexPath.row];
    [MyAOPManager gameRelateStatistic:@"ClickPlayingRecently" GameInfo:data Add:@{}];
    GameDetailInfoController * detail = [[GameDetailInfoController alloc] init];
    detail.gameID = data[@"game_id"];
    [self.currentVC.navigationController pushViewController:detail animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
