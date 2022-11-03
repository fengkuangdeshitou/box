//
//  HGHomeScrollHeaderView.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/6/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHomeTopFunctionCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeScrollHeaderView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView_x;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView_top;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property (weak, nonatomic) IBOutlet UIView *bottomBackView;

@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSArray * sectionTitleArray;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isScroll;

@end

NS_ASSUME_NONNULL_END
