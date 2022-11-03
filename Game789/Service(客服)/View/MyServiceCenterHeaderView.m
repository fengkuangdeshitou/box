//
//  MyServiceCenterHeaderView.m
//  Game789
//
//  Created by Maiyou001 on 2021/11/24.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyServiceCenterHeaderView.h"

@implementation MyServiceCenterHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyServiceCenterHeaderView" owner:self options:nil].firstObject;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showPublishWx.text = [NSString stringWithFormat:@"打开微信搜索“%@”公众号，并关注", dataDic[@"wechat_public_number_title"]];
    
    if ([dataDic[@"is_private_kefu"] boolValue])
    {
        self.height = self.serviceView.bottom + 10;
        self.serviceView.hidden = NO;
    }
    else
    {
        self.height = self.topView.bottom + 10;
        self.serviceView.hidden = YES;
    }
}

- (IBAction)pasteBtnClick:(id)sender
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
