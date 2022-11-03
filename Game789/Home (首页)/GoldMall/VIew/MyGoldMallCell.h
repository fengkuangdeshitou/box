//
//  MyGoldMallCell.h
//  Game789
//
//  Created by maiyou on 2021/3/11.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoldMallModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MyGoldMallCellDelegate <NSObject>

- (void)onExchangeSuccess;

@end

@interface MyGoldMallCell : UITableViewCell

@property(nonatomic,strong)GoldMallModel * model;
@property(nonatomic,weak)id<MyGoldMallCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
