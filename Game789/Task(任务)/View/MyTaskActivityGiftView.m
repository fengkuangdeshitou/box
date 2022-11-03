//
//  MyTaskActivityGiftView.m
//  Game789
//
//  Created by Maiyou on 2020/10/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTaskActivityGiftView.h"
#import "MyTaskCenterApi.h"
@class MyTaskExchangeApi;

@implementation MyTaskActivityGiftView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyTaskActivityGiftView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return self;
}

- (IBAction)sureBtnClick:(id)sender
{
    if (self.exchangeCode.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入兑换码" toView:[YYToolModel getCurrentVC].view];
        return;
    }
    [self removeFromSuperview];
    MyTaskExchangeApi * api = [[MyTaskExchangeApi alloc] init];
    api.isShow = YES;
    api.code = self.exchangeCode.text;
    api.type = @"active";
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            if (self.exchangeGiftBlock)
            {
                self.exchangeGiftBlock();
            }
            [YJProgressHUD showSuccess:@"兑换成功" inview:[YYToolModel getCurrentVC].view];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (IBAction)closeBtnClick:(id)sender
{
    [self removeFromSuperview];
}

@end
