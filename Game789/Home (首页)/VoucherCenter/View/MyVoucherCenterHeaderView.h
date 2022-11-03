//
//  MyVoucherCenterHeaderView.h
//  Game789
//
//  Created by Maiyou on 2020/11/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyVoucherCenterHeaderView : BaseView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (nonatomic, strong) NSArray * dataArray;

@end

NS_ASSUME_NONNULL_END
