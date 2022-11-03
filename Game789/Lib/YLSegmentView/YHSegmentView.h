//
//  YHSegmentView.h
//  WorkBench
//
//  Created by wanyehua on 2017/10/26.
//  Copyright © 2017年 com.bonc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YHSegementStyle ) {
    YHSegementStyleIndicate,   /**<< 指示杆类型 <<*/
    YHSegementStyleSpace      /**<< 间隔类型 <<*/
};

typedef NS_ENUM(NSUInteger, YHSegementIndicateStyle) {
    YHSegementIndicateStyleDefault,    /**<< 指示杆和按钮的标题齐平 <<*/
    YHSegementIndicateStyleFlush,      /**<< 指示杆和按钮宽度齐平 <<*/
    YHSegementIndicateStyleDefine      /**<< 指示杆自定义宽度 <<*/
};

typedef void(^yh_indexBlock)(NSInteger index);

@interface YHSegmentView : UIView
/** segmentView头部标题视图 */
@property (nonatomic, strong) UIScrollView *segmentTitleView;
/** segmentView控制器视图 */
@property (nonatomic, strong) UIScrollView *segmentContentView;
/** 标题Btn数组 */
@property (nonatomic, strong) NSArray *BtnArr;
/** 底部分割线 */
@property (nonatomic, strong) UIView *bottomLineView;
/** 分割线View */
@property (nonatomic, strong) UIView *spaceView;
/** 指示杆类型 */
@property (nonatomic, assign) YHSegementIndicateStyle yh_indicateStyle;
/** 背景颜色 */
@property (nonatomic, strong) UIColor *yh_bgColor;
/** 默认字体颜色 */
@property (nonatomic, strong) UIColor *yh_titleNormalColor;
/** 选中字体颜色 */
@property (nonatomic, strong) UIColor *yh_titleSelectedColor;
/** 选中指示器颜色 */
@property (nonatomic, strong) UIColor *yh_segmentTintColor;
/** 默认选中下标 */
@property (nonatomic, assign) NSInteger yh_defaultSelectIndex;
///** 默认字体大小 */
//@property (nonatomic, assign) CGFloat yh_titleNormalFont;
///** 默认选中下标 */
//@property (nonatomic, assign) CGFloat yh_titleSelectedFont;
/** 间隔类型按钮之间的间距 */
@property (nonatomic, assign) CGFloat yh_segmentBtnSpace;
/** 指示器离底部的间距 */
@property (nonatomic, assign) CGFloat yh_segmentIndicateBottom;
/** 指示器的高度 */
@property (nonatomic, assign) CGFloat yh_segmentIndicateHeight;
/** 指示器的自定义宽度，只有设置为自定义宽度有用 */
@property (nonatomic, assign) CGFloat yh_segmentIndicateWidth;

/**
 通过给定frame，控住器数组，标题数组，segmentView风格,返回segmentView;

 @param frame frame
 @param viewControllersArr 控住器数组
 @param titleArr 标题数组
 @param style 风格样式
 @param parentViewController 父控制器
 @param indexBlock 返回点击索引
 @return segmentView
 */
- (instancetype)initWithFrame:(CGRect)frame ViewControllersArr:(NSArray *)viewControllersArr TitleArr:(NSArray *)titleArr TitleNormalSize:(CGFloat)titleNormalSize TitleSelectedSize:(CGFloat)titleSelectedSize SegmentStyle:(YHSegementStyle)style ParentViewController:(UIViewController *)parentViewController ReturnIndexBlock: (yh_indexBlock)indexBlock;

/**
  默认选中item的下标
 */
- (void)setSelectedItemAtIndex:(NSInteger)index;
/**
  根据下标改变标题的方法
 */
- (void)changeTitleWithIndex:(NSInteger)index title:(NSString *)title;
@end
