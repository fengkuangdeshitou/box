//
//  MoneyCardViewController.m
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MoneyCardViewController.h"
#import "MoneyCardPriceCell.h"
#import "MoneyCardDescCell.h"
#import "PayAlertView.h"
#import "AuthAlertView.h"
#import "AdultAlertView.h"

@interface MoneyCardViewController ()<UITableViewDelegate,UITableViewDataSource,MoneyCardPriceCellDelegate,AuthAlertViewDelegate>

@property(nonatomic,copy)NSString * gradeId;
@property(nonatomic,copy)NSString * desc;
@property(nonatomic,copy)NSString * submit_button_title;
@property(nonatomic,copy)NSString * productName;
@property(nonatomic,copy)NSString * tips;
@property(nonatomic,copy)NSString * buttonDisplay;//1 置灰  0可以购买
@property(nonatomic,copy)NSString * buttonTime;

@end

@implementation MoneyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the vi77ew.
    
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    self.buttonTime = data[@"buttonTime"];
    self.buttonDisplay = data[@"buttonDisplay"];
    self.submit_button_title = self.buttonDisplay.intValue == 0 ? @"立即购买" : @"已开通";
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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
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
    self.desc = @"";
    self.tips = @"";
    for (NSDictionary * item in self.data[@"items"]) {
        if ([item[@"tips"] length] > 0 && [gradeid isEqualToString:item[@"grade_id"]]) {
            self.tips = item[@"tips"];
        }
        if (![item[@"buy_tips"] isEqualToString:@""] && [gradeid isEqualToString:item[@"grade_id"]]) {
            self.desc = item[@"buy_tips"];
        }
        if ([gradeid isEqualToString:item[@"grade_id"]]) {
            self.productName = item[@"name"];
        }
    }
    [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

- (void)onAuthSuccess{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"]];
    [dic setValue:@1 forKey:@"isRealNameAuth"];
    [NSUserDefaults.standardUserDefaults setValue:dic forKey:@"member_info"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)buyAction
{
    // [YYToolModel getUserdefultforKey:TOKEN], [YYToolModel getUserdefultforKey:USERID], [YYToolModel getUserdefultforKey:@"user_name"]
    if (self.gradeId == nil) {
        self.gradeId = [NSString stringWithFormat:@"%@",[self.data[@"items"] firstObject][@"grade_id"]];
    }
    
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
    
    //统计
    [MyAOPManager relateStatistic:@"ClickToPayOnMembershipCenter" Info:@{@"name":self.productName}];
    
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
        static NSString * cellIdentifity = @"MoneyCardPriceCell";
        MoneyCardPriceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoneyCardPriceCell" owner:self options:nil] firstObject];
        }
        cell.dataArray = self.data[@"items"];
        cell.delegate = self;
        return cell;
    }else{
        static NSString * cellIdentifity = @"MoneyCardDescCell";
        MoneyCardDescCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoneyCardDescCell" owner:self options:nil] firstObject];
        }
        if (self.buttonTime.length > 0){
            NSString * title = [NSString stringWithFormat:@"%@\n%@",self.submit_button_title,self.buttonTime];
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:title];
            [string addAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor} range:NSMakeRange(0, title.length)];
            [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} range:NSMakeRange(0, self.submit_button_title.length)];
            [string addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(self.submit_button_title.length, self.buttonTime.length+1)];
            [cell.buyButton setAttributedTitle:string forState:0];
            cell.buyButton.backgroundColor = [UIColor colorWithHexString:@"#AAAAAA"];
        }else{
            [cell.buyButton setTitle:self.submit_button_title forState:0];
        }
        cell.buyButton.titleLabel.textAlignment = 1;
        cell.buyButton.userInteractionEnabled = self.buttonDisplay.intValue == 0;
        [cell.buyButton addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        cell.descLabel.text = self.data[@"explain"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == 0 ? [self.data[@"items"] count] * 95 : UITableViewAutomaticDimension;
}

- (NSMutableAttributedString *)getAttrTitle:(NSString *)title
{
    if (title == nil)
    {
        title = @"";
    }
    NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:title];
    if ([title containsString:@"\n"])
    {
        NSRange range = [title rangeOfString:@"\n"];
        NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1E1917"]};
        [firstPart setAttributes:firstAttributes range:NSMakeRange(range.location, firstPart.length - range.location)];
    }
    else
    {
        NSDictionary * firstAttributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1E1917"]};
        [firstPart setAttributes:firstAttributes range:NSMakeRange(0, firstPart.length)];
    }
    return firstPart;
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
