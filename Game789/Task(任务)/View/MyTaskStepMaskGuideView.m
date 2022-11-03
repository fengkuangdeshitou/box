//
//  MyTaskStepMaskGuideView.m
//  Game789
//
//  Created by Maiyou001 on 2022/3/3.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyTaskStepMaskGuideView.h"

@implementation MyTaskStepMaskGuideView

- (void)configInterFace
{
    //引导二
    UIView * guideView1 = [[UIView alloc] init];
    [self addSubview:guideView1];

    UIImageView * imageView4 = [[UIImageView alloc] init];
    imageView4.image = [UIImage imageNamed:@"task_guide_page1"];
    [guideView1 addSubview:imageView4];

    UIView * view1 = self.views[0];
    imageView4.frame = CGRectMake(CGRectGetMinX(view1.frame) - 196.5, view1.y + view1.height / 2, 196.5, 116);
    guideView1.wk_stepTag = self.views[0].wk_stepTag;
    
    //引导二
    UIView * guideView = [[UIView alloc] init];
    [self addSubview:guideView];
    
    UIImageView * imageView1 = [[UIImageView alloc] init];
    imageView1.image = [UIImage imageNamed:@"task_guide_page2"];
    [guideView addSubview:imageView1];
    
    UIImageView * imageView5 = [[UIImageView alloc] init];
    imageView5.image = [UIImage imageNamed:@"home_guide_page_btn"];
    [guideView addSubview:imageView5];
    
    UIView * view = self.views.lastObject;
    imageView1.frame = CGRectMake(CGRectGetMaxX(view.frame) - 38, view.y + view.height / 2, 221, 118);
    imageView5.frame = CGRectMake((kScreenW - 161.5) / 2, CGRectGetMaxY(imageView1.frame) + 30, 161.5, 70);
    guideView.wk_stepTag = self.views.lastObject.wk_stepTag;//必备   设置其需要与的view同时出现的steptag
    
//
//    //引导二
//    UIView * guideView2 = [[UIView alloc] init];
//    [self addSubview:guideView2];
//
//    UIImageView * imageView7 = [[UIImageView alloc] init];
//    imageView7.image = [UIImage imageNamed:@"home_guide_page_point_right"];
//    [guideView2 addSubview:imageView7];
//
//    UIImageView * imageView8 = [[UIImageView alloc] init];
//    imageView8.image = [UIImage imageNamed:@"home_guide_page_text3"];
//    [guideView2 addSubview:imageView8];
//
//    UIImageView * imageView9 = [[UIImageView alloc] init];
//    imageView9.image = [UIImage imageNamed:@"home_guide_page_btn"];
//    [guideView2 addSubview:imageView9];
//
////    guideView1.frame = CGRectMake(CGRectGetMidX(self.views.lastObject.frame) - 212 / 2, CGRectGetMinY(self.views.lastObject.frame) - 90 - 8, 212, 90);
//    UIView * view2 = self.views.lastObject;
//    imageView7.frame = CGRectMake(view2.x - 10 - 83, view2.y + view2.height / 2, 83, 59);
//    imageView8.frame = CGRectMake((kScreenW - 296.5) / 2, CGRectGetMaxY(imageView7.frame) + 10, 296.5, 61);
//    imageView9.frame = CGRectMake((kScreenW - 161.5) / 2, CGRectGetMaxY(imageView8.frame) + 40, 161.5, 70);
//    guideView2.wk_stepTag = self.views.lastObject.wk_stepTag;
}

@end
