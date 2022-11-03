//
//  MyUserAgreementView.m
//  Game789
//
//  Created by Maiyou on 2020/10/27.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyUserAgreementView.h"

@implementation MyUserAgreementView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyUserAgreementView" owner:self options:nil].firstObject;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.frame = frame;
        self.layer.zPosition = 0;
        
        // 1.获得网络监控的管理者
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        // 2.设置网络状态改变后的处理
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            self.web.urlString = [LoginPrivacyPolicyUrl stringByAppendingString:@"&target=_blank"];
        }];
        
        // 3.开始监控
        [manager startMonitoring];
        
        self.web = [[WebView alloc] initWithFrame:self.contentView.bounds];
        self.web.urlString = [LoginPrivacyPolicyUrl stringByAppendingString:@"&target=_blank"];
        [self.contentView addSubview:self.web];
    }
    return self;
}

- (void)layoutSubviews{
    self.web.frame = self.contentView.bounds;
}

//- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel
//{
//    if ([linkText isEqualToString:@"《用户协议》"])
//    {
//        WebViewController * web = [WebViewController new];
//        web.urlString = LoginUserAgreementUrl;
//        if (@available(iOS 13.0, *)) {
//            web.modalPresentationStyle = UIModalPresentationFullScreen;
//        }
//        web.isDismiss = YES;
//        [[YYToolModel getCurrentVC] presentViewController:web animated:YES completion:nil];
//    }
//    else if ([linkText isEqualToString:@"《隐私政策》"])
//    {
//        WebViewController * web = [WebViewController new];
//        web.urlString = LoginPrivacyPolicyUrl;
//        if (@available(iOS 13.0, *)) {
//            web.modalPresentationStyle = UIModalPresentationFullScreen;
//        }
//        web.isDismiss = YES;
//        [[YYToolModel getCurrentVC] presentViewController:web animated:YES completion:nil];
//    }
//}

- (IBAction)disagreeBtnClick:(id)sender
{
    [self removeFromSuperview];
    
    exit(0);
}

- (IBAction)agreeBtnClick:(id)sender
{
    [self removeFromSuperview];
    
    if (self.agreeBtnClickBlock) {
        self.agreeBtnClickBlock();
    }
}

@end
