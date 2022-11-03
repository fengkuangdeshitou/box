//
//  InternalTestingViewController.m
//  Game789
//
//  Created by maiyou on 2022/3/3.
//  Copyright © 2022 yangyong. All rights reserved.
//

#define k_heightAndSpace 30.f
#define k_height 15.f

#import "InternalTestingViewController.h"
#import "InternalTestingTableViewCell.h"
#import "TestingAPI.h"
#import "GameModel.h"

@interface InternalTestingViewController ()<UITableViewDelegate, UINavigationControllerDelegate>

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * tableViewTop;
@property(nonatomic,strong) NSTimer * timer;
@property(nonatomic,weak)IBOutlet UIView * contentView;
@property(nonatomic,strong) NSArray * bate_user_list;

@property(nonatomic,strong) NSArray * dataArray;
@property(nonatomic,assign) NSInteger index;

@end

@implementation InternalTestingViewController

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[NSClassFromString(@"MyHomeSubsectionController") class]]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestTestingData) name:@"reloadTetingData" object:nil];
    self.navigationController.delegate = self;
    [MyAOPManager relateStatistic:@"ShowInternalTestPage" Info:@{}];
    self.navBar.title = @"游戏内测";
    self.index = -1;
    self.tableViewTop.constant = kStatusBarAndNavigationBarHeight;
    self.tableView.tableHeaderView.height = 228+184+ScreenWidth/375*269;
    [self.tableView registerNib:[UINib nibWithNibName:@"InternalTestingTableViewCell" bundle:nil] forCellReuseIdentifier:@"InternalTestingTableViewCell"];
    [self requestTestingData];
    UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_bg"]];
    self.tableView.backgroundView = view;
}

- (void)requestTestingData{
    TestingAPI * api = [[TestingAPI alloc] init];
    api.isShow = true;
    api.Id = self.Id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        self.bate_user_list = request.data[@"bate_user_list"];
        self.dataArray = [GameModel mj_objectArrayWithKeyValuesArray:request.data[@"projectGameslist"]];
        [self.tableView reloadData];
        if (self.contentView.subviews.count == 0) {
            [self setSubviews];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:true];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)setSubviews{
    for (int i=0; i<5; i++) {
        if (self.index < self.bate_user_list.count-1) {
            self.index ++;
        }else{
            self.index = 0;
        }
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(33, k_heightAndSpace*i, ScreenWidth-66, k_height)];
        view.backgroundColor = UIColor.clearColor;
        
        UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, k_height, k_height)];
        icon.image = [UIImage imageNamed:@"test_small_icon"];
        [view addSubview:icon];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, view.width-25, k_height)];
        
        label.attributedText = [self formatTextWithString];;
        label.tag = 10;
        [view addSubview:label];
        [self.contentView addSubview:view];
    }
}

- (NSAttributedString *)formatTextWithString{
    NSString * string = [NSString stringWithFormat:@"恭喜 玩家%@ 成为内测员，领取专属礼包",self.bate_user_list[self.index]];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:string];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, att.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, att.length)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F9D420"] range:[string rangeOfString:[NSString stringWithFormat:@"玩家%@",self.bate_user_list[self.index]]]];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[string rangeOfString:[NSString stringWithFormat:@"玩家%@",self.bate_user_list[self.index]]]];
    return att;
}

- (void)timeChange{
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            obj.y -= k_heightAndSpace;
        } completion:^(BOOL finished) {
            if (obj.y<=-k_height) {
                obj.frame = CGRectMake(33, k_heightAndSpace*4, ScreenWidth-66, k_height);
                if (self.index < self.bate_user_list.count-1) {
                    self.index ++;
                }else{
                    self.index = 0;
                }
                UILabel * label = [obj viewWithTag:10];
                label.attributedText = [self formatTextWithString];
            }
        }];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InternalTestingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InternalTestingTableViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
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
