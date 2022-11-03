//
//  CardMemberViewController.m
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "CardMemberViewController.h"
#import "MemberPriceCell.h"
#import "MemberDescCell.h"
#import "PayAlertView.h"
#import "AuthAlertView.h"
#import "AdultAlertView.h"
#import "MemberInterestsAlertView.h"

@interface CardMemberViewController ()<UITableViewDelegate,UITableViewDataSource,MemberPriceCellDelegate,AuthAlertViewDelegate,MemberDescCellDelegate>

@property(nonatomic,assign)NSInteger flag;
@property(nonatomic,copy)NSString * gradeId;
@property(nonatomic,copy)NSString * submit_button_title;
@property(nonatomic,copy)NSString * productName;

@end

@implementation CardMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.view.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)onSelectedGradeId:(NSString *)gradeid{
    self.gradeId = gradeid;
    for (int i=0;i<[self.data[@"items"] count]; i++) {
        NSDictionary * item = self.data[@"items"][i];
        if ([gradeid isEqualToString:item[@"grade_id"]]) {
            self.submit_button_title = item[@"submit_button_title"];
            self.productName = item[@"title"];
            self.flag = i;
        }
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    MemberPriceCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.buyButton setTitle:self.submit_button_title forState:UIControlStateNormal];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)onDidselectedIndex:(NSInteger)index{
    [MemberInterestsAlertView showMemberInterestsAlertViewWithData:self.data scrollToIndex:index];
}

- (void)onAuthSuccess{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"]];
    [dic setValue:@1 forKey:@"isRealNameAuth"];
    [NSUserDefaults.standardUserDefaults setValue:dic forKey:@"member_info"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)buyAction{
    // [YYToolModel getUserdefultforKey:TOKEN], [YYToolModel getUserdefultforKey:USERID], [YYToolModel getUserdefultforKey:@"user_name"]
    
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"];
    BOOL isRealNameAuth = [dic[@"isRealNameAuth"] boolValue];
    if ([DeviceInfo shareInstance].isCheckAuth && !isRealNameAuth) {
        [AuthAlertView showAuthAlertViewWithDelegate:self];
        return;
    }
    
    BOOL isAdult = [dic[@"isAdult"] boolValue];
    if ([DeviceInfo shareInstance].isCheckAdult && !isAdult) {
        [AdultAlertView showAdultAlertView];
        return;
    }
    
    [MyAOPManager relateStatistic:@"ClickToPayOnSavingCardPage" Info:@{@"name":self.productName}];
    
    PayAlertView * webView = [[PayAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    NSString * url = [NSString stringWithFormat:@"%@?token=%@&username=%@&grade_id=%@",self.data[@"pay_url"],[YYToolModel getUserdefultforKey:TOKEN],[YYToolModel getUserdefultforKey:@"user_name"],self.gradeId];
    webView.url = url;
    [UIApplication.sharedApplication.keyWindow addSubview:webView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString * cellIdentifity = @"MemberPriceCell";
        MemberPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MemberPriceCell" owner:self options:nil] firstObject];
        }
        cell.dataArray = self.data[@"items"];
        cell.delegate = self;
        [cell.buyButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        static NSString * cellIdentifity = @"MemberDescCell";
        MemberDescCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MemberDescCell" owner:self options:nil] firstObject];
        }
        cell.dataArray = self.data[@"items"][self.flag][@"privilege"];
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == 0 ? 260 : 360;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat progress = scrollView.contentOffset.y;
    if(progress <= 0.01){
        //往上滑动，透明度为0
        ((BaseViewController *)YYToolModel.getCurrentVC).navBar.backgroundColor = [UIColor clearColor];
        ((BaseViewController *)YYToolModel.getCurrentVC).navBar.alpha = 1;
    }else{
        ((BaseViewController *)YYToolModel.getCurrentVC).navBar.backgroundColor = [[UIColor colorWithHexString:@"#2c3145"] colorWithAlphaComponent:progress/kStatusBarAndNavigationBarHeight];
    }
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
