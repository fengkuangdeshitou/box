//
//  MyUserReturnController.m
//  Game789
//
//  Created by Maiyou001 on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyUserReturnController.h"

#import "MyUserReturnTaskCell.h"
#import "MyUserReturnGamesView.h"
#import "MyUserReturnAlertView.h"
#import "MyUserReturnRuleView.h"

#import "MyUserReturnApi.h"
#import "MyUserReturnApi.h"

@interface MyUserReturnController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_height;
@property (weak, nonatomic) IBOutlet UILabel *showTaskStep;
@property (weak, nonatomic) IBOutlet UIButton *dayBtn1;
@property (weak, nonatomic) IBOutlet UIButton *dayBtn2;
@property (weak, nonatomic) IBOutlet UIButton *dayBtn3;
@property (weak, nonatomic) IBOutlet UILabel *activeTime;
@property (weak, nonatomic) IBOutlet UILabel *nextGiftTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activeTime_top;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSDictionary * dataDic;
@property (nonatomic,strong) NSArray *gamesArray;
@property (nonatomic,copy) NSString * activeDay;
@property (nonatomic, assign) NSInteger selectIndex;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger count1;

@end

@implementation MyUserReturnController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.hidden = YES;
    self.scrollView_top.constant = kStatusBarAndNavigationBarHeight;
    self.navBar.title = @"老用户回归";
    self.activeTime_top.constant = kScreenW * 165 / 414;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyUserReturnTaskCell" bundle:nil] forCellReuseIdentifier:@"MyUserReturnTaskCell"];
    self.navigationController.delegate = self;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    NSArray * array = @[@{@"imageName":@"user_return_task1", @"title":@"签到", @"desc":@"留下你的专属足迹", @"type":@"sign"},
                       @{@"imageName":@"user_return_task2", @"title":@"登录游戏", @"desc":@"登录任意游戏即可完成任务", @"type":@"login_game"},
                       @{@"imageName":@"user_return_task3", @"title":@"游戏评价", @"desc":@"发布游戏评价，说出你的感受", @"type":@"comments"}];
    self.dataArray = [MyUserReturnModel mj_objectArrayWithKeyValuesArray:array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getData:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[NSClassFromString(@"MyHomeSubsectionController") class]]) {
        [self stopTimer];
    }
}

