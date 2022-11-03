//
//  MyOpenServiceHeaderView.m
//  Game789
//
//  Created by Maiyou on 2020/8/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyOpenServiceHeaderView.h"

@implementation MyOpenServiceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyOpenServiceHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MyHotGameClassifyCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyHotGameClassifyCell"];
         _collectionView.backgroundColor = BackColor;
        self.selectedTimeIndex = 0;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}

- (void)setDateArray:(NSArray *)dateArray
{
    _dateArray = dateArray;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
/**
 分区个数
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

/** 每个分区item的个数  */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.type.intValue == 10 ? self.dataArray.count : self.dateArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"MyHotGameClassifyCell";
    MyHotGameClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    cell.showName.layer.cornerRadius = 15;
    if (indexPath.item == self.selectedTimeIndex)
    {
        cell.showName.backgroundColor = MAIN_COLOR;
        cell.showName.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.showName.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        cell.showName.textColor = FontColor66;
    }
    if (self.type.intValue == 10)
    {
        NSString * time = [NSDate dateWithFormat:@"HH:mm" WithTS:[self.dataArray[indexPath.item][0][@"kaifu_start_date"] doubleValue]];
        cell.showName.text = time;
    }
    else
    {
        NSString * time = [self.dateArray[indexPath.item] substringFromIndex:5];
        cell.showName.text = time;
    }
    return cell;
}

/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 30);
}

/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

/**
 分区内cell之间的最小列间距
 */
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
    
    if (self.collectionSelectedIndex && indexPath.item != self.selectedTimeIndex)
    {
        self.selectedTimeIndex = indexPath.item;
        [self.collectionView reloadData];
        MyHotGameClassifyCell *cell = (MyHotGameClassifyCell *)[collectionView cellForItemAtIndexPath:indexPath];
        self.collectionSelectedIndex(indexPath.item, self.type.intValue == 10 ? cell.showName.text : self.dateArray[indexPath.item]);
    }
}

@end
