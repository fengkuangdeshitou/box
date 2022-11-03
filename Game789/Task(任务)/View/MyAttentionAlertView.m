//
//  MyAttentionAlertView.m
//  Game789
//
//  Created by Maiyou on 2020/10/19.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyAttentionAlertView.h"

#import "MyTaskCenterApi.h"
@class MyTaskExchangeApi;

@implementation MyAttentionAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyAttentionAlertView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return self;
}

- (void)setIsWx:(BOOL)isWx
{
    _isWx = isWx;
    
    if (!isWx)
    {
        self.wxBtn_top.constant = 0;
        self.wxBtn_height.constant = 0;
        self.showBgImage_height.constant = 370;
    }
    else
    {
        self.showBgImage_height.constant = 405;
    }
    [self layoutIfNeeded];
    
    self.showTitleImage.image = MYGetImage(!isWx ? @"task_douyin_title_image" : @"task_wx_title_image");
    
//    NSString * string = isWx ? @"1.打开微信点击右上角+，选择添加好友\n2.选择公众号搜索“咪噜游戏官方平台”\n3.关注公众号，点击“咪噜福利”，获取并复制兑换码\n4.返回盒子输入兑换码，完成任务，金币到账" : [NSUserDefaults.standardUserDefaults objectForKey:@"douyin-tips"];
//    if (self.is_ua8x)
//    {
//        string = isWx ? @"1.打开微信点击右上角+，选择添加好友\n2.选择公众号搜索“奇葩游平台”\n3.关注公众号，点击“关注有礼”，获取并复制 兑换码\n4.返回盒子输入兑换码，完成任务，金币到账" : @"1.打开抖音APP点击首页右上角搜索“奇葩游游戏”\n2.关注后进入首页，右上角点击“私信”\n3.弹出对话栏后，输入“礼包码”发送\n4.官方账号会自动回复兑换码，复制后返回盒子“新手任务-关注抖音账号-输入礼包码兑换”即可完成任务，金币到账！";
//    }
    [self setLabelSpace:1 withFont:[UIFont systemFontOfSize:12] Text:self.tips];
}

- (void)setLabelSpace:(CGFloat)space withFont:(UIFont*)font Text:(NSString *)text
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = space; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:text attributes:dic];
    self.showContent.attributedText = attributeStr;
}

#pragma mark ——— 确认兑换
- (IBAction)sureButtonClick:(id)sender
{
    if (self.enterCode.text.length == 0)
    {
        [MBProgressHUD showToast:@"请输入兑换码" toView:[YYToolModel getCurrentVC].view];
        return;
    }
    [self removeFromSuperview];
    MyTaskExchangeApi * api = [[MyTaskExchangeApi alloc] init];
    api.isShow = YES;
    api.code = self.enterCode.text;
    api.type = self.isWx ? @"weixin" : @"douyin";
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            if (self.exchangeCodeBlock)
            {
                self.exchangeCodeBlock(self.isWx);
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

#pragma mark ——— 关闭页面
- (IBAction)closeBtnClick:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)openWxClick:(id)sender
{
    [self removeFromSuperview];
    
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [MBProgressHUD showToast:@"该设备暂未安装微信" toView:[YYToolModel getCurrentVC].view];
    }
}

@end
