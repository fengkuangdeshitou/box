//
//  GameDetailViewController.m
//  Game789
//
//  Created by xinpenghui on 2017/9/11.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "GameDetailViewController.h"
#import "GameDetailApi.h"
#import "GetGiftApi.h"
#import "GameDownLoadApi.h"
#import "ChangyanSDK.h"

#import "DetailTitleTableViewCell.h"
#import "DetailScrollTableViewCell.h"
#import "DetailIntroduceTableViewCell.h"
#import "DetailIntroduce2TableViewCell.h"
#import "ServiceListTableViewCell.h"
#import "GamesListTableViewCell.h"

#import "RecommendListCellTableViewCell.h"

#import "RecommendGamesListView.h"

#import "NoticeDetailViewController.h"

#import "GiftDetailViewController.h"

#import "UIView+XLExtension.h"
#import "XLPhotoBrowser.h"

#import "LoginViewController.h"
//#import "UIButton+XLExtension.h"

@interface GameDetailViewController ()<UITableViewDelegate,UITableViewDataSource,XLPhotoBrowserDelegate,XLPhotoBrowserDatasource,DetailScrollTableViewCellDelegate,DetailIntroduceTableViewCellDelegate,DetailIntroduce2TableViewCellDelegate,GamesListTableViewCellDelegate,RecommendListCellTableViewCellDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) NSArray *recommendAry;
@property (strong, nonatomic) NSArray *urlStrings;

@property (assign, nonatomic) float introduce1Height;
@property (assign, nonatomic) float introduce2Height;

@property (assign, nonatomic) NSInteger totalCell;
@property (assign, nonatomic) BOOL isHaveVIP;
@property (assign, nonatomic) NSInteger rowCount;

@property (strong, nonatomic) NSString *downLoadURL;
@property (strong, nonatomic) NSString *routeURL;

@end

@implementation GameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.totalCell = 7;
    self.isHaveVIP = YES;
    self.rowCount = 0;
    [self.view addSubview:self.tableView];

//    UIViewController *listViewController = [ChangyanSDK getListCommentViewController:@""
//                                                                             topicID:nil
//                                                                       topicSourceID:@"20131125"
//                                                                          categoryID:nil
//                                                                          topicTitle:nil];
//    listViewController.view.frame = CGRectMake(0, 80, kScreen_width, 900);
////    [self.view addSubview:listViewController.view];
////[self addChildViewController:listViewController];
//    [self.view addSubview:listViewController.view];


//    self.introduce1Height = 122;



    self.introduce1Height = 181;
    self.introduce2Height = 136;

//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(64);
//        make.bottom.mas_equalTo(55);
//        make.left.right.mas_equalTo(0);
//    }];

    [self.view insertSubview:self.navBar aboveSubview:self.view];
    self.navBar.title = self.title;

    [self gameDetailApiRequest];
//    [self addNavBarShareBtn];
}

- (void)addNavBarShareBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreen_width-44), 20, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:button];
}

- (void)shareAction {
    NSLog(@"shareAction");
}

- (void)contentViewPress:(NSDictionary *)dic {
    //
}

- (void)addDownLoadBtn {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreen_width-317)/2, kScreen_height-55, 317, 48);
    [button setBackgroundImage:[UIImage imageNamed:@"btn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(downLoadAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"下载" forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)getMessageApiRequest {

    GameDownLoadApi *api = [[GameDownLoadApi alloc] init];
    //    WEAKSELF
    api.urls = self.routeURL;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"请稍后...";
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {


        [self handle1NoticeSuccess:api];
        [hud hide:YES];

    } failureBlock:^(BaseRequest * _Nonnull request) {

        [hud hide:YES];

    }];
}

- (void)handle1NoticeSuccess:(GameDownLoadApi *)api {
    if (api.success == 1) {
        self.downLoadURL = api.data[@"url"];
        //        NSURL* nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",self.downLoadURL]];
        NSURL* nsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.downLoadURL]];
        [[UIApplication sharedApplication] openURL:nsUrl];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = api.error_desc;
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.0];
    }
}


