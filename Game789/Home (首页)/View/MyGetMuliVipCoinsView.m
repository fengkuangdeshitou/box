//
//  MyGetMuliVipCoinsView.m
//  Game789
//
//  Created by Maiyou on 2019/7/23.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGetMuliVipCoinsView.h"
#import "SegmentTypeApi.h"

@implementation MyGetMuliVipCoinsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyGetMuliVipCoinsView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return self;
}

- (IBAction)receiveCoinsClick:(id)sender
{
    [self removeFromSuperview];
    
    if (![YYToolModel islogin])
    {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        loginVC.quickLoginBlock = ^{
            [self receiveRequest];
        };
        [[YYToolModel getCurrentVC].navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    [self receiveRequest];
}

- (void)receiveRequest
{
    ReceiveMiluVipCionsApi * api = [ReceiveMiluVipCionsApi sharedInstance];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1) {
            [YJProgressHUD showSuccess:@"领取成功，请到“我的”查看" inview:[UIApplication sharedApplication].keyWindow];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

@end
