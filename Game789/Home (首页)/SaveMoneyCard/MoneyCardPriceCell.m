//
//  MoneyCardPriceCell.m
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MoneyCardPriceCell.h"
#import "MoneyCardCollectionViewCell.h"

@interface MoneyCardPriceCell ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,weak)IBOutlet UICollectionView * collectionView;
@property(nonatomic,assign)NSInteger currentFlag;

@end

@implementation MoneyCardPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.currentFlag = 0;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MoneyCardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MoneyCardCollectionViewCell"];
    
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    for (int i=0; i<dataArray.count; i++) {
        NSDictionary * item = dataArray[i];
        if ([item[@"active"] boolValue]) {
            self.currentFlag = i;
            continue;
        }
    }
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectedGradeId:)]) {
            NSDictionary * item = self.dataArray[self.currentFlag];
            [self.delegate onSelectedGradeId:item[@"grade_id"]];
        }
    });
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MoneyCardCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoneyCardCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == self.currentFlag) {
        cell.container.layer.borderColor = [UIColor colorWithHexString:@"#654809"].CGColor;
        cell.container.layer.borderWidth = 1;
    }else{
        cell.container.layer.borderColor = [UIColor colorWithHexString:@"#654809"].CGColor;
        cell.container.layer.borderWidth = 0;
    }
    cell.container.layer.cornerRadius = 10;
    cell.selectImageView.hidden = true;
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.currentFlag = indexPath.row;
    [self.collectionView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectedGradeId:)]) {
        NSDictionary * item = self.dataArray[indexPath.row];
        [self.delegate onSelectedGradeId:item[@"grade_id"]];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth, 85);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
