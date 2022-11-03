//
//  HGFindRecommendGamesCell.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/19.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGFindRecommendGamesCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UIView *more;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showImageViewWidthConstraint;

@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) NSArray * dataArray;

@end

NS_ASSUME_NONNULL_END
