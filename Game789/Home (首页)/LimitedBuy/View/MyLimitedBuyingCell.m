//
//  MyLimitedBuyingCell.m
//  Game789
//
//  Created by Maiyou on 2021/1/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyLimitedBuyingCell.h"
#import "MyActivityReceiveView.h"

#import "MyLimitedBuyingApi.h"
@class MyLimitedBuyReceivedApi;

@implementation MyLimitedBuyingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showAmountTag.text = @"￥";
    self.showAmount.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:[dataDic[@"money"] floatValue]]];
    self.showAmount.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    self.showMeetAmount.text = @"代金券";
    
    self.showcoin.text = [NSString stringWithFormat:@"%@金币(会员%@金币)", [NSNumber numberWithFloat:[dataDic[@"amount"] floatValue]], [NSNumber numberWithFloat:[dataDic[@"vip_amount"] floatValue]]];

    self.showCount.text = [NSString stringWithFormat:@"剩余%@/%@", dataDic[@"surplus"], dataDic[@"total"]];
    
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
    
    [self layoutIfNeeded];
}

- (IBAction)exchangeBtnClick:(id)sender
{
    NSInteger status_type = [self.dataDic[@"status_type"] integerValue];
    NSInteger surplus = [self.dataDic[@"surplus"] integerValue];
    NSInteger is_receive = [self.dataDic[@"is_receive"] integerValue];
    if (status_type != 2 || surplus == 0 || is_receive == 1) return;
    //统计
    NSDictionary * dic = @{@"type":@"代金券", @"time":self.exchangeTime, @"content":[NSString stringWithFormat:@"%@元代金券", self.dataDic[@"money"]]};
    [MyAOPManager relateStatistic:@"ExchangeVouchersOrGiftPack" Info:dic];
    
    [self tipsAlertView:self.dataDic];
}

- (void)exchangeVoucherRequest
{
    UIView * view = [YYToolModel getCurrentVC].view;
    //兑换请求
    MyLimitedBuyReceivedApi * api = [[MyLimitedBuyReceivedApi alloc] init];
    api.isShow = YES;
    api.receiveId = self.dataDic[@"id"];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            if ([self.dataDic[@"type"] integerValue] == 1)
            {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
                [dic setValue:request.data[@"amount"] forKey:@"user_coin"];
                [dic setValue:request.data[@"use_end_time"] forKey:@"use_end_time"];
                [self tipsAlertView:dic];
            }
            if (self.receivedActionBlock) {
                self.receivedActionBlock();
            }
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:view];
    }];
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
