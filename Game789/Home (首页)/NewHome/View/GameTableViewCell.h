//
//  GameTableViewCell.h
//  Game789
//
//  Created by maiyou on 2021/9/17.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeListTableViewCell.h"
#import "GameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameTableViewCell : HomeListTableViewCell

@property(nonatomic,strong) GameModel * gameModel;
@property (assign, nonatomic,readonly)  CGFloat cellHeight;
@property (assign, nonatomic)  CGFloat logoImageViewRadius;
@property(nonatomic,weak)IBOutlet UILabel * gamaname;
@property(nonatomic,weak)IBOutlet UIView * radiusView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *radiusView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *radiusView_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameName_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLabel_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discount_width;

@property (copy, nonatomic) void(^updateFrameBlock)(CGFloat cellHeight);
@property (nonatomic, assign) CGFloat viewTop;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, assign) CGFloat containViewHeight;

@end

NS_ASSUME_NONNULL_END
