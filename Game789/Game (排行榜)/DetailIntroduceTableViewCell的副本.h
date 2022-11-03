//
//  DetailIntroduceTableViewCell.h
//  Game789
//
//  Created by xinpenghui on 2017/9/12.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"



@protocol DetailIntroduceTableViewCellDelegate <NSObject>

- (void)expandPress:(float)hight;
- (void)changeTabBtn:(NSInteger)index withHeight:(CGFloat)height;

// 礼包点击
- (void)giftGetPress:(NSInteger)index;
- (void)giftViewPress:(NSInteger)index;

- (void)DetailIntroduceCallbackOfClickView:(NSInteger)index;
@end

@interface DetailIntroduceTableViewCell : BaseTableViewCell

@property (weak, nonatomic) id<DetailIntroduceTableViewCellDelegate>delegate;
@property (strong, nonatomic) UIViewController *currentVC;

@end
