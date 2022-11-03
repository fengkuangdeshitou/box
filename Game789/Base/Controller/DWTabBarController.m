//
//  DWTabBarController.m
//  DWCustomTabBarDemo
//
//  Created by Damon on 10/20/15.
//  Copyright © 2015 damonwong. All rights reserved.
//

#import "DWTabBarController.h"
#import "ActiveListViewController.h"
#import "MyNavigationController.h"
#import "MyUserViewController.h"
#import "LoginViewController.h"
#import "TransactionViewController.h"
#import "MyGameHallSubsectionController.h"
#import "MyDownGameVipNoticeView.h"
#import "UserHomePageController.h"
#import "AwemeListController.h"
#import "MyGameVideoSubsectionController.h"
#import "MyHomeSubsectionController.h"
#import "WelfareCentreViewController.h"
#import "MyCustomerServiceController.h"
#import "MyNewGameHallController.h"

#import "AppDelegate.h"
#import "DWTabBar.h"
#import "DeviceInfo.h"
#import "GetUnreadMgsApi.h"

@interface DWTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, strong) UIView * tabbarBgView;
@property (nonatomic, assign) BOOL isSelectedVideo;
@property (nonatomic, strong) NSDate * lastDate;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) CATransition  *transition;

@end

@implementation DWTabBarController

- (CATransition *)transition{
    if (!_transition) {
        _transition = [CATransition animation];
        _transition.duration = 0.25;
        _transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _transition.type = kCATransitionFade;
        _transition.subtype = kCATransitionFromTop;
    }
    return _transition;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewUIData:) name:@"GetMaterialUI" object:nil];
        
    self.delegate = self;
    
    // 设置子控制器
    [self setUpChildViewController];
    
    // 处理tabBar，使用自定义 tabBar 添加 发布按钮
//    [self setUpTabBar];
    
    [self setUpTabBarItemTextAttributes:NO];
    
    [self setUpTabBarBakcgroundColour];
    
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[UIImage imageWithColor:FontColorDE]];
    
//    if (@available(iOS 13.0, *)) {
//
//        UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
//
//        NSMutableDictionary<NSAttributedStringKey, id> *selectedAttributes = tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes.mutableCopy;
//        selectedAttributes[NSForegroundColorAttributeName] = FontColor28;
//        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes.copy;
//
//        NSMutableDictionary<NSAttributedStringKey, id> *normalAttributes = tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes.mutableCopy;
//        normalAttributes[NSForegroundColorAttributeName] = FontColor28;
//        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes.copy;
//
//        tabBarAppearance.backgroundImage = [UIImage imageWithColor:UIColor.whiteColor];
//        tabBarAppearance.shadowColor = FontColorDE;
//        self.tabBar.standardAppearance = tabBarAppearance;
//
//    } else {
//
//        NSMutableDictionary *selectedAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateSelected]];
//        selectedAttributes[NSForegroundColorAttributeName] = FontColor28;
//
//        [[UITabBarItem appearance] setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
//        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: FontColor28} forState:UIControlStateNormal];
//
//        self.tabBar.shadowImage = [UIImage imageWithColor:FontColorDE];
//        self.tabBar.backgroundImage = [UIImage imageWithColor:MAIN_COLOR];
//    }
}

- (void)viewDidLayoutSubviews
{
      [super viewDidLayoutSubviews];

      for (UITabBarItem * item in self.tabBar.items)
      {
          //根据需要调整水平和垂直的距离
          item.titlePositionAdjustment = UIOffsetMake(0, 0);
          //{top, left, bottom, right}根据需要调整上下左右距离
          item.imageInsets = UIEdgeInsetsMake(-3, 0, 0, 0);
      }
}

- (void)setUpTabBarBakcgroundColour
{
    // 设置一个自定义 View,大小等于 tabBar 的大小
    self.tabbarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.width, kTabbarHeight)];
    // 给自定义 View 设置颜色
    self.tabbarBgView.backgroundColor = [UIColor whiteColor];
    // 将自定义 View 添加到 tabBar 上
    [self.tabBar insertSubview:self.tabbarBgView atIndex:0];
}

