//
//  MyGameHallHeaderView.h
//  Game789
//
//  Created by Maiyou on 2020/9/28.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHPageControl.h"
#import "SDCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameHallHeaderView : UIView <XHPageControlDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) XHPageControl *pageControl;
@property (nonatomic, strong) SDCycleScrollView * cycleScrollView;

@end

NS_ASSUME_NONNULL_END
