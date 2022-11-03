//
//  MyVoucherListCell.h
//  Game789
//
//  Created by Maiyou on 2019/10/22.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyVoucherListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyVoucherListCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *voucherMoney;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *usedGameName;
@property (weak, nonatomic) IBOutlet UILabel *exceedLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIImageView *cellBgimageView;
@property (weak, nonatomic) IBOutlet UIView *circleView1;
@property (weak, nonatomic) IBOutlet UIView *circleView2;
@property (weak, nonatomic) IBOutlet UILabel *useLabel;
@property (weak, nonatomic) IBOutlet UILabel *showVipLevel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voucherMoney_left;

/** 是否从游戏详情领取代金券 */
@property (nonatomic, assign) BOOL isDetail;
@property (nonatomic, strong) MyVoucherListModel * voucherModel;
@property (nonatomic, strong) UIViewController * currentVC;

@end

NS_ASSUME_NONNULL_END
