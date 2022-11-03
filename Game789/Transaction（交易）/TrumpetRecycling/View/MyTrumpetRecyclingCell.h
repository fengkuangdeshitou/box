//
//  MyTrumpetRecyclingCell.h
//  Game789
//
//  Created by yangyongMac on 2020/2/11.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecycleGameListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTrumpetRecyclingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *recycleNum;
@property (weak, nonatomic) IBOutlet UILabel *chargeAmount;
@property (weak, nonatomic) IBOutlet UILabel *recycleAmount;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property (nonatomic, strong) MyRecycleGameListModel *listModel;

@end

NS_ASSUME_NONNULL_END
