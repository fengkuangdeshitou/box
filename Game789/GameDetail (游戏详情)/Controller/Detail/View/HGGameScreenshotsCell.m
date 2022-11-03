//
//  HGGameScreenshotsCell.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/24.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGGameScreenshotsCell.h"
#import "HGShowGameScreenshotsCell.h"

@implementation HGGameScreenshotsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HGShowGameScreenshotsCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HGShowGameScreenshotsCell"];
}

- (void)layoutSubviews
{
    self.backView.layer.mask = self.maskLayer;
}

- (CAShapeLayer *)maskLayer
{
    if (!_maskLayer)
    {
        _maskLayer = [[CAShapeLayer alloc] init];
    }
    
    CGRect oldRect = self.backView.bounds;
    oldRect.size.width = [UIScreen mainScreen].bounds.size.width - 30;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:oldRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(13, 13)];
    _maskLayer.path = maskPath.CGPath;
    _maskLayer.frame = oldRect;
    
    return _maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    return [self.dataArray count];
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"HGShowGameScreenshotsCell";
    HGShowGameScreenshotsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    [cell.showScreenshots yy_setImageWithURL:[NSURL URLWithString:[self dataArray][indexPath.item]] placeholder:MYGetImage(@"game_shotscreen_bg")];
    return cell;
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 200);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 0, 0, 0);
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
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = self.imageArray;
    browser.currentPage = indexPath.item;
    [browser show];
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
        [self.dataArray enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 网络图片
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:obj];
            data.projectiveView = [self viewAtIndex:idx];
            data.allowSaveToPhotoAlbum = NO;
            [_imageArray addObject:data];
        }];
    }
    return _imageArray;
}

- (id)viewAtIndex:(NSInteger)index
{
    HGShowGameScreenshotsCell *cell = (HGShowGameScreenshotsCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cell ? cell.showScreenshots : nil;
}

@end
