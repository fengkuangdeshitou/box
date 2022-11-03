//
//  MFRefreshNormalHeader.m
//  MFLive_iOS
//
//  Created by 邓建 on 2019/5/4.
//  Copyright © 2019 邓建. All rights reserved.
//

#import "MFRefreshNormalHeader.h"

@interface MFRefreshNormalHeader()


@end


@implementation MFRefreshNormalHeader
/**
 *  初始化
 */
- (void)prepare
{
    [super prepare];
    
    //GIF数据
    NSArray * idleImages = [YYToolModel gifChangeToImages:@"load"];
    NSArray * refreshingImages = idleImages;
    //普通状态
    [self setImages:idleImages duration:1.5 forState:MJRefreshStateIdle];
    //即将刷新状态
    [self setImages:refreshingImages duration:1.5 forState:MJRefreshStatePulling];
    //正在刷新状态
    [self setImages:refreshingImages duration:1.5 forState:MJRefreshStateRefreshing];
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
    if(self.scrollView.mj_header.state == MJRefreshStatePulling) {
        [self feedbackGenerator];
    }
}

- (void)feedbackGenerator {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator prepare];
    [generator impactOccurred];
}

- (void)placeSubviews {
    [super placeSubviews];
    //隐藏状态显示文字
    self.stateLabel.hidden = YES;
    //隐藏更新时间文字
    self.lastUpdatedTimeLabel.hidden = YES;
}

@end
