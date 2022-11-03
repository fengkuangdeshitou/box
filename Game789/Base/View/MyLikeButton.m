//
//  MyLikeButton.m
//  Game789
//
//  Created by Maiyou001 on 2022/6/30.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyLikeButton.h"

@interface MyLikeButton ()

@property (strong, nonatomic) CAKeyframeAnimation *keyAnimaion;

@end

@implementation MyLikeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)sender
{
    if (self.animateStyle == 1)
    {
        [self likeButtonAnimationWithMark:1];
    }
    
    if (self.animateStyle == 2)
    {
        [self buttonAnimationWithZoom];
    }
    
    if (self.animateStyle != 0)
    {
        [self feedbackGenerator];
    }
}

- (void)buttonAnimationWithZoom
{
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{

            self.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{

            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{

            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

// 点赞按钮的抖动动画 1:展示动画 2:移除动画
- (void)likeButtonAnimationWithMark:(NSInteger)mark {
    if (mark == 1) {
        // 创建动画
        if (!_keyAnimaion) {
            _keyAnimaion = [CAKeyframeAnimation animation];
            // 要激活属性的键路径
            _keyAnimaion.keyPath = @"transform.rotation";
            // 度数转弧度
            _keyAnimaion.values = @[@(-10 / 180.0 * M_PI), @(10 /180.0 * M_PI), @(-10/ 180.0 * M_PI)];
            // 结束时是否移除动画
            _keyAnimaion.removedOnCompletion = YES;
            // 定时填充模式
            _keyAnimaion.fillMode = kCAFillModeForwards;
            // 总时间
            _keyAnimaion.duration = 0.3;
            // 重复次数
            _keyAnimaion.repeatCount = 2;
        }
        [self.imageView.layer addAnimation:_keyAnimaion forKey:nil];
    } else {
        [self.imageView.layer removeAllAnimations];
    }
}

- (void)feedbackGenerator
{
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator prepare];
    [generator impactOccurred];
}

@end
