//
//  HGHomeRecommendGamesCell.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGHomeRecommendGamesCell.h"
#import "MyShowProjectGameCell.h"
#import "MyDetailRelateGamesApi.h"

@interface HGHomeRecommendGamesCell ()

@property (nonatomic, assign) BOOL isTranform;

@end

@implementation HGHomeRecommendGamesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyShowProjectGameCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyShowProjectGameCell"];
    [self.updateBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
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
    return self.dataArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"MyShowProjectGameCell";
    MyShowProjectGameCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    cell.type = @"detail";
    cell.dataDic = self.dataArray[indexPath.item];
    return cell;
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (kScreenW - 30 - 15 * 3) / 4;
    return CGSizeMake(width, 47 + width + 20);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 15, 0);
}

/**  分区内cell之间的最小行间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

/**  分区内cell之间的最小列间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld分item",(long)indexPath.item);
    
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.gameID = self.dataArray[indexPath.item][@"game_id"];
    [self.currentVC.navigationController pushViewController:info animated:YES];
}

#pragma mark — 换一批猜你喜欢的游戏
- (IBAction)updateGameClick:(id)sender
{
    [self.updateBtn feedbackGenerator];
    
    if (self.UpdateRelatedGames)
    {
        self.UpdateRelatedGames();
    }
    //旋转动画
    if (!self.isTranform)
    {
        [UIView animateWithDuration:0.8 animations:^{
            self.updateBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.8 animations:^{
            self.updateBtn.imageView.transform = CGAffineTransformIdentity;
        }];
    }
    self.isTranform = !self.isTranform;
    
    [self getRelateGames];
}

- (void)getRelateGames
{
    MyDetailRelateGamesApi * api = [[MyDetailRelateGamesApi alloc] init];
    api.game_id = self.game_id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.dataArray = request.data[@"list"];
            [self.collectionView reloadData];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
    }];
}

@end
