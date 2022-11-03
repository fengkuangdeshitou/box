//
//  HGCommunityVC.m
//  HeiGuGame
//
//  Created by Harrison on 2020/9/28.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGCommunityVC.h"
#import "HGCommunityTHV.h"
#import "HGCommunityPushVC.h"
@interface HGCommunityVC ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) HGCommunityTHV *tableHV;

@end

@implementation HGCommunityVC

- (HGCommunityTHV *)tableHV
{
    if (_tableHV == nil)
    {
        _tableHV = [[HGCommunityTHV alloc]init];
        _tableHV.frame = CGRectMake(0, 0, kScreenW, _tableHV.view_height);
    }
    return _tableHV;
}

-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kTabbarHeight - kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableHeaderView = self.tableHV;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBaisc];
    
}

- (void)prepareBaisc
{
    self.navBar.title = @"社区";
    self.navBar.backgroundColor = MAIN_COLOR;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [rightBtn setImage:[UIImage imageNamed:@"community_chatList"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pushCommunityAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:rightBtn];
      [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.equalTo(self.navBar.mas_right).offset(-12);
          make.bottom.equalTo(self.navBar.mas_bottom).offset(-9);
          make.width.mas_equalTo(@26);
          make.height.mas_equalTo(@26);
      }];
    [self.view addSubview:self.tableView];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 21;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"HGCommunityChatListCell" owner:self options:nil].firstObject;
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

//发布话题
- (void)pushCommunityAction {
    HGCommunityPushVC * info = [HGCommunityPushVC new];
    info.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:info animated:YES];
}

@end
