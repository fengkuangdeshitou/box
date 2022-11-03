//
//  MyLimitedBuyingGiftCell.m
//  Game789
//
//  Created by Maiyou on 2021/1/14.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyLimitedBuyingGiftCell.h"
#import "MyActivityReceiveView.h"

@implementation MyLimitedBuyingGiftCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    AutoScrollLabel *autoScrollLabel = [[AutoScrollLabel alloc]initWithFrame:CGRectMake(0, 0, self.scrollLabelView.width, self.scrollLabelView.height)];
    autoScrollLabel.textColor = [UIColor whiteColor];
    autoScrollLabel.font = [UIFont systemFontOfSize:15];
    [self.scrollLabelView addSubview:autoScrollLabel];
    self.autoScrollLabel = autoScrollLabel;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.autoScrollLabel.text = dataDic[@"title"];
    
    self.showCoin.text = [NSString stringWithFormat:@"%@金币(会员%@金币)", [NSNumber numberWithFloat:[dataDic[@"amount"] floatValue]], [NSNumber numberWithFloat:[dataDic[@"vip_amount"] floatValue]]];

    self.showCount.text = [NSString stringWithFormat:@"剩余%@/%@", dataDic[@"surplus"], dataDic[@"total"]];
    
    self.showMoney.text = [NSString stringWithFormat:@"价值：%@元", dataDic[@"how_much"]];
    
    NSInteger status_type = [dataDic[@"status_type"] integerValue];
    if (status_type == 1)
    {
        self.exchangeBtn.backgroundColor = FontColorF6;
        [self.exchangeBtn setTitleColor:FontColor99 forState:0];
        [self.exchangeBtn setTitle:@"已抢完" forState:0];
    }
    else if (status_type == 2)
    {
        if ([dataDic[@"surplus"] integerValue] == 0)
        {
            self.exchangeBtn.backgroundColor = FontColorF6;
            [self.exchangeBtn setTitleColor:FontColor99 forState:0];
            [self.exchangeBtn setTitle:@"已抢完" forState:0];
        }
        else
        {
            if ([dataDic[@"is_receive"] integerValue] == 0)
            {
                self.exchangeBtn.backgroundColor = MAIN_COLOR;
                [self.exchangeBtn setTitleColor:ColorWhite forState:0];
                [self.exchangeBtn setTitle:@"立即兑换" forState:0];
            }
            else
            {
                self.exchangeBtn.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
                [self.exchangeBtn setTitleColor:FontColor99 forState:0];
                [self.exchangeBtn setTitle:@"已兑换" forState:0];
            }
        }
    }
    else if (status_type == 3)
    {
        self.exchangeBtn.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        [self.exchangeBtn setTitleColor:FontColor99 forState:0];
        [self.exchangeBtn setTitle:@"暂未开抢" forState:0];
    }
    
    NSInteger pack_type = [dataDic[@"pack_type"] integerValue];
    self.giftBgImage.image = [UIImage imageNamed:pack_type == 0 ? @"limited_cell_gift" : @"limited_cell_recharge"];
    
    [self layoutIfNeeded];
}

- (IBAction)exchangeBtnClick:(id)sender
{
    NSInteger status_type = [self.dataDic[@"status_type"] integerValue];
    NSInteger surplus    = [self.dataDic[@"surplus"] integerValue];
    NSInteger is_receive = [self.dataDic[@"is_receive"] integerValue];
    if (status_type != 2 || surplus == 0 || is_receive == 1) return;
    //统计
    NSDictionary * dic = @{@"type":@"礼包", @"time":self.exchangeTime, @"content":self.showGiftName.text};
    [MyAOPManager relateStatistic:@"ExchangeVouchersOrGiftPack" Info:dic];
    
    [self tipsAlertView:self.dataDic];
}

- (void)tipsAlertView:(NSDictionary *)dic
{
    MyActivityReceiveView * giftView = [[MyActivityReceiveView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    giftView.dataDic = dic;
    giftView.receiveGiftAction = ^{
        if (self.receivedActionBlock) {
            self.receivedActionBlock();
        }
    };
    [[YYToolModel getCurrentVC].view addSubview:giftView];
}

@end
