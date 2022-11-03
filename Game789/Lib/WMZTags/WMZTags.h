//
//  WMZTags.h
//  WMZTags
//
//  Created by wmz on 2019/5/23.
//  Copyright © 2019年 wmz. All rights reserved.
//

#import "WMZTagParam.h"
#import "WMZTagBtn.h"
NS_ASSUME_NONNULL_BEGIN

@protocol WMZTagDelegate <NSObject>
//用于外部刷新
- (void)updateTagsFrame:(NSInteger)tag Height:(CGFloat)height;
@end

@interface WMZTags : UIView

//传入的属性
@property(nonatomic,strong)WMZTagParam *param;

@property(nonatomic,weak) id<WMZTagDelegate>delegate;

@property (nonatomic, assign) CGFloat tagViewHeight;

@property (nonatomic, strong) NSArray * imagesArray;

/**
 *  调用方法
 *
 */
- (instancetype)initConfigureWithModel:(WMZTagParam *)param withView:(UIView*)parentView;

/**
 *  更新方法
 *
 */
- (void)updateUI;

@end

NS_ASSUME_NONNULL_END