- (void)downLoadAction {

    [self getMessageApiRequest];
//    [[UIApplication sharedApplication] openURL: [ NSURL URLWithString:[self.dataDic[@"game_url"] objectForKey:@"ios_url"] ]];
}

- (void)gameDetailApiRequest {

    GameDetailApi *api = [[GameDetailApi alloc] init];
    //    WEAKSELF
    api.gameId = self.gameID;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"请稍后...";
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {

        [hud hide:YES];

        [self handleNoticeSuccess:api];


    } failureBlock:^(BaseRequest * _Nonnull request) {

        [hud hide:YES];

    }];
}

- (void)handleNoticeSuccess:(GameDetailApi *)api {
    if (api.success == 1) {
        self.dataDic = api.data[@"game_info"];
        self.urlStrings = self.dataDic[@"game_ur_list"];
        self.routeURL = [self.dataDic[@"game_url"] objectForKey:@"ios_url"];
        NSArray *array = self.dataDic[@"game_feature_list"];
        if (array.count > 0) {
            NSDictionary *retDic = [array objectAtIndex:0];
//            self.introduce2Height = [self getTextSize:retDic[@"content"] fontSize:15 width:kScreen_width-36].height +106+5;
            self.introduce2Height = [self getTextSize:retDic[@"content"] fontSize:15 width:kScreen_width-36].height +86+5;

            NSLog(@"##@@1122get size.height=%f",[self getTextSize:retDic[@"content"] fontSize:15 width:kScreen_width-36].height);

//            self.introduce2Height = 466.908203;
            NSLog(@"##@@1122introduc 2 with=%f introduc2=%f",kScreen_width-40,self.introduce2Height);

        }

        self.recommendAry = [NSArray arrayWithArray:api.data[@"recommend_info"]];
        self.rowCount = 6;
        if (self.rowCount > 0) {
            [self addDownLoadBtn];
        }
        [self.tableView reloadData];
    }
    else {
        if (self.ifBackImditor && !api.data) {
            [self.navigationController popViewControllerAnimated:YES];
        }

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = api.error_desc;
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.0];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isHaveVIP) {
        //全先生
        if (indexPath.row == 1) {
            return 262;
        }
        else if (indexPath.row == 2) {
            NSLog(@"introduce1Height all show = %f",self.introduce1Height);
            return self.introduce1Height;
//            return 500;

        }
        else if (indexPath.row == 3) {
            NSLog(@"##@@333self.introduce2Height=%f",self.introduce2Height);
            return self.introduce2Height;

        }
        else if (indexPath.row == 4|| indexPath.row == 5) {

            return 70;
        }
        else if (indexPath.row == 6) {
            
            return 149;
        }
        
        return 86;
    }
    else {
        if (indexPath.row == 1) {
            return 262;
        }
        else if (indexPath.row == 2) {
            NSLog(@"introduce1Height all show not= %f",self.introduce1Height);

            return self.introduce1Height;
//            return 500;

        }
        else if (indexPath.row == 3|| indexPath.row == 4) {

            return 70;
        }
        else if (indexPath.row == 5) {
            
            return 149;
        }
        
        return 86;
    }

}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 58;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return self.kaiFuHeaderView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataSource.count;
    if (self.isHaveVIP) {
        return self.rowCount + 1;;
    }
    return self.rowCount;

//    return 5;

}

- (void)changeTabBtn:(NSInteger)index withHeight:(CGFloat)height {
    NSLog(@"index = %d height = %f",index,height);
    if (index>0) {
        self.isHaveVIP = NO;
    }
    else {
        self.isHaveVIP = YES;
    }
    self.introduce1Height = height;

//    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];  //你需要更新的组数中的cell
//    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"changeTabBtn info =%f",self.tableView.contentOffset.y);
    float offset = self.tableView.contentOffset.y;
    [self.tableView reloadData];
    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, offset);
    NSLog(@"changeTabBtn info 333=%f",self.tableView.contentOffset.y);

}
- (void)theCallbackOfClickView:(NSInteger)index {

    NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
//    detailVC.news_id = [self.dataDic[@"game_activity"] objectForKey:@"newid"];
    NSArray *array = self.dataDic[@"game_activity"];
    if (index < array.count) {
        detailVC.news_id = [[array objectAtIndex:index] objectForKey:@"newid"];
    }

    //    detailVC.dataInfoDic = dic;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];

}

