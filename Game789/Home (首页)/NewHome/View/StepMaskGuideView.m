//
//  StepMaskGuideView.m
//  WKStepMaskViewDemo
//
//  Created by wangkun on 2018/3/26.
//  Copyright © 2018年 wangkun. All rights reserved.
//

#import "StepMaskGuideView.h"

@interface StepMaskGuideView ()

@end

@implementation StepMaskGuideView

- (void)configInterFace
{
    //引导一
    UIView * guideView = [[UIView alloc] init];
    [self addSubview:guideView];
    
    UIImageView * imageView1 = [[UIImageView alloc] init];
    imageView1.image = [UIImage imageNamed:@"home_guide_page_point_left"];
    [guideView addSubview:imageView1];
    
    UIImageView * imageView2 = [[UIImageView alloc] init];
    imageView2.image = [UIImage imageNamed:@"home_guide_page_text1"];
    [guideView addSubview:imageView2];
    
    UIImageView * imageView5 = [[UIImageView alloc] init];
    imageView5.image = [UIImage imageNamed:@"home_guide_page_btn"];
    [guideView addSubview:imageView5];
    
//    guideView.frame = CGRectMake(CGRectGetMidX(self.views.firstObject.frame) - 50, CGRectGetMinY(self.views.firstObject.frame) - 90 - 8, 212, 90);
    UIView * view = self.views.firstObject;
    imageView1.frame = CGRectMake(CGRectGetMaxX(view.frame) + 10, view.y + view.height / 2, 83, 59);
    imageView2.frame = CGRectMake((kScreenW - 321.5) / 2, CGRectGetMaxY(imageView1.frame) + 10, 321.5, 25.5);
    imageView5.frame = CGRectMake((kScreenW - 161.5) / 2, CGRectGetMaxY(imageView2.frame) + 40, 161.5, 70);
    guideView.wk_stepTag = self.views.firstObject.wk_stepTag;//必备   设置其需要与的view同时出现的steptag
    
    
    //引导二
    UIView * guideView1 = [[UIView alloc] init];
    [self addSubview:guideView1];
    
    UIImageView * imageView4 = [[UIImageView alloc] init];
    imageView4.image = [UIImage imageNamed:@"home_guide_page_point_left"];
    [guideView1 addSubview:imageView4];
    
    UIImageView * imageView3 = [[UIImageView alloc] init];
    imageView3.image = [UIImage imageNamed:@"home_guide_page_text2"];
    [guideView1 addSubview:imageView3];
    
    UIImageView * imageView6 = [[UIImageView alloc] init];
    imageView6.image = [UIImage imageNamed:@"home_guide_page_btn"];
    [guideView1 addSubview:imageView6];
    
//    guideView1.frame = CGRectMake(CGRectGetMidX(self.views.lastObject.frame) - 212 / 2, CGRectGetMinY(self.views.lastObject.frame) - 90 - 8, 212, 90);
    UIView * view1 = self.views[1];
    imageView4.frame = CGRectMake(CGRectGetMaxX(view1.frame) + 10, view1.y + view1.height / 2, 83, 59);
    imageView3.frame = CGRectMake((kScreenW - 231) / 2, CGRectGetMaxY(imageView4.frame) + 10, 231, 63.5);
    imageView6.frame = CGRectMake((kScreenW - 161.5) / 2, CGRectGetMaxY(imageView3.frame) + 40, 161.5, 70);
    guideView1.wk_stepTag = self.views[1].wk_stepTag;
    
    //引导三
    UIView * guideView2 = [[UIView alloc] init];
    [self addSubview:guideView2];
    
    UIImageView * imageView7 = [[UIImageView alloc] init];
    imageView7.image = [UIImage imageNamed:@"home_guide_page_point_right"];
    [guideView2 addSubview:imageView7];
    
    UIImageView * imageView8 = [[UIImageView alloc] init];
    imageView8.image = [UIImage imageNamed:@"home_guide_page_text3"];
    [guideView2 addSubview:imageView8];
    
    UIImageView * imageView9 = [[UIImageView alloc] init];
    imageView9.image = [UIImage imageNamed:@"home_guide_page_btn"];
    [guideView2 addSubview:imageView9];
    
//    guideView1.frame = CGRectMake(CGRectGetMidX(self.views.lastObject.frame) - 212 / 2, CGRectGetMinY(self.views.lastObject.frame) - 90 - 8, 212, 90);
    UIView * view2 = self.views.lastObject;
    imageView7.frame = CGRectMake(view2.x - 10 - 83, view2.y + view2.height / 2, 83, 59);
    imageView8.frame = CGRectMake((kScreenW - 274.5) / 2, CGRectGetMaxY(imageView7.frame) + 10, 274.5, 36.5);
    imageView9.frame = CGRectMake((kScreenW - 161.5) / 2, CGRectGetMaxY(imageView8.frame) + 40, 161.5, 70);
    guideView2.wk_stepTag = self.views.lastObject.wk_stepTag;
}



@end
