//
//  TradingHeaderView.h
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradingHeaderView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *top_button;
@property (weak, nonatomic) IBOutlet UIButton *top_button1;
@property (weak, nonatomic) IBOutlet UIButton *top_button2;
@property (weak, nonatomic) IBOutlet UIButton *top_button3;
@property (weak, nonatomic) IBOutlet UIButton *top_button4;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_height;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) UIViewController * currentVC;

- (void)setButtonImage;

@end
