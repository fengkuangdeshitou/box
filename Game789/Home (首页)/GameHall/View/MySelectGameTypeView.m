//
//  MySelectGameTypeView.m
//  Game789
//
//  Created by Maiyou on 2019/10/25.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MySelectGameTypeView.h"
#import "MySelectGameTypeCell.h"

@implementation MySelectGameTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MySelectGameTypeView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.backView_width.constant = kScreenW * 0.6;
        self.backView.x = -self.backView.width;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"MySelectGameTypeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MySelectGameTypeCell"];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeViewClick:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = [NSMutableArray array];
        NSDictionary * dic = [DeviceInfo shareInstance].data;
        [_titleArray addObject:@{@"title":@"BT", @"image":@"game_chan_bt", @"type":@"1"}];
        if ([dic[@"is_open_discount"] integerValue] == 1)
        {
            [_titleArray addObject:@{@"title":@"折扣".localized, @"image":@"game_chan_zk", @"type":@"2"}];
        }
        if ([dic[@"is_open_h5"] integerValue] == 1)
        {
            [_titleArray addObject:@{@"title":@"H5", @"image":@"game_chan_h5", @"type":@"3"}];
        }
        if ([dic[@"is_open_gm"] integerValue] == 1)
        {
            [_titleArray addObject:@{@"title":@"GM", @"image":@"game_chan_gm", @"type":@"4"}];
        }
    }
    return _titleArray;
}

- (void)removeViewClick:(UITapGestureRecognizer *)tap
{
    [self dismissView];
}

- (IBAction)backButtonClick:(id)sender
{
    [self dismissView];
}

- (void)showView
{
    [UIView animateWithDuration:0.26 animations:^{
        self.backView.x = 0;
    }];
}

- (void)dismissView
{
    [UIView animateWithDuration:0.26 animations:^{
        self.backView.x = -self.backView.width;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.backView])
    {
        return NO;
    }
    return YES;
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
    return self.titleArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"MySelectGameTypeCell";
    MySelectGameTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    NSDictionary * dic = self.titleArray[indexPath.row];
    cell.typeImageView.image = MYGetImage(dic[@"image"]);
    cell.typeName.text = dic[@"title"];
    if ([self.game_species_type isEqualToString:dic[@"type"]])
    {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFE69B"];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    }
    return cell;
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.width - 10) / 2, 90);
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
    NSLog(@"点击了第%ld分item",(long)indexPath.item);
    
    if (self.gameType)
    {
        self.gameType(self.titleArray[indexPath.item][@"type"]);
        [self dismissView];
    }
}

@end
