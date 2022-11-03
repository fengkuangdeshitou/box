//
//  PayAlertView.m
//  Game789
//
//  Created by maiyou on 2021/7/1.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "PayAlertView.h"
#import "TuuHUD.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayPlug.h"
#import "WebView.h"

@interface PayAlertView ()<UIScrollViewDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)UIView * toolbar;
@property(nonatomic,strong)UIButton * backButton;
@property(nonatomic,strong)UIView * contentView;
@property(nonatomic,strong)WebView * webView;

@end

@implementation PayAlertView

- (UIView *)toolbar{
    if (!_toolbar) {
        _toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44+8)];
        _toolbar.backgroundColor = UIColor.whiteColor;
        _toolbar.layer.cornerRadius = 8;
    }
    return _toolbar;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight*0.4, ScreenWidth, ScreenHeight*0.6)];
        _contentView.backgroundColor = UIColor.clearColor;
    }
    return _contentView;
}

- (WebView *)webView{
    if (!_webView) {
        WEAKSELF
        _webView = [[WebView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, self.contentView.height-44)];
        _webView.scrollView.bounces = NO;
        _webView.backgroundColor = [UIColor whiteColor];
//        _webView.delegate = self;
        if (@available(iOS 11.0, *)){
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        };
        _webView.weachatBlock = ^{
            [weakSelf dismiss];
        };
    }
    return _webView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.75];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.toolbar];
        [self.contentView addSubview:self.webView];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backButton.frame = CGRectMake(10, 0, 44, 44);
        [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(webviewBackAction) forControlEvents:UIControlEventTouchUpInside];
        self.backButton.hidden = YES;
        [self.toolbar addSubview:self.backButton];
        
        UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(ScreenWidth-54, 0, 44, 44);
        [closeButton setImage:[UIImage imageNamed:@"download_close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.toolbar addSubview:closeButton];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.toolbar.width/2-100, 0, 200, 44)];
        titleLabel.textAlignment = 1;
        titleLabel.text = @"选择支付方式";
        titleLabel.textColor = [UIColor colorWithHexString:@"#282828"];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [self.toolbar addSubview:titleLabel];
        
    }
    return self;
}

- (void)webviewBackAction{
    [self.webView goBack];
}

- (void)setUrl:(NSString *)url{
    _url = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

- (void)dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.webView = nil;
        [self removeFromSuperview];
    }];
}

- (void)dealloc {
    self.webView = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
