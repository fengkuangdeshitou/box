//
//  MyNewMaterialInfo.m
//  Game789
//
//  Created by Maiyou on 2019/2/21.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyNewMaterialInfo.h"

@implementation MyNewMaterialInfo

static MyNewMaterialInfo* _instance = nil;
+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[MyNewMaterialInfo alloc] init] ;
    });
    return _instance ;
}

- (NSString *)zipPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return [documentPath stringByAppendingPathComponent:@"ios_material"];
}

- (NSString *)filePath
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return [[NSBundle mainBundle] pathForResource:@"ios_material.bundle" ofType:nil];
//    return [documentPath stringByAppendingPathComponent:@"ios_material/ios_material.bundle"];
}

- (NSString *)fileName
{
    return @"ios_material";
}

- (NSString *)materialOldCode
{
    NSString * code = [YYToolModel getUserdefultforKey:@"materialOldCode"];
    if (code == NULL) {
        code = @"0";
    }
    return code;
}

- (NSString *)home_top_bg
{
    return [self sourceFilePath:@"home_top_bg"];
}

- (NSString *)home_bottom_bg
{
    return [self sourceFilePath:@"home_bottom_bg"];
}

- (NSString *)home_menu_normal_icon1
{
    return [self sourceFilePath:@"home_menu_normal_icon1"];
}

- (NSString *)home_menu_normal_icon2
{
    return [self sourceFilePath:@"home_menu_normal_icon2"];
}

- (NSString *)home_menu_normal_icon3
{
    return [self sourceFilePath:@"home_menu_normal_icon3"];
}

- (NSString *)home_menu_normal_icon4
{
    return [self sourceFilePath:@"home_menu_normal_icon4"];
}

- (NSString *)home_menu_normal_icon5
{
    return [self sourceFilePath:@"home_menu_normal_icon5"];
}

- (NSString *)home_menu_selected_icon1
{
    return [self sourceFilePath:@"home_menu_selected_icon1"];
}

- (NSString *)home_menu_selected_icon2
{
    return [self sourceFilePath:@"home_menu_selected_icon2"];
}

- (NSString *)home_menu_selected_icon3
{
    return [self sourceFilePath:@"home_menu_selected_icon3"];
}

- (NSString *)home_menu_selected_icon4
{
    return [self sourceFilePath:@"home_menu_selected_icon4"];
}

- (NSString *)home_menu_selected_icon5
{
    return [self sourceFilePath:@"home_menu_selected_icon5"];
}

- (NSString *)home_menu_center_icon
{
    return [self sourceFilePath:@"home_menu_center_icon"];
}

- (NSString *)home_func_icon1
{
    return [self sourceFilePath:@"home_func_icon1"];
}

- (NSString *)home_func_icon2
{
    return [self sourceFilePath:@"home_func_icon2"];
}

- (NSString *)home_func_icon3
{
    return [self sourceFilePath:@"home_func_icon3"];
}

- (NSString *)home_func_icon4
{
    return [self sourceFilePath:@"home_func_icon4"];
}

- (NSString *)home_func_gb_image
{
    return [self sourceFilePath:@"home_func_gb_image"];
}

- (NSString *)sourceFilePath:(NSString *)imageName
{
    NSBundle *bundle = [NSBundle bundleWithPath:self.filePath];
    NSString *img_path = [bundle pathForResource:imageName ofType:@"png"];
    return img_path;
}

@end
