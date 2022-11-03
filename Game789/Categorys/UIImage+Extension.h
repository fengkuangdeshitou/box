//
//  UIImage+Extension.h
//  jinsuibao
//
//  Created by QNMac on 16/3/27.
//  Copyright © 2016年 yiqiniu. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIImage (Extension)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)createImageWithColor: (UIColor *) color;
+ (UIImage *)imageWithView:(UIView *)view;
+ (UIImage *)imageWithColorForBg:(UIColor *)color;


/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
+ (UIImage *)resizableImage:(NSString *)name;

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
/**
 *根据给定的size的宽高比自动缩放原图片、自动判断截取位置,进行图片截取
 * UIImage image 原始的图片
 * CGSize size 截取图片的size
 */
- (UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size;

//- (UIImage *)toBlurredIUIimage;

- (UIImage *)drawRoundedRectImage:(CGFloat)cornerRadius width:(CGFloat)width height:(CGFloat)height;

- (UIImage *)drawCircleImage;



@end