- (NSArray *)getTitleArray:(BOOL)isVideo
{
    BOOL is_new_ui = [MyNewMaterialInfo shareInstance].isNewShowMaterial;
    //首页
    UIImage * tab_home_image_nor = !is_new_ui ? [UIImage imageNamed:@"tab_home_icon_nor"] : [UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_menu_normal_icon1];
    UIImage * tab_home_image_sel = is_new_ui == NO ? [UIImage imageNamed:@"tab_home_icon_sel"] : [UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_menu_selected_icon1];
    //游戏
    UIImage * tab_game_image_nor = isVideo ? [UIImage imageNamed:@"tab_game_icon_white"] : (!is_new_ui ? [UIImage imageNamed:@"tab_game_icon_nor"] : [UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_menu_normal_icon2]);
    UIImage * tab_game_image_sel = !is_new_ui ? [UIImage imageNamed:@"tab_game_icon_sel"] : [UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_menu_selected_icon2];
    //任务
    UIImage * tab_task_image_nor = isVideo ? [UIImage imageNamed:@"tab_task_icon_white"] : (!is_new_ui ? [UIImage imageNamed:@"tab_task_icon_nor"] : [UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_menu_normal_icon3]);
    UIImage * tab_task_image_sel = !is_new_ui ? [UIImage imageNamed:@"tab_task_icon_sel"] : [UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_menu_selected_icon3];
    //客服
    UIImage * tab_service_image_nor = isVideo ? [UIImage imageNamed:@"tab_service_icon_white"] : (!is_new_ui ? [UIImage imageNamed:@"tab_service_icon_nor"] : [UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_menu_normal_icon4]);
    UIImage * tab_service_image_sel = !is_new_ui ? [UIImage imageNamed:@"tab_service_icon_sel"] : [UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_menu_selected_icon4];
    //我的
    UIImage * tab_mine_image_nor = isVideo ? [UIImage imageNamed:@"tab_mine_icon_white"] : (!is_new_ui ? [UIImage imageNamed:@"tab_mine_icon_nor"] : [UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_menu_normal_icon5]);
    UIImage * tab_mine_image_sel = !is_new_ui ? [UIImage imageNamed:@"tab_mine_icon_sel"] : [UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_menu_selected_icon5];
    
    NSArray * array = @[@{@"title":@"首页".localized,
                          @"normalImage":tab_home_image_nor,
                          @"selectedImage":tab_home_image_sel,
                          @"vc":[[MyHomeSubsectionController alloc]init]},
                        @{@"title":@"发现".localized,
                          @"normalImage":tab_game_image_nor,
                          @"selectedImage":tab_game_image_sel,
                          @"vc":[[MyNewGameHallController alloc]init]},
                        @{@"title":@"福利中心".localized,
                          @"normalImage":tab_task_image_nor,
                          @"selectedImage":tab_task_image_sel,
                          @"vc":[[WelfareCentreViewController alloc]init]},
                        @{@"title":@"交易".localized,
                            @"normalImage":tab_service_image_nor,
                            @"selectedImage":tab_service_image_sel,
                            @"vc":[TransactionViewController new]},
                        @{@"title":@"我的".localized,
                          @"normalImage":tab_mine_image_nor,
                          @"selectedImage":tab_mine_image_sel,
                          @"vc":[[MyUserViewController alloc]init]}];
    return array;
}

