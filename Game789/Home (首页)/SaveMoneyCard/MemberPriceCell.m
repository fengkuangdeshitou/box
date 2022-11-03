//
//  MemberPriceCell.m
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MemberPriceCell.h"
#import "MemberPriceCollectionView.h"

@interface MemberPriceCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,weak)IBOutlet UICollectionView * collectionView;
@property(nonatomic,assign)NSInteger currentFlag;

@end

@implementation MemberPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MemberPriceCollectionView" bundle:nil] forCellWithReuseIdentifier:@"MemberPriceCollectionView"];
    
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    for (int i=0; i<dataArray.count; i++) {
        NSDictionary * item = dataArray[i];
        if ([item[@"active"] boolValue]) {
            self.currentFlag = i;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectedGradeId:)]) {
                    NSDictionary * item = self.dataArray[i];
                    [self.delegate onSelectedGradeId:item[@"grade_id"]];
                }
            });
            break;
        }
    }
    [self.collectionView reloadData];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MemberPriceCollectionView * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberPriceCollectionView" forIndexPath:indexPath];
    cell.selectedImageView.hidden = indexPath.row != self.currentFlag;
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 13;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(115, 140);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