- (void)DetailIntroduceCallbackOfClickView:(NSInteger)index {
    [self theCallbackOfClickView:index];
}

- (void)expandPress:(float)hight {
    self.introduce1Height = hight;
    NSLog(@"first hegiht= %f",hight);
//    self.introduce1Height = 300;

    [self.tableView reloadData];

}

- (void)expand2Press:(float)hight {
    self.introduce2Height = hight+5;
    [self.tableView reloadData];

}

- (void)gameRecommendListCellPress:(NSDictionary *)dic {
    [self gameContentTableCellBtn:dic];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (self.isHaveVIP) {
        NSString *identifier = @"DetailTitleTableViewCell";
        if (indexPath.row == 1) {
            identifier = @"DetailScrollTableViewCell";
        }
        else if (indexPath.row == 2) {
            identifier = @"DetailIntroduceTableViewCell";
        }
        else if (indexPath.row == 3) {
            identifier = @"DetailIntroduce2TableViewCell";
        }
        else if (indexPath.row == 4 || indexPath.row == 5) {
            identifier = @"ServiceListTableViewCell";
        }
        else if (indexPath.row == 6 ){
            identifier = @"RecommendListCellTableViewCell";
        }
//        else if (indexPath.row == 6 ){
//            identifier = @"GamesListTableViewCell";
//        }
        //RecommendListCellTableViewCell
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = self.dataDic;
        if (!dic) {
            return cell;
        }
        if (indexPath.row == 4 || indexPath.row == 5 ) {

            ServiceListTableViewCell *cells = (ServiceListTableViewCell *)cell;
            NSString *string = [NSString stringWithFormat:@"%li",indexPath.row];
            [cells setDetailService2ModelDic:@{@"index":string,@"data":dic}];
//            [cells setModelsDic:@{@"index":string,@"data":dic}];
            return cells;
        }
        else if (indexPath.row == 6) {
//            GamesListTableViewCell *cells = (GamesListTableViewCell *)cell;
//            cells.delegate = self;
//            [cells setContentArray:self.recommendAry];
//            return cells;

            RecommendListCellTableViewCell *cells = (RecommendListCellTableViewCell *)cell;
            cells.delegate = self;
            [cells setContentArray:self.recommendAry];
            return cells;
        }
        else if (indexPath.row == 1) {
            DetailScrollTableViewCell *cells = (DetailScrollTableViewCell *)cell;
            cells.delegate = self;
            [cell setModelDic:dic];
        }
        else if (indexPath.row == 2) {
            DetailIntroduceTableViewCell *cells = (DetailIntroduceTableViewCell *)cell;
            cells.currentVC = self;
            cells.delegate = self;
            cells.xl_height = self.introduce1Height;;
            [cell setModelDic:dic];
        }
        else if (indexPath.row == 3) {
            DetailIntroduce2TableViewCell *cells = (DetailIntroduce2TableViewCell *)cell;
            cells.delegate = self;
            [cell setModelDic:dic];
        }
        else {
            [cell setModelDic:dic];
        }
        
        return cell;
    }
    else {
        NSString *identifier = @"DetailTitleTableViewCell";
        if (indexPath.row == 1) {
            identifier = @"DetailScrollTableViewCell";
        }
        else if (indexPath.row == 2) {
            identifier = @"DetailIntroduceTableViewCell";
        }
        else if (indexPath.row == 3 || indexPath.row == 4) {
            identifier = @"ServiceListTableViewCell";
        }
//        else if (indexPath.row == 5 ){
//            identifier = @"GamesListTableViewCell";
//        }
        else if (indexPath.row == 5 ){
            identifier = @"RecommendListCellTableViewCell";
        }
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = self.dataDic;
        if (!dic) {
            return cell;
        }
        if (indexPath.row == 3 || indexPath.row == 4 ) {

            ServiceListTableViewCell *cells = (ServiceListTableViewCell *)cell;
            NSString *string = [NSString stringWithFormat:@"%li",indexPath.row];
            [cells setDetailServiceModelDic:@{@"index":string,@"data":dic}];
//            [cells setModelsDic:@{@"index":string,@"data":dic}];
            return cells;
        }
        else if (indexPath.row == 5) {
            RecommendListCellTableViewCell *cells = (RecommendListCellTableViewCell *)cell;
            cells.delegate = self;
            [cells setContentArray:self.recommendAry];
            return cells;

//            GamesListTableViewCell *cells = (GamesListTableViewCell *)cell;
//            cells.delegate = self;
//            [cells setContentArray:self.recommendAry];
//            return cells;
        }
        else if (indexPath.row == 1) {
            DetailScrollTableViewCell *cells = (DetailScrollTableViewCell *)cell;
            cells.delegate = self;
            [cell setModelDic:dic];
        }
        else if (indexPath.row == 2) {
            DetailIntroduceTableViewCell *cells = (DetailIntroduceTableViewCell *)cell;
            cells.currentVC = self;
            cells.delegate = self;
            [cell setModelDic:dic];
        }
        else {
            [cell setModelDic:dic];
        }
        
        
        return cell;
    }
}

