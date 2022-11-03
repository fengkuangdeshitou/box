//
//  MyDownGameVipNoticeView.m
//  Game789
//
//  Created by Maiyou on 2019/9/10.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyDownGameVipNoticeView.h"

@implementation MyDownGameVipNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyDownGameVipNoticeView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        if ([DeviceInfo shareInstance].data)
        {
            NSString * string = [DeviceInfo shareInstance].data[@"vipinfo"];
            string = [string stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            self.textView.text = string;
        }
    }
    return self;
}

#pragma mark — 去下载至尊版盒子
- (IBAction)downVipGameClick:(id)sender
{
    [self removeFromSuperview];
    
    NSString * vip_app_url = [YYToolModel getUserdefultforKey:@"vip_app_url"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:vip_app_url]];
    
    if (self.CloseView) {
        self.CloseView();
    }
}

#pragma mark — 关闭页面
- (IBAction)closeButtonClick:(id)sender
{
    [self removeFromSuperview];
}

@end
