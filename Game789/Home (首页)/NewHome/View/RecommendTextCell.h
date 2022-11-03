//
//  RecommendTextCell.h
//  Game789
//
//  Created by maiyou on 2021/11/23.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecommendTextCell : UITableViewCell

@property(nonatomic,weak)IBOutlet NSLayoutConstraint * imageTopConstraint;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * imageHeightConstraint;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * contentLabel;
@property(nonatomic,weak)IBOutlet UIImageView * banner;

@end

NS_ASSUME_NONNULL_END