- (void)getData:(BOOL)isHud
{
    WEAKSELF
    MyUserReturnApi * api = [[MyUserReturnApi alloc] init];
    api.isShow = isHud;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.scrollView.hidden = NO;
            NSDictionary * data = request.data;
            self.dataDic = data;
            self.activeDay = data[@"day"];
            self.gamesArray = data[@"gift_list"];
            NSInteger index = [data[@"day"] integerValue];
            NSDictionary * day = data[[NSString stringWithFormat:@"day%ld", (long)(index < 4 ? index : 3)]];
            for (int i = 0; i < weakSelf.dataArray.count; i ++)
            {
                MyUserReturnModel * model = weakSelf.dataArray[i];
                if (i == 0) {
                    model.sign = [day[@"sign"] boolValue];
                }else if (i == 1) {
                    model.login_game = [day[@"login_game"] boolValue];
                }else if (i == 2) {
                    model.comments = [day[@"comments"] boolValue];
                }
            }
            
            if ([data[@"day"] integerValue] == 1)
            {
                weakSelf.showTaskStep.text = [NSString stringWithFormat:@"【%@重礼】", @"一"];
                //下次礼包倒计时
                weakSelf.count = [data[@"next_start_time"] integerValue];
                weakSelf.nextGiftTime.text = [NSString stringWithFormat:@"距离下次礼包开启还有：%ld:%@", weakSelf.count / 3600, [NSDate dateWithFormat:@"mm:ss" WithTS:weakSelf.count]];
                //三重礼礼包领取状态
                [weakSelf showBtnStatus:[data[@"day1"][@"status"] integerValue] btn:weakSelf.dayBtn1];
            }
            else if ([data[@"day"] integerValue] == 2)
            {
                weakSelf.showTaskStep.text = [NSString stringWithFormat:@"【%@重礼】", @"二"];
                //下次礼包倒计时
                weakSelf.count = [data[@"next_start_time"] integerValue];
                weakSelf.nextGiftTime.text = [NSString stringWithFormat:@"距离下次礼包开启还有：%ld:%@", weakSelf.count / 3600, [NSDate dateWithFormat:@"mm:ss" WithTS:weakSelf.count]];
                //三重礼礼包领取状态
                [weakSelf showBtnStatus:[data[@"day1"][@"status"] integerValue] btn:weakSelf.dayBtn1];
                [weakSelf showBtnStatus:[data[@"day2"][@"status"] integerValue] btn:weakSelf.dayBtn2];
                
                __block BOOL isExsit = NO;
                [weakSelf.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MyUserReturnModel * model = obj;
                    isExsit = [model.type isEqualToString:@"amount1"];
                    if (isExsit) {
                        model.amount1 = [day[@"amount1"] boolValue];
                    }
                }];
                if (!isExsit)
                {
                    MyUserReturnModel * model1 = [[MyUserReturnModel alloc] init];
                    model1.amount1 = [day[@"amount1"] boolValue];
                    model1.imageName = @"user_return_task4";
                    model1.title = @"累计现金充值1元";
                    model1.desc = @"花点小钱，体验更多游戏乐趣";
                    model1.type = @"amount1";
                    [weakSelf.dataArray addObject:model1];
                }
            }
            else
            {
                weakSelf.showTaskStep.text = [NSString stringWithFormat:@"【%@重礼】", @"三"];
                //下次礼包倒计时
                weakSelf.nextGiftTime.text = @"";
                //三重礼礼包领取状态
                [weakSelf showBtnStatus:[data[@"day1"][@"status"] integerValue] btn:weakSelf.dayBtn1];
                [weakSelf showBtnStatus:[data[@"day2"][@"status"] integerValue] btn:weakSelf.dayBtn2];
                [weakSelf showBtnStatus:[data[@"day3"][@"status"] integerValue] btn:weakSelf.dayBtn3];
                
                __block BOOL isExsit = NO;
                [weakSelf.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    MyUserReturnModel * model = obj;
                    isExsit = [model.type isEqualToString:@"amount10"];
                    if (isExsit) {
                        model.amount10 = [day[@"amount10"] boolValue];
                    }
                }];
                if (!isExsit) {
                    MyUserReturnModel * model2 = [[MyUserReturnModel alloc] init];
                    model2.amount10 = [day[@"amount10"] boolValue];
                    model2.title = @"累计现金充值10元";
                    model2.imageName = @"user_return_task4";
                    model2.desc = @"花点小钱，体验更多游戏乐趣";
                    model2.type = @"amount10";
                    [weakSelf.dataArray addObject:model2];
                }
            }
            weakSelf.tableView_height.constant = weakSelf.dataArray.count * 60;
            [weakSelf.tableView reloadData];
            //活动结束时间
            if (weakSelf.activeDay.integerValue < 4)
            {
                weakSelf.count1 = [data[@"active_end_time"] integerValue];
                weakSelf.activeTime.text = [NSString stringWithFormat:@"距离活动结束剩余：%ld:%@", weakSelf.count1 / 3600, [NSDate dateWithFormat:@"mm:ss" WithTS:weakSelf.count1]];
                if (!weakSelf.timer) [weakSelf startTimer];
            }
            else
            {
                weakSelf.count1 = [data[@"active_end_time"] integerValue];
                weakSelf.activeTime.text = @"活动已结束";
            }
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:weakSelf.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:weakSelf.view];
    }];
}

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(codeBtnChange) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)codeBtnChange
{
    self.count --;
    self.count1 --;
    if (self.count <= 0 && self.count1 <= 0)
    {
        self.activeTime.text = @"活动已结束";
        self.nextGiftTime.text = @"";
        
        [self stopTimer];
    }
    else
    {
        self.activeTime.text = [NSString stringWithFormat:@"距离活动结束剩余：%ld:%@", self.count1 / 3600, [NSDate dateWithFormat:@"mm:ss" WithTS:self.count1]];
        self.nextGiftTime.text = [NSString stringWithFormat:@"距离下次礼包开启还有：%ld:%@", self.count / 3600, [NSDate dateWithFormat:@"mm:ss" WithTS:self.count]];
    }
}

