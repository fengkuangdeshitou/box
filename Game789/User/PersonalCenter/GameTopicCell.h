//
//  GameTopicCell.h
//  Game789
//
//  Created by maiyou on 2021/4/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameTopicCell : UITableViewCell

@property(nonatomic,strong)Comment * model;

@property(nonatomic,copy)void(^cellHeightChangeBlock)(void);

@end

NS_ASSUME_NONNULL_END
