//
//  HGGameTypesViewController.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/6/5.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameTypesViewController.h"
#import "BTCoverVerticalTransition.h"

#import "MyGameTypeCollectionViewCell.h"
#import "HGGameTypesTitleReusableView.h"

#import "GetGameListApi.h"

#define CellBtnWidth (kScreenW - 25 * 2 - 16 * (4 - 1)) / 4

@interface MyGameTypesViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) BTCoverVerticalTransition *aniamtion;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, assign) NSInteger selectedSectionRow;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIView * bottomView;

@end

@implementation MyGameTypesViewController

- (instancetype)init
{
    if ([super init])
    {
        _aniamtion = [[BTCoverVerticalTransition alloc]initPresentViewController:self withRragDismissEnabal:YES];
        self.transitioningDelegate = _aniamtion;
    }
    return self;
}

- (void)getGameTypes
{
    GetGameListApi *api = [[GetGameListApi alloc] init];
    api.pageNumber = 1;
    api.count = 500;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handleGameTypeListSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handleGameTypeListSuccess:(GetGameListApi *)api
{
    if (api.success == 1)
    {
        self.dataArray = [self allTitles:api.data[@"game_classify_list"]];
        for (int i = 0; i < self.dataArray.count; i ++)
        {
            NSDictionary * dic = self.dataArray[i];
            if ([dic[@"game_classify_id"] isEqualToString:self.game_classify_id])
            {
                self.selectedSectionRow = i;
                break;
            }
        }
        [self.collectionView reloadData];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }
}

#pragma mark
- (NSArray *)allTitles:(NSArray *)arrayTitle
{
    NSMutableArray * titleArr = [NSMutableArray array];
    //获取类型
    for (int i = 0; i < arrayTitle.count; i++)
    {
        [titleArr addObjectsFromArray:arrayTitle[i][@"sub_classify_list"][0]];
    }
    [titleArr insertObject:@{@"game_classify_id":@"", @"game_classify_name":@"全部".localized} atIndex:0];
    return titleArr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.hidden = YES;
    self.view.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:1];
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake((self.view.width - 35) / 2 , 30, 35, 5)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#ACACAC"];
    topView.layer.cornerRadius = topView.height / 2;
    topView.layer.masksToBounds = YES;
    [self.view addSubview:topView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getGameTypes];
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(25, 45, self.view.width - 50, self.view.height - 45 - kTabbarSafeBottomMargin) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"MyGameTypeCollectionViewCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"MyGameTypeCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HGGameTypesTitleReusableView class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HGGameTypesTitleReusableView"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
/**  分区个数  */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/** 每个分区item的个数  */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"MyGameTypeCollectionViewCell";
    MyGameTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    NSDictionary * dic = self.dataArray[indexPath.item];
    cell.showText.text = dic[@"game_classify_name"];
    if (self.selectedSectionRow >= 0)
    {
        if (indexPath.item == self.selectedSectionRow)
        {
            cell.showText.backgroundColor = MAIN_COLOR;
            cell.showText.textColor = UIColor.whiteColor;
        }
        else
        {
            cell.showText.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
            cell.showText.textColor = [UIColor colorWithHexString:@"#282828"];
        }
    }
    else
    {
        cell.showText.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        cell.showText.textColor = [UIColor colorWithHexString:@"#282828"];
    }
    
    return cell;
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CellBtnWidth, 32);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**  分区内cell之间的最小行间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

/**  分区内cell之间的最小列间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 16;
}

/**  创建区头视图和区尾视图  */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader)
    {
        HGGameTypesTitleReusableView *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HGGameTypesTitleReusableView" forIndexPath:indexPath];
        sectionView.showTitle.text = @"游戏分类";
        return sectionView;
    }
    return nil;
}

/**
 区头大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenW, 50);
}


/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedSectionRow != indexPath.item)
    {
        if (self.SureBtnClick)
        {
            self.SureBtnClick(self.dataArray[indexPath.item]);
        }
        self.selectedSectionRow = indexPath.item;
        [self.collectionView reloadData];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    // 适配屏幕，横竖屏
    self.preferredContentSize = CGSizeMake(self.view.bounds.size.width, 400);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
}

/// 屏幕旋转时调用的方法
/// @param newCollection 新的方向
/// @param coordinator 动画协调器
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)dealloc{
    NSLog(@"!!~~");
}

@end
