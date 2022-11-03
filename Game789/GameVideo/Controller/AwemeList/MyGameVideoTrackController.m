//
//  MyGameVideoTrackController.m
//  Game789
//
//  Created by Maiyou on 2020/4/9.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameVideoTrackController.h"
#import "MyGameVideoTrackCell.h"
#import "MyAllGameVideosApi.h"
#import "AwemeListController.h"

@interface MyGameVideoTrackController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation MyGameVideoTrackController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back-1")];
    self.navBar.title = @"足迹";
    self.navBar.titleLable.textColor = UIColor.whiteColor;
    self.navBar.backgroundColor = [UIColor clearColor];
    
    [self loadData];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)getAllGameVideosList:(RequestData)block
{
    __weak __typeof(self) wself = self;
    MyAllGameVideosApi * api = [[MyAllGameVideosApi alloc] init];
    api.isTrack = @"1";
    api.pageNumber = self.pageNumber;
    api.count = 20;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        block(YES);
        if (request.success == 1)
        {
            NSArray * array = request.data[@"game_list"];
            array = [Aweme mj_objectArrayWithKeyValuesArray:array];
            if (wself.pageNumber == 1)
            {
                wself.dataArray = [[NSMutableArray alloc] initWithArray:array];
            }
            else
            {
                [wself.dataArray addObjectsFromArray:array];
            }
            NSDictionary *dic = request.data[@"paginated"];
            if (wself.dataArray.count >= [dic[@"total"] integerValue])
            {
                [wself.collectionView.mj_footer endRefreshingWithNoMoreData];
                wself.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
            }
            wself.collectionView.ly_emptyView.contentView.hidden = NO;
            [wself.collectionView reloadData];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:wself.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        block(NO);
    }];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView  alloc]initWithFrame:CGRectMake(8, kStatusBarAndNavigationBarHeight, kScreenW - 16, kScreenH - kStatusBarAndNavigationBarHeight) collectionViewLayout:layout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"track_no_data" titleStr:@"暂时没有视频数据哦～" detailStr:@""];
        _collectionView.ly_emptyView.titleLabTextColor = [UIColor colorWithHexString:@"#999999"];
        _collectionView.ly_emptyView.contentView.hidden = YES;
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MyGameVideoTrackCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyGameVideoTrackCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
/** 分区个数 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

/** 每个分区item的个数  */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"MyGameVideoTrackCell";
    MyGameVideoTrackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    cell.aweme = self.dataArray[indexPath.item];
    return cell;
}

/**
 cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenW - 8 - 16) / 2, 185);
}

/**
 每个分区的内边距（上左下右）
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**
 分区内cell之间的最小行间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

/**
 分区内cell之间的最小列间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArray[indexPath.item];
    NSLog(@"点击了第%ld分item, %@",(long)indexPath.item, dic);
    
    AwemeListController * list = [AwemeListController new];
    list.hidesBottomBarWhenPushed = YES;
//    list.data = self.dataArray;
    list.isTrack = YES;
    list.pageIndex = self.pageNumber;
    list.currentIndex = indexPath.item;
    [self.navigationController pushViewController:list animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)loadData
{
    __unsafe_unretained UICollectionView *collectionView = self.collectionView;
    // 下拉刷新
    collectionView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [collectionView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getAllGameVideosList:^(BOOL isSuccess) {
            [collectionView.mj_header endRefreshing];
        }];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    collectionView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    collectionView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getAllGameVideosList:^(BOOL isSuccess) {
            [collectionView.mj_footer endRefreshing];
        }];
    }];
}

@end
