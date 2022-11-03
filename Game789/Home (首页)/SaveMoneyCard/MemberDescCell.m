//
//  MemberDescCell.m
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MemberDescCell.h"
#import "MemberDescTableViewCell.h"
#import "MemberDescItemCollectionViewCell.h"

@interface MemberDescCell ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,weak)IBOutlet UICollectionView * collectionView;
 
@end

@implementation MemberDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MemberDescItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MemberDescItemCollectionViewCell"];
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MemberDescItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberDescItemCollectionViewCell" forIndexPath:indexPath];
    NSDictionary * item = self.dataArray[indexPath.row];
    cell.title.text = item[@"title"];
    BOOL active = [item[@"active"] boolValue];
    if (active) {
        cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_active_%ld",indexPath.row]];
        cell.title.textColor = [UIColor colorWithHexString:@"#282828"];
    }else{
        cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_normal_%ld",indexPath.row]];
        cell.title.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDidselectedIndex:)]) {
        [self.delegate onDidselectedIndex:indexPath.row];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth-30)/4, 66.5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 0, 20, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
