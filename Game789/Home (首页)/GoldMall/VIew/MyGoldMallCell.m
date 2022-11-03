//
//  MyGoldMallCell.m
//  Game789
//
//  Created by maiyou on 2021/3/11.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyGoldMallCell.h"
#import "GoldMallRequestAPI.h"
#import "GoldExchangeAlertView.h"

@interface MyGoldMallCell ()<GoldExchangeAlertViewDelegate>

@property(nonatomic,weak)IBOutlet UILabel * amountLabel;
@property(nonatomic,weak)IBOutlet UILabel * descLabel;
@property(nonatomic,weak)IBOutlet UILabel * timeLabel;
@property(nonatomic,weak)IBOutlet UILabel * priceLabel;
@property(nonatomic,weak)IBOutlet UILabel * inventoryLabel;
@property(nonatomic,weak)IBOutlet UIButton * exchangeButton;
@property (weak, nonatomic) IBOutlet UILabel *gameTypelabel;
@property (weak, nonatomic) IBOutlet UILabel *voucherTypelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voucherType_right;

@end

@implementation MyGoldMallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setModel:(GoldMallModel *)model
{
    _model = model;
    
    if ([YYToolModel isBlankString:model.label])
    {
        self.voucherTypelabel.hidden = YES;
        self.voucherType_right.constant = 0;
    }
    else
    {
        self.voucherTypelabel.hidden = NO;
        self.voucherType_right.constant = 6;
        self.voucherTypelabel.text = [model.label VerticalString];
    }
    self.descLabel.text = [NSString stringWithFormat:@"(%@)", model.useDesc];
    self.gameTypelabel.text = model.desc;
    self.amountLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:model.amount.floatValue]];
    self.inventoryLabel.text = [NSString stringWithFormat:@"会员价:%@金币", model.vipBalance];
    self.priceLabel.text = [NSString stringWithFormat:@"非会员:%@金币",model.generalBalance];
    self.timeLabel.text = [NSString stringWithFormat:@"有效期:%@天",model.days];
//    if (model.received.intValue == 0)
//    {
        self.exchangeButton.backgroundColor = [UIColor colorWithHexString:@"#F15B24"];
        [self.exchangeButton setTitle:@"兑换" forState:UIControlStateNormal];
        self.exchangeButton.enabled = YES;
//    }
//    else
//    {
//        self.exchangeButton.backgroundColor = [UIColor colorWithHexString:@"##DEDEDE"];
//        [self.exchangeButton setTitle:@"已兑换" forState:UIControlStateNormal];
//        self.exchangeButton.enabled = NO;
//    }
    
}

/// 兑换代金券
/// @param sender 按钮
- (IBAction)exchange:(UIButton *)sender
{
    NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
    [GoldExchangeAlertView showGoldExchangeAlertViewWithNumber:[dic[@"vip_level"] integerValue] > 0 ? self.model.vipBalance : self.model.generalBalance delegate:self];
}

#pragma mark - GoldExchangeAlertViewDelegate

- (void)goldExchangeAlertViewDidEcchange{
    GoldMallRequestAPI * api = [[GoldMallRequestAPI alloc] init];
    api.voucherType = @"1";
    api.voucherId = self.model.Id;
    api.isShow = NO;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1) {
            [MyAOPManager userInfoRelateStatistic:@"ClickToExchangeThresholdCashCoupon"];
            [YJProgressHUD showSuccess:@"兑换成功" inview:self];
            if (self.delegate && [self.delegate respondsToSelector:@selector(onExchangeSuccess)]) {
                [self.delegate onExchangeSuccess];
            }
        }else{
            [MBProgressHUD showToast:request.error_desc toView:self];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:self];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
