//
//  MyServicesContactCell.m
//  Game789
//
//  Created by Maiyou on 2020/10/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyServicesContactCell.h"
#import "WXApi.h"

@implementation MyServicesContactCell

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
    
    self.showIcon.image = MYGetImage(dataDic[@"icon"]);
    
    self.showTitle.text = dataDic[@"title"];
    
    self.showValue.text = dataDic[@"value"];
    
    [self.actionBtn setTitle:dataDic[@"btn"] forState:0];
    
    NSInteger type = [dataDic[@"type"] integerValue];
    
    self.showTag.hidden = !(type == 8 || type == 6);
}

- (MyAddWxView *)addWxView
{
    if (!_addWxView)
    {
        _addWxView = [[MyAddWxView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _addWxView.dataDic = self.kefuDic;
    }
    return _addWxView;
}

- (IBAction)actionBtnClick:(id)sender
{
    NSInteger type = [self.dataDic[@"type"] integerValue];
    switch (type) {
        case 1:
        {
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.dataDic[@"value"]]];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
            break;
        case 2:
        {
            UIPasteboard * paste = [UIPasteboard generalPasteboard];
            paste.string = self.dataDic[@"value"];
            [MBProgressHUD showToast:@"已复制电子邮箱" toView:[YYToolModel getCurrentVC].view];
        }
            break;
        case 3:
        {
            NSURL * url = [NSURL URLWithString:@"https://www.facebook.com/%E5%92%AA%E5%9A%95%E9%81%8A%E6%88%B2-104617971319475"];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            
        }
            break;
        case 4:
        {
            UIPasteboard * paste = [UIPasteboard generalPasteboard];
            paste.string = self.dataDic[@"value"];
            [MBProgressHUD showToast:@"已复制" toView:[YYToolModel getCurrentVC].view];
        }
            break;
        case 5:
        {
            [self openQQ:type];
        }
            break;
        case 6:
        {
            // 判断手机是否安装微信
            NSURL *url = [NSURL URLWithString:@"weixin://"];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                NSString * weixin_url = self.kefuDic[@"kefu_weixin_url"];
                if (![weixin_url isBlankString])
                {
                    [UIApplication.sharedApplication openURL:[NSURL URLWithString:weixin_url] options:@{} completionHandler:^(BOOL success) {
                                        
                    }];
                }
                else
                {
                    //复制
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    [pasteboard setString:self.dataDic[@"value"]];
                    
                    [MBProgressHUD showToast:@"已复制微信号" toView:[YYToolModel getCurrentVC].view];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    });
                }
            }
            else
            {
                [MBProgressHUD showToast:@"该设备未安装微信,已复制微信号" toView:[YYToolModel getCurrentVC].view];
                
            }
        }
            break;
        case 7:
        {
            [self openQQ:type];
        }
            break;
        case 8:
        {
            NSString * url = self.kefuDic[@"kefu_weixin_url"];
            if ([WXApi isWXAppInstalled] && ![YYToolModel isBlankString:url]) {
                [UIApplication.sharedApplication openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                                    
                }];
            }else{
                [[UIApplication sharedApplication].keyWindow addSubview:self.addWxView];
            }
//            [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
//                NSLog(@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
//            }];
//            if ([WXApi isWXAppInstalled]) {
//                WXOpenCustomerServiceReq * req = [[WXOpenCustomerServiceReq alloc] init];
//                req.corpid = @"wwecef3a9edd6e2a8f";
//                req.url = @"https://work.weixin.qq.com/kfid/kfc9bb43cabdbfb909a";
//                [WXApi sendReq:req completion:^(BOOL success) {
//                    NSLog(@"success=%@",success?@"yes":@"no");
//                }];
//            }else{
//                [MBProgressHUD showToast:@"该设备未安装微信" toView:[YYToolModel getCurrentVC].view];
//            }
            
        }
            break;
            
        default:
            break;
    }
}

- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[WXOpenCustomerServiceResp class]]){
        int errCode = resp.errCode;        // 0 为成功，其余为失败
        NSString *string = ((WXOpenCustomerServiceResp *)resp).extMsg;    // 相关错误信息
        printf("code=%d,%s",errCode,[string UTF8String]);
    }
}

- (void)openQQ:(NSInteger)type
{
    //复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.dataDic[@"value"]];
    
    // 判断手机是否安装QQ
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
    {
        [MBProgressHUD showToast:type == 5 ? @"已复制QQ群号" : @"已复制QQ号" toView:[YYToolModel getCurrentVC].view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *qqstr = @"";
            if (type == 5)
            {
                qqstr = self.dataDic[@"key"];
            }
            else
            {
                qqstr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", self.dataDic[@"value"]];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qqstr] options:@{} completionHandler:nil];
        });
    }
    else
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tim://"]])
    {
        [MBProgressHUD showToast:type == 5 ? @"已复制QQ群号" : @"已复制QQ号" toView:[YYToolModel getCurrentVC].view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *qqstr = @"";
            if (type == 5)
            {
                qqstr = @"tim://";
            }
            else
            {
                qqstr = [NSString stringWithFormat:@"tim://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", self.dataDic[@"value"]];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:qqstr] options:@{} completionHandler:nil];
        });
    }
    else
    {
        [MBProgressHUD showToast:@"该设备未安装QQ,已复制QQ群号" toView:[YYToolModel getCurrentVC].view];
    }
}

@end
