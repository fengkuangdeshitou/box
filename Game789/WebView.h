//
//  WebView.h
//  Game789
//
//  Created by maiyou on 2021/7/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebView : WKWebView

/// 网络url
@property (strong, nonatomic) NSString *urlString;
/// html字符串
@property (strong, nonatomic) NSString *htmlString;
/// 进度条颜色
@property (strong, nonatomic) UIColor * progressColor;

@property (nonatomic,copy) void(^weachatBlock)(void);

@end

NS_ASSUME_NONNULL_END
