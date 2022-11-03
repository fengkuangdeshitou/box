//
//  HGMMImageListView.h
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//
//  朋友圈动态 >> 小图区视图
//

#import <UIKit/UIKit.h>
#import "Moment.h"

@interface HGMMImageListView : UIView

// 动态
@property (nonatomic,strong)NSDictionary *momentDic ;
@property (nonatomic, assign) BOOL  isAll;

@end

//### 单个小图显示视图
@interface HGMMImageView : UIImageView

// 点击小图
@property (nonatomic, copy) void (^tapSmallView)(HGMMImageView *imageView);

@end

