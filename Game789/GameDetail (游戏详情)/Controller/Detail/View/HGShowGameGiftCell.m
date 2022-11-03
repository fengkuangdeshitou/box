//
//  HGShowGameGiftCell.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/25.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGShowGameGiftCell.h"
#import "MyGameGiftDetailController.h"

@implementation HGShowGameGiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.giftTitle.text = dataDic[@"packname"];
    
    self.giftContent.text = dataDic[@"packcontent"];
    
    self.vipGiftImageView.hidden = [dataDic[@"gift_type"] integerValue] != 4;
    
    self.showVipLevel.hidden = [dataDic[@"gift_type"] integerValue] != 4;
    
    self.showVipLevel.text = dataDic[@"vip_level_desc"];
    
//    //通用礼包
//    if ([dataDic[@"isReceive"] boolValue])
//    {
//        self.receivedBtn.enabled = YES;
//        if ([dataDic[@"isReceived"] boolValue])
//        {
//            self.giftCodeView_top.constant = 10;
//            self.giftCodeView_height.constant = 15;
//            self.giftCodeView.hidden = NO;
//            [self.receivedBtn setTitle:@"复制" forState:0];
//            self.giftCode.text = dataDic[@"receivedCdk"];
//        }
//        else
//        {
//            self.giftCodeView_top.constant = 0;
//            self.giftCodeView_height.constant = 0;
//            self.giftCodeView.hidden = YES;
//            [self.receivedBtn setTitle:@"领取" forState:0];
//        }
//    }
//    else
//    {//非通用礼包不能直接领取
        self.giftCodeView_top.constant = 0;
        self.giftCodeView_height.constant = 0;
        self.giftCodeView.hidden = YES;
//        [self.receivedBtn setTitle:@"查看" forState:0];
//        self.receivedBtn.enabled = NO;
//    }
    NSString * starttime = [NSDate dateWithFormat:@"yyyy-MM-dd" WithTS:[dataDic[@"starttime"] longLongValue]];
    NSString * endtime = [NSDate dateWithFormat:@"yyyy-MM-dd" WithTS:[dataDic[@"endtime"] longLongValue]];
    self.periodValidity.text = [NSString stringWithFormat:@"有效期：%@至%@",starttime,endtime];
    if ([dataDic[@"is_received"]boolValue]) {
        [self.receivedBtn setTitle:@"复制" forState:UIControlStateNormal];
        self.receivedBtn.backgroundColor = [UIColor colorWithHexString:@"#80C5FE"];
    }else{
        [self.receivedBtn setTitle:@"领取" forState:UIControlStateNormal];
        self.receivedBtn.backgroundColor = MAIN_COLOR;
    }
}

#pragma mark — 领取
- (IBAction)receiveGameGiftClick:(UIButton *)sender
{
//    if (self.receiveGiftAction) {
//        self.receiveGiftAction(self.dataDic[@"packid"]);
//    }
    
    if ([sender.titleLabel.text isEqualToString:@"复制"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.dataDic[@"pack_card"];
        [MBProgressHUD showToast:@"已复制到粘贴板"];
        return;
    }
    
    MyGameGiftDetailController * detail = [MyGameGiftDetailController new];
    detail.isReceived = YES;
    detail.gift_id = self.dataDic[@"packid"];
    detail.vc = self.vc ? self.vc : YYToolModel.getCurrentVC;
    [[YYToolModel getCurrentVC] presentViewController:detail animated:YES completion:nil];
    detail.receivedGiftCodeBlock = ^{
        if (self.receiveGiftAction) {
            self.receiveGiftAction(self.dataDic[@"packid"]);
        }
    };
}

@end
