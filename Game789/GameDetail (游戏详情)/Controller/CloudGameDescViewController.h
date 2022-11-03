//
//  CloudGameDescViewController.h
//  Game789
//
//  Created by maiyou on 2022/4/27.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CloudGameDescViewController : UIViewController

//是否可以开始云游
@property (nonatomic, assign) BOOL isStart;

//按钮点击事件回传
@property (nonatomic, copy) void(^btnClick)(BOOL type);

- (instancetype)initWithStatus:(BOOL)isStart;

@end

NS_ASSUME_NONNULL_END