- (void)tabbarItemColor:(BOOL)isVideo
{
//    if (isVideo)
//    {
//        self.tabbarBgView.backgroundColor = [UIColor colorWithHexString:@"#111111"];
//    }
//    else
//    {
        self.tabbarBgView.backgroundColor = [UIColor whiteColor];
//    }
    NSArray * array = [self getTitleArray:isVideo];
    for (int i = 0; i < self.viewControllers.count; i ++)
    {
        UIViewController * viewController = self.viewControllers[i];
        NSDictionary * dic = array[i];

        viewController.view.backgroundColor     = isVideo ? [UIColor blackColor] : [UIColor whiteColor];
        viewController.tabBarItem.title         = dic[@"title"];
        viewController.tabBarItem.image         = [dic[@"normalImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.selectedImage = [dic[@"selectedImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [self setUpTabBarItemTextAttributes:isVideo];
}

- (void)getNewUIData:(NSNotification *)noti
{
    BOOL isVideo = NO;
    if (noti.object)
    {
        NSNumber * num = noti.object;
        isVideo = num.boolValue;
    }
    
    if (isVideo)
    {
        [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#242426"]];
        [UITabBar appearance].translucent = NO;
    }
    else
    {
        [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
        [UITabBar appearance].translucent = NO;
    }
    
//    BOOL is_new_ui = [MyNewMaterialInfo shareInstance].isShowMaterial;
//    if (is_new_ui)
//    {
//        NSFileManager *fileMgr = [NSFileManager defaultManager];
//        BOOL bRet = [fileMgr fileExistsAtPath:[MyNewMaterialInfo shareInstance].home_bottom_bg];
//        if (bRet) {
//            [[UITabBar appearance] setBackgroundImage:[UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_bottom_bg]];
//        }
//        else
//        {
//            if (isVideo)
//            {
//                self.tabbarBgView.backgroundColor = [UIColor colorWithHexString:@"#242426"];
//            }
//            else
//            {
//                self.tabbarBgView.backgroundColor = [UIColor whiteColor];
//            }
//        }
//    }
//    else
//    {
        if (isVideo)
        {
            self.tabbarBgView.backgroundColor = [UIColor colorWithHexString:@"#242426"];
        }
        else
        {
            self.tabbarBgView.backgroundColor = [UIColor whiteColor];
        }
//    }
    
    NSArray * array = [self getTitleArray:isVideo];
    for (int i = 0; i < self.viewControllers.count; i ++)
    {
        UIViewController * viewController = self.viewControllers[i];
        NSDictionary * dic = array[i];
        
        viewController.view.backgroundColor     = isVideo ? [UIColor blackColor] : [UIColor whiteColor];
        viewController.tabBarItem.title         = dic[@"title"];
        viewController.tabBarItem.image         = [dic[@"normalImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.tabBarItem.selectedImage = [dic[@"selectedImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self setUpTabBarItemTextAttributes:isVideo];
    }
}

#pragma mark -
#pragma mark - Private Methods

/**
 *  利用 KVC 把 系统的 tabBar 类型改为自定义类型。
 */
- (void)setUpTabBar
{
//    [self setValue:[[DWTabBar alloc] init] forKey:@"tabBar"];
}

/**
 *  tabBarItem 的选中和不选中文字属性
 */
- (void)setUpTabBarItemTextAttributes:(BOOL)isVideo
{
        // 普通状态下的文字属性
//        NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
//        normalAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:isVideo ? @"#ffffff" : @"#282828"];
//
//        // 选中状态下的文字属性
//        NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
//        selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:isVideo ? @"#ffffff" : @"#282828"];
//
//        // 设置文字属性
//        UITabBarItem *tabBar = [UITabBarItem appearance];
//        [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
//        [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

    if (@available(iOS 13.0, *)) {

        UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
        tabBarAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffsetMake(0, -3);
        NSMutableDictionary<NSAttributedStringKey, id> *selectedAttributes = tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes.mutableCopy;
        selectedAttributes[NSForegroundColorAttributeName] = [UIColor colorWithHexString:isVideo ? @"#ffffff" : @"#282828"];
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes.copy;

        NSMutableDictionary<NSAttributedStringKey, id> *normalAttributes = tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes.mutableCopy;
        normalAttributes[NSForegroundColorAttributeName] = [UIColor colorWithHexString:isVideo ? @"#ffffff" : @"#282828"];
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes.copy;

        tabBarAppearance.backgroundImage = [UIImage imageWithColor:isVideo ? UIColor.blackColor : UIColor.whiteColor];
        tabBarAppearance.shadowColor = isVideo ? [UIColor colorWithHexString:@"#282828"] : FontColorDE;
        self.tabBar.standardAppearance = tabBarAppearance;
    }
    else
    {
        NSMutableDictionary *selectedAttributes = [[NSMutableDictionary alloc] initWithDictionary:[[UITabBarItem appearance] titleTextAttributesForState:UIControlStateSelected]];
        selectedAttributes[NSForegroundColorAttributeName] = [UIColor colorWithHexString:isVideo ? @"#ffffff" : @"#282828"];

        [[UITabBarItem appearance] setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:isVideo ? @"#ffffff" : @"#282828"]} forState:UIControlStateNormal];

        self.tabBar.shadowImage = [UIImage imageWithColor:FontColorDE];
        self.tabBar.backgroundImage = [UIImage imageWithColor:isVideo ? UIColor.blackColor : UIColor.whiteColor];
    }
}

/**
 *  添加子控制器，我这里值添加了4个，没有占位自控制器
 */
- (void)setUpChildViewController
{
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
//    BOOL is_new_ui = [MyNewMaterialInfo shareInstance].isShowMaterial;
//    if (is_new_ui)
//    {
//        NSFileManager *fileMgr = [NSFileManager defaultManager];
//        BOOL bRet = [fileMgr fileExistsAtPath:[MyNewMaterialInfo shareInstance].home_bottom_bg];
//        if (bRet) {
//            [[UITabBar appearance] setBackgroundImage:[UIImage imageWithContentsOfFile:[MyNewMaterialInfo shareInstance].home_bottom_bg]];
//        }
//        else
//        {
//            [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor clearColor]]];
//        }
//    }
//    else
//    {
//        [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor clearColor]]];
//    }
    NSArray * array = [self getTitleArray:NO];
    for (NSDictionary * dic in array)
    {
        [self addOneChildViewController:[[MyNavigationController alloc] initWithRootViewController:dic[@"vc"]]
                              WithTitle:dic[@"title"]
                              imageName:dic[@"normalImage"]
                      selectedImageName:dic[@"selectedImage"]];
    }
}

/**
 *  添加一个子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param normalImage         图片
 *  @param selectedImage 选中图片
 */

- (void)addOneChildViewController:(UIViewController *)viewController WithTitle:(NSString *)title imageName:(UIImage *)normalImage selectedImageName:(UIImage *)selectedImage{
    
    viewController.view.backgroundColor     = [UIColor whiteColor];
    viewController.tabBarItem.title         = title;
    viewController.tabBarItem.image         = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    viewController.tabBarItem.selectedImage = [UIImage imageNamed:imageName];
    [self addChildViewController:viewController];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]])
    {
        UIViewController * vc = [(UINavigationController *)viewController visibleViewController];
        NSInteger index = [self.viewControllers indexOfObject:viewController];
//        MYLog(@"==========%@", NSStringFromClass([vc class]));
        
        if ([vc isEqual:self.selectedVc] || (index == 0 && [vc isKindOfClass:[MyHomeSubsectionController class]] && !self.selectedVc))
        {
            //点击置顶
            [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([vc class]) object:[NSNumber numberWithBool:[self doubleClick]]];
        }
        self.selectedVc = vc;
    }
    [self.view.layer addAnimation:self.transition forKey:nil];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UIViewController * vc = [(UINavigationController *)viewController visibleViewController];
    if (![YYToolModel islogin] && [vc isKindOfClass:[WelfareCentreViewController class]])
    {
        LoginViewController * login = [LoginViewController new];
        login.hidesBottomBarWhenPushed = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:login animated:YES];
        return NO;
    }
    return YES;
}

