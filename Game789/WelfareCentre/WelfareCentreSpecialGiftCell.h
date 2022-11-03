//
//  WelfareCentreSpecialGiftCell.h
//  Game789
//
//  Created by maiyou on 2021/9/16.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWelfareCenterGameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WelfareCentreSpecialGiftCell : UICollectionViewCell

@property(nonatomic,strong)NSDictionary * data;

@property (nonatomic,strong) MyWelfareCenterGameModel *gameModel;

// 领取成功
@property (nonatomic, copy) void(^receiveSuccess)(MyWelfareCenterGameModel * model);

@end

NS_ASSUME_NONNULL_END
