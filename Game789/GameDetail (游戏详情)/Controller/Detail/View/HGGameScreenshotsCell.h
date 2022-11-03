//
//  HGGameScreenshotsCell.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/24.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGGameScreenshotsCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) NSMutableArray * imageArray;
@property (nonatomic,strong) CAShapeLayer *maskLayer;

@end

NS_ASSUME_NONNULL_END
