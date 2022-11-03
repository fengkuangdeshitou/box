//
//  MyCustomerServiceHeaderView.m
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyCustomerServiceHeaderView.h"

@implementation MyCustomerServiceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyCustomerServiceHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureQQAction)];
        [self.backView1 addGestureRecognizer:tap1];
        
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureWxAction)];
        [self.backView2 addGestureRecognizer:tap2];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showQQ.text = dataDic[@"qq"];
    self.showWx.text = dataDic[@"wechat_public_number_title"];
    self.showOnlineTime.text = [NSString stringWithFormat:@"在线时间：%@", dataDic[@"online_time"]];
}

- (void)tapGestureQQAction
{
    if (self.dataDic[@"qq"])
    {
        //复制
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.dataDic[@"qq"]];
        
        // 判断手机是否安装QQ
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
        {
            [MBProgressHUD showToast:@"已复制QQ号" toView:[YYToolModel getCurrentVC].view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", self.dataDic[@"qq"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qqstr]];
            });
        }
        else
        {
            [MBProgressHUD showToast:@"该设备未安装QQ,已复制QQ" toView:[YYToolModel getCurrentVC].view];
        }
    }
    else
    {
        [MBProgressHUD showToast:@"暂无客服QQ" toView:[YYToolModel getCurrentVC].view];
    }
}

- (void)tapGestureWxAction
{
    if (self.dataDic[@"wechat_public_number_id"])
    {
        //复制
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.dataDic[@"wechat_public_number_title"]];
        
        // 判断手机是否安装微信
        NSURL *url = [NSURL URLWithString:@"weixin://"];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [MBProgressHUD showToast:@"已复制公众号" toView:[YYToolModel getCurrentVC].view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] openURL:url];
            });
        }
        else
        {
            [MBProgressHUD showToast:@"该设备未安装微信" toView:[YYToolModel getCurrentVC].view];
        }
    }
    else
    {
        [MBProgressHUD showToast:@"暂未开通公众号" toView:[YYToolModel getCurrentVC].view];
    }
}

@end
