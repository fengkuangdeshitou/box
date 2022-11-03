//
//  MFRefreshAutoNormalFooter.m
//  MFLive_iOS
//
//  Created by 邓建 on 2019/5/4.
//  Copyright © 2019 邓建. All rights reserved.
//

#import "MFRefreshAutoNormalFooter.h"

@implementation MFRefreshAutoNormalFooter

- (void)prepare
{
    [super prepare];
    
    //GIF数据
    NSArray * idleImages = [YYToolModel gifChangeToImages:@"load1"];
    NSArray * refreshingImages = idleImages;
    //普通状态
    [self setImages:idleImages duration:1.5 forState:MJRefreshStateIdle];
    //即将刷新状态
    [self setImages:refreshingImages duration:1.5 forState:MJRefreshStatePulling];
    //正在刷新状态
    [self setImages:refreshingImages duration:1.5 forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews {
    [super placeSubviews];
    //隐藏状态显示文字
    self.stateLabel.hidden = YES;
}


@end
