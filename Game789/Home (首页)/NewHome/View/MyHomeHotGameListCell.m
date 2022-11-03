//
//  MyHomeHotGameListCell.m
//  Game789
//
//  Created by Maiyou on 2020/7/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyHomeHotGameListCell.h"
#import "HGHotGamesListCell.h"

@implementation MyHomeHotGameListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    NSInteger count = self.dataArray.count / 3;
    NSInteger index = self.dataArray.count % 3;
    NSInteger row = index > 0 ? count + 1 : count;
    self.indexArray = [NSMutableArray array];
    for (int i = 0; i < row; i ++)
    {
        NSMutableArray * array = [NSMutableArray array];
        if (i < count)
        {
            [array addObject:self.dataArray[i * 3]];
            [array addObject:self.dataArray[i * 3 + 1]];
            [array addObject:self.dataArray[i * 3 + 2]];
        }
        else
        {
            if (index == 1)
            {
                [array addObject:self.dataArray[i * 3]];
            }
            else if (index == 2)
            {
                [array addObject:self.dataArray[i * 3]];
                [array addObject:self.dataArray[i * 3 + 1]];
            }
        }
        [self.indexArray addObject:array];
    }
    
    if (self.param)
    {
        self.param.wDataSet(self.indexArray);
    }
    [self.bannerView updateUI];
}

- (WMZBannerView *)bannerView
{
    if (!_bannerView)
    {
        WMZBannerParam *param =
        BannerParam()
        .wEventClickSet(^(id anyID, NSInteger index) {
            NSLog(@"点击 %ld", (long)index);
        })
        .wEventScrollEndSet(^(id anyID, NSInteger index, BOOL isCenter,UICollectionViewCell *cell){
            [UIView animateWithDuration:0.1 animations:^{
                
            }];
        })
        //自定义视图必传
        .wMyCellClassNameSet(@"HGHotGamesListCell")
        .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
            //自定义视图
            HGHotGamesListCell *cell = (HGHotGamesListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HGHotGamesListCell class]) forIndexPath:indexPath];
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
            cell.dataArray = array;
            return cell;
        })
        .wFrameSet(CGRectMake(0, 0, kScreenW, self.height))
        .wDataSet(self.indexArray)
        //间距
        .wLineSpacingSet(10)
        //循环滚动
        .wRepeatSet(NO)
        //自动滚动时间
        .wAutoScrollSecondSet(3)
        //自动滚动
        .wAutoScrollSet(NO)
        .wHideBannerControlSet(YES)
        .wItemSizeSet(CGSizeMake(kScreenW, self.height));
        self.param = param;
        _bannerView = [[WMZBannerView alloc] initConfigureWithModel:param];
        [self.contentView addSubview:_bannerView];
    }
    return _bannerView;
}

@end
