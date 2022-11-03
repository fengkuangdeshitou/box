//
//  FavoriteView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteView : UIView

@property (nonatomic, strong) UIImageView      *favoriteBefore;
@property (nonatomic, strong) UIImageView      *favoriteAfter;
@property (nonatomic, assign) BOOL isLike;
// 点击事件
@property (nonatomic, copy) void(^FavoriteAction)(BOOL isLike);


- (void)resetView;

@end
