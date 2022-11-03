//
//  UIView+QNFrameAdditions.h
//
//  Created by 米饭 on 14-3-23.
//  Copyright (c) 2013年 Manny_at_futu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameAdditions)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

-(BOOL)containsSubView:(UIView *)subView;
-(BOOL)containsSubViewOfClassType:(Class)objclass;

@end
