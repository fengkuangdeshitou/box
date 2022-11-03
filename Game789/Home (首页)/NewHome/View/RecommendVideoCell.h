//
//  RecommendVideoCell.h
//  Game789
//
//  Created by maiyou on 2021/11/24.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendVideoImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendVideoCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIButton * play;
@property(nonatomic,weak)IBOutlet RecommendVideoImageView * pic;
@property(nonatomic,weak)IBOutlet UIView * cover;

@end

NS_ASSUME_NONNULL_END
