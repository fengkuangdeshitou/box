//
//  MessageCell.h
//  Game789
//
//  Created by maiyou on 2021/4/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetSettingNewsMgsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageCell : UITableViewCell

@property(nonatomic,strong)GetSettingNewsMgsModel * model;

@end

NS_ASSUME_NONNULL_END
