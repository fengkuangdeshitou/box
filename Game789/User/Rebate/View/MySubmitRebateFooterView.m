//
//  MySubmitRebateFooterView.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MySubmitRebateFooterView.h"
#import "MySubmitRebateNoticeView.h"

@implementation MySubmitRebateFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MySubmitRebateFooterView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.textView.delegate = self;
        self.textView.zw_placeHolder = @"请您仔细核对线下活动是否有自选道具需要选择，请您选择后在备注栏填写；返利问题，游戏问题，大额充值特殊需求可直接联系专属客服。";
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView
{
    MYLog(@"======%@", textView.text);
    if (textView.text.length > 100)
    {
        textView.text = [textView.text substringToIndex:100];
    }
    self.showCount.text = [NSString stringWithFormat:@"%lu/100", (unsigned long)textView.text.length];
}

- (IBAction)submitBtnClick:(id)sender
{
    MySubmitRebateNoticeView * noticeView = [[MySubmitRebateNoticeView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    noticeView.submitRebateAction = ^(NSString * _Nonnull content) {
        if (self.submitRebateAction)
        {
            self.submitRebateAction(self.textView.text);
        }
    };
    [[UIApplication sharedApplication].delegate.window addSubview:noticeView];
}


@end
