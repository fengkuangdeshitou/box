//
//  MyNewHomePopularRecommendCell.h
//  Game789
//
//  Created by Maiyou on 2019/10/15.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyNewHomePopularRecommendCell : BaseTableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray * dataArray;

@end

NS_ASSUME_NONNULL_END
