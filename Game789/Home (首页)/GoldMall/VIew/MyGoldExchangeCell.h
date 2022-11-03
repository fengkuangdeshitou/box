//
//  MyGoldExchangeCell.h
//  Game789
//
//  Created by maiyou on 2021/3/11.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyGoldExchangeCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * descLabel;
@property(nonatomic,weak)IBOutlet UILabel * numberLabel;
@property(nonatomic,weak)IBOutlet UIImageView * descImageView;
@property(nonatomic,weak)IBOutlet UITextField * textField;

@end

NS_ASSUME_NONNULL_END
