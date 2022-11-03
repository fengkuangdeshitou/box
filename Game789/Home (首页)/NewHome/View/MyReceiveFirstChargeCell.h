//
//  MyReceiveFirstChargeCell.h
//  Game789
//
//  Created by Maiyou001 on 2021/11/17.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWelfareCenterGameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyReceiveFirstChargeCell : UITableViewCell

@property(nonatomic,strong) GameTableViewCell * gameCell;
@property(nonatomic,weak)IBOutlet UIView * radiusView;
@property (weak, nonatomic) IBOutlet UILabel *showMoney;
@property (weak, nonatomic) IBOutlet UILabel *showDesc;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property(nonatomic,strong) MyWelfareCenterGameModel * gameModel;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * radiusTop;

@end

NS_ASSUME_NONNULL_END
