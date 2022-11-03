//
//  HGHomeRecommendGamesCell.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeRecommendGamesCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MyLikeButton *updateBtn;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;

@property (nonatomic, copy) NSString *game_id;
@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, copy) void(^UpdateRelatedGames)(void);

@end

NS_ASSUME_NONNULL_END
