//
//  BaseViewController.m
//  CodeDemo
//
//  Created by wangrui on 2017/5/16.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRNavigationBar

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "WRNavigationBar.h"
#import "HGLoadDataFooterView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface BaseViewController ()
@end

@implementation BaseViewController

- (BOOL)prefersStatusBarHidden
{
    return NO;//隐藏为YES，显示为NO
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (!self.hiddenNavBar) {
        [self setupNavBar];
    }

    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
        [UITableView appearance].prefetchingEnabled = false;
    } else {
        // Fallback on earlier versions
    }
    
    self.pageNumber = 1;
    self.pageNumbers = 1;
}

- (void)setupNavBar
{
    [self.view addSubview:self.navBar];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // 设置自定义导航栏背景图片
    self.navBar.backgroundColor = [UIColor whiteColor];
    // 设置自定义导航栏标题颜色
    self.navBar.titleLabelColor = [UIColor blackColor];

    if (self.navigationController.childViewControllers.count != 1) {

        [self.navBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back"]];

    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (WRCustomNavigationBar *)navBar
{
    if (_navBar == nil) {
        _navBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _navBar;
}

- (UINavigationBar *)navBar1
{
    if (_navBar1 == nil) {
        _navBar1 = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    }
    return _navBar1;
}

- (UINavigationItem *)navItem
{
    if (_navItem == nil) {
        _navItem = [UINavigationItem new];
    }
    return _navItem;
}

- (CGSize)getTextSize:(NSString *)text fontSize:(float)size width:(CGFloat)width{
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:size];
    titleLabel.text = text;
    titleLabel.numberOfLines = 0;//多行显示，计算高度
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return titleSize;
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (NSString *)getTimeData
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    // 毫秒值转化为秒
    NSDate* date = [NSDate date];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self initNavigationBarTransparent];
}

- (void) initNavigationBarTransparent {
    [self setNavigationBarTitleColor:ColorWhite];
    [self setNavigationBarBackgroundImage:[UIImage new]];
    [self setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNavigationBarShadowImage:[UIImage new]];
//    [self initLeftBarButton:@"icon_titlebar_whiteback"];
    [self setBackgroundColor:ColorBlack];
}


- (void) setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

- (void) setTranslucentCover {
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.alpha = 1;
    [self.view addSubview:visualEffectView];
}

- (void) initLeftBarButton:(NSString *)imageName {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    leftButton.tintColor = ColorWhite;
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void) setStatusBarHidden:(BOOL) hidden {
    [[UIApplication sharedApplication] setStatusBarHidden:hidden];
}

- (void) setStatusBarBackgroundColor:(UIColor *)color {
//    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
//        statusBar.backgroundColor = color;
//    }
}

- (void) setNavigationBarTitle:(NSString *)title {
    self.navigationItem.title = title;
}

- (void) setNavigationBarTitleColor:(UIColor *)color {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color}];
}

- (void) setNavigationBarBackgroundColor:(UIColor *)color {
    [self.navigationController.navigationBar setBackgroundColor:color];
}

- (void) setNavigationBarBackgroundImage:(UIImage *)image {
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void) setStatusBarStyle:(UIStatusBarStyle)style {
    [UIApplication sharedApplication].statusBarStyle = style;
}

- (void) setNavigationBarShadowImage:(UIImage *)image {
    [self.navigationController.navigationBar setShadowImage:image];
}

- (void) dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat) navagationBarHeight {
    return self.navigationController.navigationBar.frame.size.height;
}

- (void) setLeftButton:(NSString *)imageName {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(15.0f, StatusBarHeight + 11, 20.0f, 20.0f);
    [leftButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view bringSubviewToFront:leftButton];
    });
}

- (void) setBackgroundImage:(NSString *)imageName {
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    background.clipsToBounds = YES;
    background.contentMode = UIViewContentModeScaleAspectFill;
    background.image = [UIImage imageNamed:imageName];
    [self.view addSubview:background];
}

- (UIView *)creatFooterView
{
    HGLoadDataFooterView * footerView = [[HGLoadDataFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 66)];
    footerView.backgroundColor = BackColor;
    footerView.showText.text = @"别撩啦！已经到底啦^_−☆".localized;
    return footerView;
}

- (void)setFooterViewState:(UITableView *)tableView Data:(NSDictionary *)dic FooterView:(UIView *)headerView
{
    if ([dic[@"more"] integerValue] == 0)
    {
        [tableView.mj_footer endRefreshingWithNoMoreData];
        tableView.mj_footer.state = MJRefreshStateNoMoreData;
        tableView.tableFooterView = [dic[@"total"] integerValue] > 6 ? headerView : [UIView new];
    }
    else
    {
        tableView.tableFooterView = [UIView new];
    }
}

@end
