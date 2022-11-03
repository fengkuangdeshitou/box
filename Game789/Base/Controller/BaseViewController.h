//
//  BaseViewController.h
//  CodeDemo
//
//  Created by wangrui on 2017/5/16.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRNavigationBar

#import <UIKit/UIKit.h>
#import "macro.h"
#import "BaseTableViewCell.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "UIColor+HexString.h"
#import "Masonry.h"
#import "GameTextField.h"
#import "WRCustomNavigationBar.h"

typedef void (^RequestData)(BOOL isSuccess);

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL hiddenNavBar;
@property (nonatomic, strong) WRCustomNavigationBar *navBar;

//@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UINavigationBar *navBar1;

@property (nonatomic, strong) UINavigationItem *navItem;

@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) NSInteger pageNumbers;

@property (nonatomic, copy) RequestData requestData;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasNextPage;


- (CGSize)getTextSize:(NSString *)text fontSize:(float)size width:(CGFloat)width;

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString;

- (NSString *)getTimeData;
- (void)setupNavBar;

//以下方法小视频需要
- (void) initNavigationBarTransparent;

- (void) setBackgroundColor:(UIColor *)color;

- (void) setTranslucentCover;

- (void) initLeftBarButton:(NSString *)imageName;

- (void) setStatusBarHidden:(BOOL) hidden;

- (void) setStatusBarBackgroundColor:(UIColor *)color;

- (void) setNavigationBarTitle:(NSString *)title;

- (void) setNavigationBarTitleColor:(UIColor *)color;

- (void) setNavigationBarBackgroundColor:(UIColor *)color;

- (void) setNavigationBarBackgroundImage:(UIImage *)image;

- (void) setStatusBarStyle:(UIStatusBarStyle)style;

- (void) setNavigationBarShadowImage:(UIImage *)image;

- (void) back;

- (CGFloat) navagationBarHeight;

- (void) setLeftButton:(NSString *)imageName;

- (void) setBackgroundImage:(NSString *)imageName;

- (UIView *)creatFooterView;

- (void)setFooterViewState:(UITableView *)tableView Data:(NSDictionary *)dic FooterView:(UIView *)headerView;

@end
