//
//  MyReceiveFirstChargeCell.m
//  Game789
//
//  Created by Maiyou001 on 2021/11/17.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyReceiveFirstChargeCell.h"
#import "MyGetVoucherListApi.h"
@class MyReceiveGameVoucherApi;

@implementation MyReceiveFirstChargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.gameCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GameTableViewCell class]) owner:self options:nil] firstObject];
    self.gameCell.frame = CGRectMake(0, 0, ScreenWidth, 110);
    [self.contentView addSubview:self.gameCell];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gameCell.height = self.height-54;
    [YYToolModel clipRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight radius:13 view:self.gameCell.radiusView];
}

- (void)setGameModel:(MyWelfareCenterGameModel *)gameModel
{
    _gameModel = gameModel;
    
    [self.gameCell setModelDic:gameModel.data];
    
    self.showDesc.text = gameModel.voucherDesc;
    
    self.showMoney.text = gameModel.amount;
    
    BOOL isSelected = [gameModel.received boolValue];
    self.receiveBtn.selected = isSelected;
    self.receiveBtn.backgroundColor = isSelected ? FontColorDE : MAIN_COLOR;
    [self.receiveBtn setTitle:isSelected?@"已领取":@"领取" forState:UIControlStateNormal];

}

- (IBAction)receiveAction:(UIButton *)sender
{
    if ([self.gameModel.received boolValue])
    {
        return;
    }
    MyReceiveGameVoucherApi * api = [[MyReceiveGameVoucherApi alloc] init];
    api.voucher_id = [NSString stringWithFormat:@"%@", self.gameModel.voucherId];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (api.success == 1) {
            if (![request.data[@"hasSome"] boolValue])
            {
                [sender setTitle:@"已领取".localized forState:UIControlStateNormal];
                sender.backgroundColor = FontColorDE;
                self.gameModel.received = @"1";
            }
            else{
                [YJProgressHUD showSuccess:@"领取成功" inview:[YYToolModel getCurrentVC].view];
            }
        }else {
            [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
