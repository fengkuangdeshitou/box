//
//  tradingViewCell.h
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradingListModel.h"

@interface tradingViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UIImageView *game_icon;
@property (weak, nonatomic) IBOutlet UILabel *game_name;
@property (weak, nonatomic) IBOutlet UILabel *trading_des;
@property (weak, nonatomic) IBOutlet UILabel *trading_price;
@property (weak, nonatomic) IBOutlet UILabel *game_type;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *deviceIosIcon;
@property (weak, nonatomic) IBOutlet UIImageView *deviceAndroidIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceIosIcon_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceAndroidIcon_width;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (strong, nonatomic) UILabel *trading_status;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameName_y;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameType_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *price_width;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property (nonatomic, strong) TradingListModel * listModel;
/**  是否将游戏名字显示为区服  */
@property (nonatomic, assign) BOOL isShowServerName;
/**  是否显示游戏类型标签  */
@property (nonatomic, assign) BOOL  isHiddenTag;
/**  是否显示标记  */
@property (nonatomic, assign) BOOL  isShow;
@property (nonatomic,strong) UILabel *typeNameLabel;
@property (nonatomic,strong) UIImageView *typeNameLabelImageView;

@end