- (void)showBtnStatus:(NSInteger)status btn:(UIButton *)btn
{
    UIImageView * imageView = [self.view viewWithTag:btn.tag + 10];
    if (status == 0) {
        [btn setTitle:@"待领取" forState:0];
        btn.backgroundColor = [UIColor colorWithHexString:@"#F85835"];
//        btn.enabled = NO;
        imageView.image = MYGetImage(@"user_return_gift2");
    }else if (status == 1) {
        [btn setTitle:@"领取" forState:0];
        btn.backgroundColor = [UIColor colorWithHexString:@"#F85835"];
//        btn.enabled = YES;
        imageView.image = MYGetImage(@"user_return_gift2");
    }else if (status == 2) {
        [btn setTitle:@"已领取" forState:0];
        btn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
//        btn.enabled = NO;
        imageView.image = MYGetImage(@"user_return_gift1");
    }
    
    if (self.activeDay.integerValue == 2 && [self.dataDic[@"day1"][@"status"] integerValue] == 0)
    {
        [self.dayBtn1 setTitle:@"已结束" forState:0];
        [self.dayBtn1 setBackgroundColor:[UIColor colorWithHexString:@"#CCCCCC"]];
    }
    else if (self.activeDay.integerValue == 3)
    {
        if ([self.dataDic[@"day1"][@"status"] integerValue] == 0)
        {
            [self.dayBtn1 setTitle:@"已结束" forState:0];
            [self.dayBtn1 setBackgroundColor:[UIColor colorWithHexString:@"#CCCCCC"]];
        }
        else if ([self.dataDic[@"day2"][@"status"] integerValue] == 0)
        {
            [self.dayBtn2 setTitle:@"已结束" forState:0];
            [self.dayBtn3 setBackgroundColor:[UIColor colorWithHexString:@"#CCCCCC"]];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyUserReturnTaskCell";
    MyUserReturnTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.userModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)receiveBtnClick:(id)sender
{
    UIButton * button = sender;
    if ([button.titleLabel.text isEqualToString:@"领取"])
    {
        self.selectIndex = button.tag - 10 + 1;
        if (self.selectIndex == 1)
        {
            [self showAlertView];
        }
        else
        {
            [self receiveGift:@"" view:nil];
        }
    }
    else if ([button.titleLabel.text isEqualToString:@"待领取"])
    {
        [MBProgressHUD showToast:@"完成任务后才可领取" toView:self.view];
    }
}
 
- (void)showAlertView
{
    WEAKSELF
    MyUserReturnAlertView * alertView = [[MyUserReturnAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    alertView.day = self.selectIndex;
    [self.view addSubview:alertView];
    alertView.receiveAction = ^{
        [weakSelf showGameView];
    };
}

- (void)showGameView
{
    WEAKSELF
    __block MyUserReturnGamesView * gameView = [[MyUserReturnGamesView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    typeof(gameView) __weak weakView = gameView;
    gameView.dataArray = [MyUserReturnGamesModel mj_objectArrayWithKeyValuesArray:self.gamesArray];
    [self.view addSubview:gameView];
    gameView.receivedSuccess = ^(NSString * _Nonnull pack_ids) {
        [weakSelf receiveGift:pack_ids view:weakView];
    };
}

- (void)receiveGift:(NSString *)pack_ids view:(MyUserReturnGamesView *)gamesView
{
    MyUserReturnReceiveGiftApi * api = [[MyUserReturnReceiveGiftApi alloc] init];
    api.day = self.selectIndex;
    api.pack_ids = pack_ids;
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            if (self.selectIndex == 1)
            {
                [YJProgressHUD showSuccess:@"领取成功" inview:self.view];
                [gamesView removeFromSuperview];
            }
            else
            {
                [self showAlertView];
            }
            
            [self getData:NO];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc];
    }];
}

- (IBAction)activeRuleClick:(id)sender
{
    MyUserReturnRuleView * ruleView = [[MyUserReturnRuleView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:ruleView];
}

- (void)dealloc
{
    [self stopTimer];
}

@end
