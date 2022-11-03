//
//  HGRecommendGamesCell.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHotGamesListCell : WSLRollViewCell

@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UIView *backView2;
@property (weak, nonatomic) IBOutlet UIView *backView3;

@property (nonatomic, strong) NSArray * dataArray;
/** 专题标题 */
@property (nonatomic, copy) NSString *showTitle;
/** ab测试 1 默认 2 新需求   */
@property (nonatomic, assign) NSInteger ab_test_index_swiper;
/** 是否为985   */
@property (nonatomic, assign) BOOL is_985;

@end

NS_ASSUME_NONNULL_END
