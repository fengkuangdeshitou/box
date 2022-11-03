//
//  RankingMyViewController.m
//  Game789
//
//  Created by maiyou on 2021/11/22.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "RankingMyViewController.h"
#import "GetGameHallListApi.h"
#import "SGPageTitleView.h"
#import "SGPageTitleViewConfigure.h"

@interface RankingContentView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,assign)NSInteger page;

@end

@implementation RankingContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.page = 1;
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        [self.tableView registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:nil] forCellReuseIdentifier:@"GameTableViewCell"];
        [self addSubview:self.tableView];
        
        self.tableView.mj_header = [MFRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestData];
        }];
        
        self.tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
            [self requestData];
        }];        
    }
    return self;
}

- (void)setType:(NSString *)type{
    _type = type;
    [self requestData];
}

- (void)requestData{
    GetGameHallListApi *api = [[GetGameHallListApi alloc] init];
    api.pageNumber = 1;
    api.count = 10;
    api.isShow = YES;
    api.type = self.type;
    api.game_species_type = @"1";
    api.pageNumber = self.page;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (self.page == 1){
            self.dataArray = [[NSMutableArray alloc] initWithArray:[GameModel mj_objectArrayWithKeyValuesArray:request.data[@"game_list"]]];
        }else{
            [self.dataArray addObjectsFromArray:[GameModel mj_objectArrayWithKeyValuesArray:request.data[@"game_list"]]];
        }
        NSDictionary *dic = api.data[@"paginated"];
        BaseViewController * vc = ((BaseViewController *)YYToolModel.getCurrentVC);
        [vc setFooterViewState:self.tableView Data:dic FooterView:[vc creatFooterView]];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failureBlock:^(BaseRequest * _Nonnull request) {

    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifity = @"GameTableViewCell";
    GameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifity];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GameTableViewCell" owner:self options:nil].firstObject;
    }
    cell.source = @"home";
    cell.containViewHeight = 20;
    cell.indexPath = indexPath;
    cell.listType = self.type;
    [cell setModelDic:[self.dataArray[indexPath.section] mj_JSONObject]];
    [YYToolModel clipRectCorner:UIRectCornerAllCorners radius:13 view:cell.radiusView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [self.dataArray[indexPath.section] mj_JSONObject];
    GameDetailInfoController * detail = [[GameDetailInfoController alloc] init];
    detail.gameID = dic[@"game_id"];
    [YYToolModel.getCurrentVC.navigationController pushViewController:detail animated:true];
    
    //统计
    NSString * title = self.type.integerValue == 2 ? @"热门榜" : (self.type.integerValue == 3 ? @"新游榜" : @"下载榜");
    [MyAOPManager gameRelateStatistic:@"ClickTheGameInTheRankList" GameInfo:dic Add:@{@"tapName":title}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GameModel * model = self.dataArray[indexPath.section];
    return model.rankingCellHeight + 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

@end

@interface RankingMyViewController ()<SGPageTitleViewDelegate>

@property(nonatomic,strong)SGPageTitleView * titleView;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UIImageView * flag;

@end

@implementation RankingMyViewController

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, ScreenWidth, ScreenHeight-kStatusBarAndNavigationBarHeight-kTabbarHeight)];
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

- (UIImageView *)flag{
    if (!_flag) {
        _flag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 27, 22, 6.5)];
        _flag.image = [UIImage imageNamed:@"ranking"];
    }
    return _flag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBar.hidden = YES;
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.scrollView];
    
    SGPageTitleViewConfigure * config = [SGPageTitleViewConfigure pageTitleViewConfigure];
    config.contentInsetSpacing = 10;
    config.equivalence = false;
    config.showBottomSeparator = false;
    config.titleFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    config.titleSelectedFont = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    config.indicatorStyle = SGIndicatorStyleDefault;
    config.titleGradientEffect = YES;
    config.titleColor = [UIColor colorWithHexString:@"#666666"];
    config.titleSelectedColor = [UIColor colorWithHexString:@"#282828"];
    config.showIndicator = false;
    self.titleView = [[SGPageTitleView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, ScreenWidth, 48) delegate:self titleNames:@[@"热门榜",@"新游榜",@"下载榜"] configure:config];
    self.titleView.backgroundColor = self.scrollView.backgroundColor;
    [self.view addSubview:self.titleView];
    
    [self getPageTitleContentView];
    
    NSArray * typeArray = @[@"2",@"3",@"4"];
    for (int i=0; i<typeArray.count; i++) {
        RankingContentView * content = [[RankingContentView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 48, ScreenWidth, self.scrollView.height-48)];
        content.backgroundColor = self.scrollView.backgroundColor;
        content.type = typeArray[i];
        [self.scrollView addSubview:content];
    }
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth*typeArray.count, 0)];
}

- (void)getPageTitleContentView{
    for (UIView * view in self.titleView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            for (UIView * content in view.subviews) {
                if ([content isKindOfClass:[UIButton class]]) {
                    UIButton * btn = (UIButton *)content;
                    if (btn.selected) {
                        [btn addSubview:self.flag];
                        self.flag.y = 27;
                        self.flag.x = btn.width/2-11;
                        return;
                    }
                }
            }
        }
    }
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex{
    [self getPageTitleContentView];
    [self.scrollView setContentOffset:CGPointMake(ScreenWidth*selectedIndex, 0) animated:true];
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
