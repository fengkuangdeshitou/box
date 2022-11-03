//
//  DWTabBar.m
//  DWCustomTabBarDemo
//
//  Created by Damon on 10/20/15.
//  Copyright © 2015 damonwong. All rights reserved.
//

#import "DWTabBar.h"

#import "UIColor+HexString.h"
#import "macro.h"

#define ButtonNumber 5


@interface DWTabBar ()



@end

@implementation DWTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        // 显示分割线
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView];
        
        DWPublishButton *button = [DWPublishButton publishButton];
        [self addSubview:button];
        self.publishButton = button;

        
    }
    
    return self;
}

- (void)index {
    NSLog(@"index dlfds ");
}
-(void)layoutSubviews{


    NSLog(@"%s",__func__);

    [super layoutSubviews];

    CGFloat barWidth = self.frame.size.width;
    CGFloat barHeight = self.frame.size.height;
    CGFloat buttonW = barWidth / ButtonNumber;
    CGFloat buttonH = barHeight - 5;
    CGFloat buttonY = 1;

    self.publishButton.center = CGPointMake(barWidth * 0.5, barHeight * 0.3);
    if (barHeight > 49) {
        // iphone x
        buttonH = 47;
        buttonY = 0;
        
        self.publishButton.center = CGPointMake(barWidth * 0.5, barHeight * 0.2);
    }
    NSInteger buttonIndex = 0;

    for (UIView *view in self.subviews) {

        NSString *viewClass = NSStringFromClass([view class]);
        if (![viewClass isEqualToString:@"UITabBarButton"]) continue;

        CGFloat buttonX = buttonIndex * buttonW;
        if (buttonIndex >= 2) { // 右边2个按钮
            buttonX += buttonW;
        }

        view.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        NSLog(@"butw=%f h=%f", buttonW, buttonH);
//        view.frame = CGRectMake(buttonX, buttonY+17, 49, 49);
        
        buttonIndex ++;
    }
}

//-(void)layoutSubviews{
//
//
//    NSLog(@"%s",__func__);
//
//    [super layoutSubviews];
//
//    CGFloat barWidth = self.frame.size.width;
//    CGFloat barHeight = self.frame.size.height;
//
//    CGFloat buttonW = barWidth / ButtonNumber;
//    CGFloat buttonH = barHeight - 2;
//    CGFloat buttonY = 1;
//
//    NSInteger buttonIndex = 0;
////    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barWidth, 1)];
////    view.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
////    [self addSubview:view];
//    self.publishButton.center = CGPointMake(barWidth * 0.5, barHeight * 0.3);
//    NSLog(@"vlaue info = %@",self.subviews);
//
//    for (UIView *view in self.subviews) {
//
//        NSString *viewClass = NSStringFromClass([view class]);
//        if (![viewClass isEqualToString:@"UITabBarButton"]) continue;
//
////        CGFloat buttonX = buttonIndex * buttonW;
////        if (buttonIndex >= 2) { // 右边2个按钮
////            buttonX += buttonW;
////        }
////
////        view.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
//
//        if (buttonIndex == 2) {
//            UIButton *btns = (UIButton *)view;
//            UITabBarItem *btn = (UITabBarItem *)view;
//            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-8, view.frame.size.width, view.frame.size.height);
////            [btns addTarget:self action:@selector(index) forControlEvents:UIControlEventTouchUpInside];
////            btn.title.contentEdgeInsets = UIEdgeInsetsMake(10, 10, -10, -10);
////            [btn setTitleEdgeInsets:UIEdgeInsetsMake(10, 10, -10, -10)];
////            btns.titleEdgeInsets = UIEdgeInsetsMake(10, 10, -10, -10);
////            btn.
////            DWPublishButton *button = [DWPublishButton publishButton];
////            [self addSubview:button];
////            self.publishButton = button;
//
////            UIButton *button = [[UIButton alloc]init];
////            button.frame = view.frame;
////            [button setImage:[UIImage imageNamed:@"home_icon_game"] forState:UIControlStateNormal];
////            [button setTitle:@"游戏大厅" forState:UIControlStateNormal];
////
////            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
////            button.titleLabel.font = [UIFont systemFontOfSize:9.5];
////
////            [button sizeToFit];
////            [view removeFromSuperview];
////            [self addSubview:button];
//
//
//        }
//
//        buttonIndex ++;
//
//
//    }
//}


@end
