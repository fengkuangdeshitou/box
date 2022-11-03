//
//  MyMainFunctionCell.m
//  Game789
//
//  Created by Maiyou on 2019/10/29.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyMainFunctionCell.h"

#import "YYPersonalCollectionViewCell.h"

#import "UserGoldCoinsViewController.h"
#import "UserPayGoldViewController.h"

@implementation MyMainFunctionCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"YYPersonalCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"YYPersonalCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    self.indexImageView.hidden = self.dataArray.count > 4 ? NO : YES;
    
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
    return self.dataArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"YYPersonalCollectionViewCell";
    YYPersonalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YYPersonalCollectionViewCell" owner:self options:nil].firstObject;
    }
    NSDictionary * dic = self.dataArray[indexPath.item];
    if (indexPath.item < 4)
    {
        BOOL is_new_ui = [MyNewMaterialInfo shareInstance].isShowMaterial;
        MyNewMaterialInfo * materialInfo = [MyNewMaterialInfo shareInstance];
        NSString * name = [materialInfo sourceFilePath:[NSString stringWithFormat:@"home_func_icon%ld", (long)indexPath.item + 1]];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL bRet = [fileMgr fileExistsAtPath:name];
        if (is_new_ui && bRet)
        {
            cell.showImage.image = [UIImage imageWithContentsOfFile:name];
        }
        else
        {
            cell.showImage.image = MYGetImage(dic[@"image"]);
        }
    }
    else
    {
        cell.showImage.image = MYGetImage(dic[@"image"]);
    }
    cell.showTitle.text  = [dic[@"title"] localized];
    cell.badgeCount.hidden = YES;
    cell.imageView_width.constant = 50;
    cell.imageView_height.constant = 50;
    cell.imageView_top.constant = 5;
    cell.showTitle.textColor = [UIColor colorWithHexString:@"#282828"];
    cell.showTitle.font = [UIFont systemFontOfSize:12];
    return cell;
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width / 4, 90);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**  分区内cell之间的最小行间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
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
    
    NSDictionary * dic = self.dataArray[indexPath.item];
    NSString *className = dic[@"vc"]; //classNames 字符串数组集
    if ([className isEqualToString:@"UserGoldCoinsViewController"] || [className isEqualToString:@"ReturnMoneyViewController"] || [className isEqualToString:@"UserPayGoldViewController"])
    {
        if (![YYToolModel islogin])
        {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.currentVC.navigationController pushViewController:loginVC animated:YES];
            return;
        }
    }
    if ([className isEqualToString:@"UserGoldCoinsViewController"])
    {
        UserGoldCoinsViewController *coinsVC = [[UserGoldCoinsViewController alloc]init];
        coinsVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:coinsVC animated:YES];
    }
    else if ([className isEqualToString:@"UserPayGoldViewController"])
    {
        UserPayGoldViewController * payVC = [[UserPayGoldViewController alloc]init];
        payVC.hidesBottomBarWhenPushed = YES;
        payVC.isMember = YES;
        [self.currentVC.navigationController pushViewController:payVC animated:YES];
    }
    else
    {
        Class class = NSClassFromString(className);
        if (class && className) {
            BaseViewController *ctrl = class.new;
            ctrl.hidesBottomBarWhenPushed = YES;
            [self.currentVC.navigationController pushViewController:ctrl animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat index = scrollView.contentOffset.x / scrollView.width;
    
    NSLog(@"滑动%f -- %f", scrollView.contentOffset.x, index);
    
    if (index > 0)
    {
        self.indexImageView.image = MYGetImage(@"main_func_right");
    }
    else
    {
        self.indexImageView.image = MYGetImage(@"main_func_left");
    }
}

@end
