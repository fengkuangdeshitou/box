//
//  InternalTestingTableViewCell.h
//  Game789
//
//  Created by maiyou on 2022/3/3.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InternalTestingTableViewCell : UITableViewCell

@property(nonatomic,strong) GameModel * model;

@end

NS_ASSUME_NONNULL_END
