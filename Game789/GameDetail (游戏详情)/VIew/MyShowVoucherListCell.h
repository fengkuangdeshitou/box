//
//  MyShowVoucherListCell.h
//  Game789
//
//  Created by Maiyou on 2019/10/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyShowVoucherListCell : BaseTableViewCell

@property (nonatomic, strong) NSDictionary * dataDic;
@property (weak, nonatomic) IBOutlet UILabel *showMoney;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *showVoucherMoney;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showMoney_width;

@end

NS_ASSUME_NONNULL_END
