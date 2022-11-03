//
//  NewExclusiveViewController.m
//  Game789
//
//  Created by maiyou on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "NewExclusiveViewController.h"
#import "ExclusiveContentViewController.h"
#import "ExclusiveAPI.h"
#import "YNPageViewController.h"
#import "ExclusiveRulesView.h"

@interface NewExclusiveViewController ()<UIScrollViewDelegate,YNPageScrollMenuViewDelegate>

@property(nonatomic,weak) IBOutlet UIScrollView * scrollView;
@property(nonatomic,strong)UIScrollView * contentScrollView;
@property(nonatomic,strong)UIImageView * dayImageView;

@property(nonatomic,strong)YNPageScrollMenuView * menu;
@property(nonatomic,strong)ExclusiveContentViewController * first;
@property(nonatomic,strong)ExclusiveContentViewController * second;
@property(nonatomic,strong)ExclusiveContentViewController * third;
@property(nonatomic,strong)NSDictionary * model;
@property(nonatomic,assign)BOOL flag;

@end

@implementation NewExclusiveViewController

- (UIImageView *)dayImageView{
    if (!_dayImageView) {
        _dayImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, 123, 38)];
    }
    return _dayImageView;
}

- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 420, ScreenWidth-30, ScreenHeight)];
        _contentScrollView.pagingEnabled = true;
        _contentScrollView.contentSize = CGSizeMake((ScreenWidth-30)*3, 0);
        _contentScrollView.bounces = false;
        _contentScrollView.backgroundColor = UIColor.whiteColor;
        _contentScrollView.delegate = self;
        _contentScrollView.showsHorizontalScrollIndicator = false;
        _contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _contentScrollView.showsVerticalScrollIndicator = false;
    }
    return _contentScrollView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([YYToolModel islogin]) {
        [self requestActiveData:YES];
    }else{
        self.scrollView.hidden = false;
        NSDictionary * model = @{@"day":@"0"};
        self.first.model = model;
        self.second.model = model;
        self.third.model = model;
    }
}

- (void)rules{
    [ExclusiveRulesView showExclusiveRulesView];
}

- (void)reloadData{
    [self requestActiveData:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exclusiveReceiveSuccess) name:@"exclusiveReceiveSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"loginReloadUrl" object:nil];
    
    self.navBar.barBackgroundColor = UIColor.clearColor;
    self.navBar.backgroundColor = UIColor.clearColor;
    self.navBar.lineView.hidden = true;
    [self.navBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back-1"]];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWidth-68, StatusBarHeight+10, 68, 25);
    [button setImage:[UIImage imageNamed:@"活动规则"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rules) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
    
    self.first = [[ExclusiveContentViewController alloc] init];
    self.first.view.tag = 10;
    self.first.view.frame = CGRectMake(0, 0, self.contentScrollView.width, self.contentScrollView.height);
    
    self.second = [[ExclusiveContentViewController alloc] init];
    self.second.view.tag = 11;
    self.second.view.frame = CGRectMake(ScreenWidth-30, 0, self.contentScrollView.width, self.contentScrollView.height);
    
    self.third = [[ExclusiveContentViewController alloc] init];
    self.third.view.tag = 12;
    self.third.view.frame = CGRectMake(ScreenWidth*2-60, 0, self.contentScrollView.width, self.contentScrollView.height);


    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 420)];
    imageView.image = [UIImage imageNamed:@"exclusive_header"];
    [self.scrollView addSubview:imageView];
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    YNPageConfigration * config = [YNPageConfigration defaultConfig];
    config.menuWidth = self.contentScrollView.width;
    config.menuHeight = 33;
    config.scrollMenu = false;
    config.aligmentModeCenter = false;
    config.showScrollLine = false;
    config.normalItemColor = [UIColor colorWithHexString:@"#F8AC22"];
    config.itemFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    config.scrollViewBackgroundColor = [UIColor colorWithHexString:@"#FFF8E3"];
    self.menu = [YNPageScrollMenuView pagescrollMenuViewWithFrame:CGRectMake(15, 420-33, self.contentScrollView.width, 33) titles:@[@"第一天",@"第二天",@"第三天"] configration:config delegate:self currentIndex:0];
    if (@available(iOS 11.0, *)) {
        self.menu.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    } else {
        // Fallback on earlier versions
    }
    self.menu.layer.cornerRadius = 5;
    [self.scrollView addSubview:self.menu];
    [self.menu addSubview:self.dayImageView];
    [self.scrollView addSubview:self.contentScrollView];
    
    [self.contentScrollView addSubview:self.first.view];
    [self.contentScrollView addSubview:self.second.view];
    [self.contentScrollView addSubview:self.third.view];

    self.scrollView.hidden = true;
    [self setContentWithIndex:0];
    
}

- (void)exclusiveReceiveSuccess
{
    [self requestActiveData:NO];
}

- (void)requestActiveData:(BOOL)isHud
{
    ExclusiveAPI * api = [[ExclusiveAPI alloc] init];
    api.isShow = isHud;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        self.model = request.data;
        self.first.model = self.model;
        self.second.model = self.model;
        self.third.model = self.model;
        if (self.flag == false) {
            self.flag = true;
            NSInteger index = [request.data[@"day"] intValue] > 3 ? 2 : ([request.data[@"day"] intValue]-1);
            [self setContentWithIndex:index];
            [self.contentScrollView setContentOffset:CGPointMake(index*(ScreenWidth-30), 0) animated:false];
        }
        self.scrollView.hidden = false;
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.contentScrollView.width;
    [self setContentWithIndex:index];
}

- (void)pagescrollMenuViewItemOnClick:(UIButton *)button index:(NSInteger)index{
    [self setContentWithIndex:index];
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.width*index, 0) animated:true];
}

- (void)setContentWithIndex:(NSInteger)index{
    CGFloat height = 35+kTabbarSafeBottomMargin;
    [self.contentScrollView layoutIfNeeded];
    if (index == 0) {
        self.contentScrollView.height = self.first.tableView.contentSize.height+height;
        self.scrollView.contentSize = CGSizeMake(0, 420+self.first.tableView.contentSize.height+height);
        self.dayImageView.x = 0;
    }else if (index == 1) {
        self.scrollView.contentSize = CGSizeMake(0, 420+self.second.tableView.contentSize.height+height);
        self.contentScrollView.height = self.second.tableView.contentSize.height+height;
        self.dayImageView.x = self.contentScrollView.width/2-self.dayImageView.width/2;
    }else{
        self.scrollView.contentSize = CGSizeMake(0, 420+self.third.tableView.contentSize.height+height);
        self.contentScrollView.height = self.third.tableView.contentSize.height+height;
        self.dayImageView.image = [UIImage imageNamed:@""];
        self.dayImageView.x = self.contentScrollView.width-self.dayImageView.width;
    }
    self.dayImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"day%ld",index]];
    [self.menu selectedItemIndex:index animated:false];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
