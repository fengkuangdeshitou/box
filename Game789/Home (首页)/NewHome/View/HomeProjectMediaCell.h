//
//  HomeProjectMediaCell.h
//  Game789
//
//  Created by maiyou on 2021/7/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeProjectMediaCell : UITableViewCell

@property(nonatomic,strong) GameTableViewCell * gameCell;
@property(nonatomic,weak)IBOutlet UIImageView * gameIcon;
@property(nonatomic,weak)IBOutlet UIButton * playButton;
@property(nonatomic,weak)IBOutlet UILabel * descLabel;
@property(nonatomic,weak)IBOutlet UIView * radiusView;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * radiusTop;

@end

NS_ASSUME_NONNULL_END