- (void)giftViewPress:(NSInteger)index {
//    index -= 100;
    NSArray *array = self.dataDic[@"gift_bag_list"];
    NSDictionary *dic = [array objectAtIndex:index];
    GiftDetailViewController *vc = [[GiftDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.ifDisplayBtn = YES;
    vc.title = dic[@"packname"];
    vc.news_id = dic[@"packid"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)giftGetPress:(NSInteger)index {
//    index -= 100;
    NSArray *array = self.dataDic[@"gift_bag_list"];
    NSDictionary *dic = [array objectAtIndex:index];
    //领取
    [self getGiftApiRequest:dic[@"packid"]];
}

- (void)getGiftApiRequest:(NSString *)giftId {

    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    if (!userId) {

        LoginViewController *VC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        return;
    }

    GetGiftApi *api = [[GetGiftApi alloc] init];
    //    WEAKSELF
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"请稍后...";
    api.gift_id = giftId;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {

        [hud hide:YES];

        [self handleGiftSuccess:api];


    } failureBlock:^(BaseRequest * _Nonnull request) {

        [hud hide:YES];

    }];
}

- (void)handleGiftSuccess:(GetGiftApi *)api {
    if (api.success == 1) {
//        self.code = api.data[@"data"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = api.data[@"data"];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:api.data[@"data"] delegate:nil cancelButtonTitle:@"复制" otherButtonTitles:nil, nil];
        [alert show];


        self.pageNumber = 1;
//        [self giftApiRequest:@""];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = api.error_desc;
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.0];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"已复制到剪贴板";
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:1.0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)gameContentTableCellBtn:(NSDictionary *)dic {

    GameDetailViewController *detailVC = [[GameDetailViewController alloc] init];
    detailVC.gameID = dic[@"game_id"];
    detailVC.title = dic[@"game_name"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)imageViewPress:(NSInteger)index {
    [self scrollViewTap];
}

- (void)scrollViewTap {
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:0 imageCount:self.urlStrings.count datasource:self];
}
/**
 *  返回指定位置的高清图片URL
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 返回高清大图索引
 */
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:self.urlStrings[index]];
}

- (UITableView *)tableView {
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreen_width, kScreen_height-kStatusBarAndNavigationBarHeight-55) style:UITableViewStylePlain];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailTitleTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"DetailTitleTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailScrollTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"DetailScrollTableViewCell"];
        //DetailIntroduce2TableViewCell
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailIntroduceTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"DetailIntroduceTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailIntroduce2TableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"DetailIntroduce2TableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ServiceListTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"ServiceListTableViewCell"];

        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GamesListTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"GamesListTableViewCell"];

        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecommendListCellTableViewCell class]) bundle:nil]
         forCellReuseIdentifier:@"RecommendListCellTableViewCell"];
    }
    return _tableView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGSize)getTextSize:(NSString *)text fontSize:(float)size width:(CGFloat)width{
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:size];
    titleLabel.text = text;
    titleLabel.numberOfLines = 0;//多行显示，计算高度
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    return titleSize;
}
@end