//点击震动
- (void)feedbackGenerator
{
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator prepare];
    [generator impactOccurred];
}

//是否双击
- (BOOL)doubleClick
{
    NSDate *date = [NSDate date];
    if (date.timeIntervalSince1970 - self.lastDate.timeIntervalSince1970 < 0.5) {
        //完成一次双击后，重置第一次单击的时间，区分3次或多次的单击
        self.lastDate = [NSDate dateWithTimeIntervalSince1970:0];
        return YES;
    }
    self.lastDate = date;
    return NO;
}

- (BOOL)loginSuccessStatus {
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
    if (userID) {
        return YES;
    }
    return NO;
}
- (void)pushToLoginVC {
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (userId && userId.length > 0) {
        return;
    }
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    NSArray *array = self.childViewControllers;
    UINavigationController *nav = [array objectAtIndex:self.selectedIndex];
    
    [nav pushViewController:loginVC animated:YES];
}

- (void)leftBarButtonItemTouchUpInside:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:^{
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppKeFuClose" object:nil];
    }];
}
//这个方法可以抽取到 UIImage 的分类中
- (UIImage *)imageWithColor:(UIColor *)color
{
    NSParameterAssert(color != nil);
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)provision {
    //模板位置
    NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"maiyouProfile" ofType:@"mobileconfig"];
    
    //目标位置
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"profile.mobileconfig"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:templatePath toPath:path error:nil];
    
    __weak AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UInt16 port = appDelegate.httpServer.port;
    NSLog(@"%u", port);
    if (success) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%u/profile.mobileconfig", port]]];
    else NSLog(@"Error generating profile");
}

@end
