//
//  MyNewMaterialInfo.h
//  Game789
//
//  Created by Maiyou on 2019/2/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyNewMaterialInfo : NSObject

+ (instancetype) shareInstance;

//线上更新
@property (nonatomic, assign) BOOL isShowMaterial;
//本地更新
@property (nonatomic, assign) BOOL isNewShowMaterial;

@property (nonatomic, copy) NSString * materialOldCode;

@property (nonatomic, copy) NSString * zipPath;

@property (nonatomic, copy) NSString * filePath;

@property (nonatomic, copy) NSString * fileName;

@property (nonatomic, copy) NSString * font_press_color;

@property (nonatomic, copy) NSString * font_normal_color;

@property (nonatomic, copy) NSString * home_top_bg;

@property (nonatomic, copy) NSString * home_bottom_bg;

@property (nonatomic, copy) NSString * home_menu_normal_icon1;

@property (nonatomic, copy) NSString * home_menu_normal_icon2;

@property (nonatomic, copy) NSString * home_menu_normal_icon3;

@property (nonatomic, copy) NSString * home_menu_normal_icon4;

@property (nonatomic, copy) NSString * home_menu_normal_icon5;

@property (nonatomic, copy) NSString * home_menu_selected_icon1;

@property (nonatomic, copy) NSString * home_menu_selected_icon2;

@property (nonatomic, copy) NSString * home_menu_selected_icon3;

@property (nonatomic, copy) NSString * home_menu_selected_icon4;

@property (nonatomic, copy) NSString * home_menu_selected_icon5;

@property (nonatomic, copy) NSString * home_menu_center_icon;

@property (nonatomic, copy) NSString * home_func_icon1;

@property (nonatomic, copy) NSString * home_func_icon2;

@property (nonatomic, copy) NSString * home_func_icon3;

@property (nonatomic, copy) NSString * home_func_icon4;

@property (nonatomic, copy) NSString * home_func_gb_image;

- (NSString *)sourceFilePath:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
