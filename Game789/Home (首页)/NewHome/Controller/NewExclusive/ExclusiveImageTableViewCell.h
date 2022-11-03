//
//  ExclusiveImageTableViewCell.h
//  Game789
//
//  Created by maiyou on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExclusiveImageTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIImageView * imageView;

@property(nonatomic,weak)IBOutlet UIView * receiveView;
@property(nonatomic,weak)IBOutlet UILabel * number;
@property(nonatomic,weak)IBOutlet UILabel * desc;
@property(nonatomic,weak)IBOutlet UIButton * action;

@end

NS_ASSUME_NONNULL_END
