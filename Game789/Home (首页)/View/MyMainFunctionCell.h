//
//  MyMainFunctionCell.h
//  Game789
//
//  Created by Maiyou on 2019/10/29.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyMainFunctionCell : BaseTableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray * dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *indexImageView;
/**  是否有collectionview背景图片  */
@property (nonatomic, assign) BOOL isBgImage;

@end

NS_ASSUME_NONNULL_END
