//
//  HGCOmmunityChatListVC.m
//  HeiGuGame
//
//  Created by Harrison on 2020/9/28.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGCOmmunityChatListVC.h"
#import "HGCommunityChatListCell.h"

@interface HGCOmmunityChatListVC ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataListArray;
@end

@implementation HGCOmmunityChatListVC

- (NSMutableArray *)dataListArray {
    if (!_dataListArray) {
        _dataListArray = [NSMutableArray array];
    }
    return _dataListArray;;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            //            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        __unsafe_unretained UITableView *tableView = _tableView;
        WEAKSELF
        // 下拉刷新
        tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
            [tableView.mj_footer resetNoMoreData];
            weakSelf.pageNumber = 1;
            [weakSelf getChatList];
        }];
        
        // 上拉刷新
        tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.pageNumber ++;
            [weakSelf getChatList];
        }];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareBaisc];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)getChatList
{
//    YYBaseApi *api = [[YYBaseApi alloc]init];
//    api.pageNumber = self.pageNumber;
//    api.pageCount  = 10;
//    [api yy_Post:@"/groupList" parameters:@{} swpNetworkingSuccess:^(id  _Nonnull resultObject) {
//        if ([self.tableView.mj_header isRefreshing])[self.tableView.mj_header endRefreshing];
//        if ([self.tableView.mj_footer isRefreshing])[self.tableView.mj_footer endRefreshing];
//        NSDictionary *dataDic = [resultObject[@"data"] deleteAllNullValue];
//        NSArray *array = dataDic[@"grouplist"][@"list"];
//        if (self.pageNumber == 1 && self.dataListArray.count > 0) {
//            [self.dataListArray removeAllObjects];
//        }
//        [self.dataListArray addObjectsFromArray:array];
//        [self.tableView reloadData];
//        self.hasNextPage = [dataDic[@"grouplist"][@"pagination"][@"hasNextPage"] boolValue];
//        [self setFooterViewState:self.tableView Data:dataDic[@"grouplist"][@"pagination"]  FooterView:[self creatFooterView]];
//    } swpNetworkingError:^(NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
//
//    } Hud:NO];
}


- (void)prepareBaisc
{
    self.navBar.title = @"推荐群聊";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kStatusBarAndNavigationBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)joinChat:(NSDictionary *)dic {
    if (![YYToolModel isAlreadyLogin]) {
        return;
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataListArray[indexPath.row];
    [self joinChat:dic];
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cell";
    HGCommunityChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HGCommunityChatListCell" owner:self options:nil].firstObject;
    }
    if (self.dataListArray.count > 0) {
        NSDictionary *dic = self.dataListArray[indexPath.row];
        cell.dataDic = dic;
    }

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 10;
    if(y > h + reload_distance && !self.isLoading && self.hasNextPage) {
        self.isLoading = YES;
        [self.tableView.mj_footer beginRefreshing];
    } else {
        if (self.isLoading) {
            self.isLoading = NO;
        }
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
