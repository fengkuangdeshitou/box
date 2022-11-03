//
//  AppDelegate.h
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoutingHTTPServer.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) RoutingHTTPServer *httpServer;

@property (nonatomic,strong) HTTPServer *localHttpServer;
@property (nonatomic,copy) NSString *port;

//启动本地服务
- (void)configLocalHttpServer;
//获取版本
- (void)getVersionApiRequest;

- (void)getHomePageMaterial;

- (void)getTopButtonCount;

@end

