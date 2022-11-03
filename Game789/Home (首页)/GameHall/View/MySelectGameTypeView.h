//
//  MySelectGameTypeView.h
//  Game789
//
//  Created by Maiyou on 2019/10/25.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

typedef void(^SeletGameTypeAction)(NSString * _Nonnull type);

NS_ASSUME_NONNULL_BEGIN

@interface MySelectGameTypeView : BaseView <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_width;

@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, copy) SeletGameTypeAction gameType;
/**  游戏类型 BT 1 折扣 2 H5 3 GM 4  */
@property (nonatomic, copy) NSString * game_species_type;

- (void)showView;

- (void)dismissView;

@end

NS_ASSUME_NONNULL_END
