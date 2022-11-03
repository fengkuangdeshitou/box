//
//  MyShowVoucherInfoCell.m
//  Game789
//
//  Created by Maiyou on 2020/7/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyShowVoucherInfoCell.h"

@implementation MyShowVoucherInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.receivedBtn.titleLabel.numberOfLines = 0;
}

- (void)setVoucherModel:(MyVoucherListModel *)voucherModel
{
    _voucherModel = voucherModel;
    
    self.showMoney.text = [NSString stringWithFormat:@"%@", @([voucherModel.amount floatValue])];
        
    if ([voucherModel.use_type isEqualToString:@"direct"])
    {
        self.showDiscount.text = [NSString stringWithFormat:@"%@%@%@", @"仅限".localized, @([voucherModel.meet_amount floatValue]), @"元档可用".localized];
    }
    else
    {
        self.showDiscount.text = [voucherModel.meet_amount floatValue] == 0 ? @"任意金额" : [NSString stringWithFormat:@"%@%@%@", @"满".localized, @([voucherModel.meet_amount floatValue]), @"元可用".localized];
    }
    
    if ([voucherModel.is_received boolValue])
    {
        self.showBgImage.image = MYGetImage(@"detail_voucher_bg_received");
        [self.receivedBtn setTitle:[NSString stringWithFormat:@"已\n领\n取"] forState:0];
    }
    else
    {
        self.showBgImage.image = MYGetImage(@"detail_voucher_bg_normal");
        [self.receivedBtn setTitle:[NSString stringWithFormat:@"领\n取"] forState:0];
    }
}

- (IBAction)receivedBtnClick:(id)sender
{
    
}

@end
