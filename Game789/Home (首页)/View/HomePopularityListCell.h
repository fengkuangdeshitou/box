//
//  HomePopularityListCell.h
//  Game789
//
//  Created by Maiyou on 2018/12/4.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomePopularityListCell : BaseTableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

NS_ASSUME_NONNULL_END
