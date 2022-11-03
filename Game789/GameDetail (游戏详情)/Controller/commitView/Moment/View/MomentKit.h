//
//  MomentKit.h
//  MomentKit
//
//  Created by LEA on 2017/12/13.
//  Copyright © 2017年 LEA. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Geometry.h"
#import "Utility.h"
#import "MLLabelUtil.h"
#import "MomentKit.h"

#import "MLTextAttachment.h"
#import "MLLinkLabel.h"
#import "MLExpressionManager.h"
#import "NSAttributedString+MLExpression.h"

// 屏幕物理尺寸宽度
#define k_screen_width      [UIScreen mainScreen].bounds.size.width
// 屏幕物理尺寸高度
#define k_screen_height     [UIScreen mainScreen].bounds.size.height
// 状态栏高度
#define k_status_height     [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define k_nav_height        self.navigationController.navigationBar.height
// 顶部整体高度
#define k_top_height        (k_status_height + k_nav_height)


// 头像视图的宽、高
#define kFaceWidth          39
// 操作按钮的宽度
#define kOperateBtnWidth    30
// 操作视图的高度
#define kOperateHeight      38
// 操作视图的高度
#define kOperateWidth       200
// 名字视图高度
#define kNameLabelH         20
// 时间视图高度
#define kTimeLabelH         15
// 顶部和底部的留白
#define kBlank              15
// 右侧留白
#define kRightMargin        15
// 正文字体
#define kTextFont           [UIFont systemFontOfSize:14.0]
// 内容视图宽度
#define kTextWidth          (k_screen_width-30-30)
// 评论字体
#define kComTextFont        [UIFont systemFontOfSize:13.0]
// 评论高亮字体
#define kComHLTextFont      [UIFont systemFontOfSize:13.0]
// 主色调高亮颜色
#define kHLTextColor        [UIColor colorWithHexString:@"#FFC000"]
// 正文高亮颜色
#define kLinkTextColor      [UIColor colorWithHexString:@"#666666"]
// 按住背景颜色
#define kHLBgColor          [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]
// 图片间距
#define kImagePadding       10
// 图片宽度
#define kImageWidth         75
// 全文/收起按钮高度
#define kMoreLabHeight      20
// 全文/收起按钮宽度
#define kMoreLabWidth       60
// 视图之间的间距
#define kPaddingValue       5
// 评论赞视图气泡的尖尖高度
#define kArrowHeight        5
