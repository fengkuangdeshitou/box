//
//  ExclusiveTableViewCell.h
//  Game789
//
//  Created by maiyou on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExclusiveTableViewCell : UITableViewCell

@property(nonatomic,strong) NSDictionary * model;
@property(nonatomic,weak)IBOutlet UIButton * actionButton;

@end

NS_ASSUME_NONNULL_END
