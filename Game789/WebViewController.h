//
//  WebViewController.h
//  Game789
//
//  Created by maiyou on 2021/7/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import "WebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : BaseViewController

@property (strong, nonatomic) WebView * webView;

/// 是否全屏
@property (assign, nonatomic) BOOL isFullScreen;
/// 网络url
@property (copy, nonatomic) NSString *urlString;
/// html字符串
@property (copy, nonatomic) NSString *htmlString;
/// 进度条颜色
@property (strong, nonatomic) UIColor * progressColor;
/** 是否dismiss关掉页面   */
@property (nonatomic, assign) BOOL isDismiss;
/// title 默认显示web的标题，没有则显示传过来的
@property (copy, nonatomic) NSString *webTitle;

@end

NS_ASSUME_NONNULL_END
