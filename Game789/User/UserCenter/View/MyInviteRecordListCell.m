//
//  MyInviteRecordListCell.m
//  Game789
//
//  Created by Maiyou001 on 2021/5/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyInviteRecordListCell.h"

@interface MyInviteRecordListCell ()

@property(nonatomic,weak)IBOutlet UILabel * invite;
@property(nonatomic,weak)IBOutlet UILabel * amount;
@property(nonatomic,weak)IBOutlet UILabel * coin_total;

@end

@implementation MyInviteRecordListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInviteModel:(InviteRecordModel *)InviteModel{
    _InviteModel = InviteModel;
    self.invite.text = InviteModel.invite;
    self.amount.text = InviteModel.amount;
    self.coin_total.text = InviteModel.coin_total;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
