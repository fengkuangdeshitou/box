//
//  MyVoucherUseIntroView.m
//  Game789
//
//  Created by Maiyou on 2020/5/12.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyVoucherUseIntroView.h"

@implementation MyVoucherUseIntroView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyVoucherUseIntroView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
        self.textView.delegate = self;
        self.textView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSString * startTime = [NSDate dateTimeStringWithTS:[dataDic[@"start_time"] doubleValue]];
    NSString * endTime = [NSDate dateTimeStringWithTS:[dataDic[@"end_time"] doubleValue]];
    NSString * showTime = @"";
    if ([dataDic[@"start_time"] doubleValue] == 0 && [dataDic[@"end_time"] doubleValue] > 0)
    {
        showTime = [NSString stringWithFormat:@"%@%@", @"使用截止时间".localized, endTime];
    }
    else if ([dataDic[@"start_time"] doubleValue] > 0 && [dataDic[@"end_time"] doubleValue] == 0)
    {
        showTime = [NSString stringWithFormat:@"%@%@", @"使用起始时间".localized, startTime];
    }
    else if ([dataDic[@"start_time"] doubleValue] > 0 && [dataDic[@"end_time"] doubleValue] > 0)
    {
        showTime = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
    }
    else
    {
        showTime = @"不限制使用时间".localized;
    }
    
    NSString * useRang = dataDic[@"game_id"] ? [NSString stringWithFormat:@"%@《%@》%@", @"仅限".localized, dataDic[@"game_name"], @"充值使用".localized] : dataDic[@"game_name"];;
    
    NSString * amount = [dataDic[@"meet_amount"] floatValue] == 0 ? @"任意金额" : [NSString stringWithFormat:@"%@%@%@", @"满".localized, @([dataDic[@"meet_amount"] floatValue]), @"元可用".localized];
    if ([dataDic[@"use_type"] isEqualToString:@"direct"])
    {
        amount = [NSString stringWithFormat:@"%@%@%@", @"仅限".localized, @([dataDic[@"meet_amount"] floatValue]), @"元档可用".localized];
    }
    else
    {
        amount = [dataDic[@"meet_amount"] floatValue] == 0 ? @"任意金额" : [NSString stringWithFormat:@"%@%@%@", @"满".localized, @([dataDic[@"meet_amount"] floatValue]), @"元可用".localized];
    }
    
    if (dataDic[@"except_games"] && [dataDic[@"except_games"] count] > 0)
    {
        NSString * text = [NSString stringWithFormat:@"可用范围：%@（限制游戏除外）\n有效期：%@\n使用条件：%@\n使用方法：\n1.使用App账号登录游戏；\n2.在游戏内购买道具；\n3.在支付页面选择可用的优惠券，完成支付。\n使用说明：\n1.无门槛代金券为一次性消耗代金券，未使用部分不支持补差价。\n2.代充代金券支持混合支付，且可分多次支付，直至代金券余额消耗完。", useRang, showTime, amount];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
        //调整行间距
        paragraphStyle.lineSpacing = 3;
        self.textView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#F32C2C"]};
        [att addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]} range:NSMakeRange(0, text.length)];
//        [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F32C2C"] range:[text rangeOfString:@"限制游戏除外"]];
        [att addAttribute:NSLinkAttributeName value:@"privacy://" range:[text rangeOfString:@"限制游戏除外"]];
        self.textView.attributedText = att;
    }
    else
    {
        NSString * text = [NSString stringWithFormat:@"可用范围：%@\n有效期：%@\n使用条件：%@\n使用方法：\n1.使用App账号登录游戏；\n2.在游戏内购买道具；\n3.在支付页面选择可用的优惠券，完成支付。\n使用说明：\n1.无门槛代金券为一次性消耗代金券，未使用部分不支持补差价。\n2.代充代金券支持混合支付，且可分多次支付，直至代金券余额消耗完。", useRang, showTime, amount];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
        //调整行间距
        paragraphStyle.lineSpacing = 3;
        [att addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]} range:NSMakeRange(0, text.length)];
        self.textView.attributedText = att;
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange
{
    if ([URL.scheme isEqualToString:@"privacy"])
    {
        NSString * str = @"";
        NSArray * array = self.dataDic[@"except_games"];
        for (int i = 0; i < [array count]; i ++)
        {
            if ([str isEqualToString:@""])
            {
                str = array[i][@"name"];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@，%@", str, array[i][@"name"]];
            }
        }
        [self.currentVC jxt_showAlertWithTitle:@"限制游戏" message:str appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.addActionCancelTitle(@"我知道了");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            
        }];
        return NO;
    }
    return YES;
}

- (IBAction)closeBtnClick:(id)sender
{
    [self removeFromSuperview];
}

@end
