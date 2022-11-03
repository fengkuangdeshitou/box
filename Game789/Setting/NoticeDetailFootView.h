//
//  NoticeDetailFootView.h
//  Game789
//
//  Created by xinpenghui on 2017/9/10.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeDetailFootViewDelegate <NSObject>

- (void)getPressAction:(NSString *)string;
- (void)footViewPress:(NSString *)string;

@end

@interface NoticeDetailFootView : UIView

@property (nonatomic, strong) UIViewController * currentVC;

@property (weak, nonatomic)id <NoticeDetailFootViewDelegate>delegate;

- (void)setModelDic:(NSDictionary *)dic;

@end
