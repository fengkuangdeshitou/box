//
//  MyNewGamesHeaderView.h
//  Game789
//
//  Created by Maiyou on 2019/10/31.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyNewGamesHeaderView : BaseView

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageView1;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageView2;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageView3;
@property (weak, nonatomic) IBOutlet UILabel *gameName1;
@property (weak, nonatomic) IBOutlet UILabel *gameName2;
@property (weak, nonatomic) IBOutlet UILabel *gameName3;
@property (weak, nonatomic) IBOutlet UILabel *gameType1;
@property (weak, nonatomic) IBOutlet UILabel *gameType2;
@property (weak, nonatomic) IBOutlet UILabel *gameType3;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) UIViewController * currentVC;

@end

NS_ASSUME_NONNULL_END
