//
//  MyLimitedBuyingController.m
//  Game789
//
//  Created by Maiyou on 2021/1/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyLimitedBuyingController.h"
#import "MyLimitedBuyingCell.h"
#import "MyLimitedBuyTitleCell.h"
#import "MySignedRuleView.h"
#import "MyLimitedBuyingGiftCell.h"
#import "MyLimitedBuyGetCoinView.h"
#import "MyLimitedBuyingFooterView.h"

#import "MyLimitedBuyingApi.h"

@interface MyLimitedBuyingController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *showName;
@property (weak, nonatomic) IBOutlet UILabel *showCoin;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *titleCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImg_top;
@property (weak, nonatomic) IBOutlet UIImageView *showMemberIcon;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation MyLimitedBuyingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self basicPrepare];
    
    [self loadData];
    
    [self getLimitedBuyData:YES Complete:nil];
}

- (void)basicPrepare
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    WEAKSELF
    self.navBar.title = @"限时抢购";
    self.navBar.backgroundColor = UIColor.clearColor;
    self.navBar.titleLable.textColor = ColorWhite;
    [self.navBar wr_setLeftButtonWithImage:MYGetImage(@"back-1")];
    self.navBar.lineView.hidden = YES;
    [self.navBar wr_setRightButtonWithTitle:@"活动规则" titleColor:ColorWhite];
    self.navBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.navBar setOnClickRightButton:^{
        [weakSelf ruleAlertView];
    }];
    
    self.selectedIndex = 0;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyLimitedBuyingCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyLimitedBuyingCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyLimitedBuyingGiftCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyLimitedBuyingGiftCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyLimitedBuyingFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MyLimitedBuyingFooterView"];
    
    self.titleCollectionView.delegate   = self;
    self.titleCollectionView.dataSource = self;
    [self.titleCollectionView registerNib:[UINib nibWithNibName:@"MyLimitedBuyTitleCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyLimitedBuyTitleCell"];
}

- (void)getLimitedBuyData:(BOOL)isShow Complete:(RequestData)block
{
    MyLimitedBuyingApi * api = [[MyLimitedBuyingApi alloc] init];
    api.isShow = isShow;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(YES);
        if (request.success == 1)
        {
            self.dataArray = request.data[@"list"];
            [self.titleCollectionView reloadData];
            
            //如果当前时间不在火热兑换中，就滚动到即将开抢
            NSInteger count = 0;
            for (int i = 0; i < self.dataArray.count; i ++)
            {
                NSDictionary * dic = [self.dataArray[i] deleteAllNullValue];
                if ([dic[@"status_info"] containsString:@"抢购中"])
                {
                    count ++;
                    if (isShow)
                    {
                        NSInteger dataCount = self.dataArray.count;
                        NSInteger index = 0;
                        if (i - 1 >= 0 && i + 1 <= dataCount - 1)
                        {
                            index = i - 1;
                        }
                        else
                        {
                            index = i;
                        }
                        self.selectedIndex = i;
                        [self.titleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                    }
                    break;
                }
            }
            //滚动到即将开抢
            if (count == 0)
            {
                for (int i = 0; i < self.dataArray.count; i ++)
                {
                    NSDictionary * dic = self.dataArray[i];
                    if ([dic[@"status_info"] containsString:@"即将开抢"])
                    {
                        if (isShow)
                        {
                            NSInteger dataCount = self.dataArray.count;
                            NSInteger index = 0;
                            if (i - 1 >= 0 && i + 1 <= dataCount - 1)
                            {
                                index = i - 1;
                            }
                            else
                            {
                                index = i;
                            }
                            self.selectedIndex = i;
                            [self.titleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                        }
                        break;
                    }
                }
            }
            [self.collectionView reloadData];
            
            NSDictionary * dic = request.data[@"user_info"];
            [self.userIcon yy_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholder:MYGetImage(@"avatar_default")];
            self.showName.text = dic[@"username"];
            self.showCoin.text = [NSString stringWithFormat:@"我的金币：%@个", [NSNumber numberWithFloat:[dic[@"balance"] floatValue]]];
            self.showMemberIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%@", dic[@"vip_level"]]];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
        [MBProgressHUD showToast:request.error_desc toView:self.view];
    }];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
/**  分区个数  */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/** 每个分区item的个数  */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionView)
    {
        return self.dataArray.count > 0 ? [self.dataArray[self.selectedIndex][@"items"] count] : 0;
    }
    return self.dataArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView)
    {
        NSDictionary * dic = self.dataArray[self.selectedIndex][@"items"][indexPath.item];
        if ([dic[@"type"] integerValue] == 1)
        {
            static NSString *cellIndentifer = @"MyLimitedBuyingCell";
            MyLimitedBuyingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
            NSString * name = [NSString stringWithFormat:@"limited_cell_bg%ld", indexPath.row % 4];
            cell.showBgImage.image = MYGetImage(name);
            cell.dataDic = dic;
            cell.receivedActionBlock = ^{
                [self getLimitedBuyData:NO Complete:nil];
            };
            cell.exchangeTime = self.dataArray[self.selectedIndex][@"show_time"];
            return cell;
        }
        else
        {
            static NSString *cellIndentifer = @"MyLimitedBuyingGiftCell";
            MyLimitedBuyingGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
            cell.dataDic = dic;
            cell.receivedActionBlock = ^{
                [self getLimitedBuyData:NO Complete:nil];
            };
            cell.exchangeTime = self.dataArray[self.selectedIndex][@"show_time"];
            return cell;
        }
    }
    else
    {
        static NSString *cellIndentifer = @"MyLimitedBuyTitleCell";
        MyLimitedBuyTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
        cell.dataDic = self.dataArray[indexPath.item];
        if (indexPath.item == self.selectedIndex)
        {
            cell.showStatus.textColor = [UIColor colorWithHexString:@"#FF604E"];
            cell.showStatus.backgroundColor = ColorWhite;
        }
        else
        {
            cell.showStatus.textColor = [UIColor colorWithHexString:@"#FEFEFF"];
            cell.showStatus.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.collectionView)
    {
        return CGSizeMake((collectionView.width - 0.5) / 2, 175);
    }
    return CGSizeMake(collectionView.width /3, collectionView.height);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**  分区内cell之间的最小行间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.collectionView)
    {
        return 0.5;
    }
    return 0;
}

/**  分区内cell之间的最小列间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.collectionView)
    {
        return 0.5;
    }
    return 0;
}

//footer的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (collectionView == self.collectionView)
    {
        return CGSizeMake(kScreenW, 66);
    }
    return CGSizeZero;
}

//header 和 footer的获取逻辑
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    if([kind isEqualToString:UICollectionElementKindSectionFooter] && collectionView == self.collectionView)
    {
        MyLimitedBuyingFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"MyLimitedBuyingFooterView" forIndexPath:indexPath];
        view = footerView;
    }
    return view;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%ld分item", (long)indexPath.item);
    
    if (collectionView == self.titleCollectionView && self.selectedIndex != indexPath.item)
    {
        MyLimitedBuyTitleCell *cell = (MyLimitedBuyTitleCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.showStatus.textColor = [UIColor colorWithHexString:@"#FF604E"];
        cell.showStatus.backgroundColor = ColorWhite;
        
        MyLimitedBuyTitleCell *cell1 = (MyLimitedBuyTitleCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
        cell1.showStatus.textColor = [UIColor colorWithHexString:@"#FEFEFF"];
        cell1.showStatus.backgroundColor = [UIColor clearColor];
        
        self.selectedIndex = indexPath.item;
        [self.collectionView reloadData];
    }
}

- (void)ruleAlertView
{
    NSString * ruleStr = @"1.玩家可使用金币兑换代金券和游戏礼包，每个时段可兑换数量有限，先到先得，一经兑换金币不予退还；\n2.成为会员可享受超低折扣兑换代金券和游戏礼包，所需金币以代金券和礼包详情为主；\n3.兑换完成后，奖品自动发放至当前账户，代金券请前往我的-代金券处查看，礼包前往我的-我的礼包处查看；\n4.兑换所得代金券和礼包均有时间限制，请在时间限制内使用，过期不再补发；\n5.活动期间如有违规行为（包括但不限于恶意抢兑等），将进行封号处理；\n6.兑换的奖品不限于代金券和礼包，后期会不断更新，敬请期待！";
    MySignedRuleView * ruleView = [[MySignedRuleView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    ruleView.showTitle.text = @"活动规则";
    ruleView.textView.text = ruleStr.localized;
    [self.view addSubview:ruleView];
}

- (IBAction)getCoinAlertView:(id)sender
{
    MyLimitedBuyGetCoinView * getCoinView = [[MyLimitedBuyGetCoinView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:getCoinView];
}

- (void)loadData
{
    __unsafe_unretained UICollectionView *collectionView = self.collectionView;
    // 下拉刷新
    collectionView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [collectionView.mj_footer resetNoMoreData];
        self.pageNumber = 1;
        [self getLimitedBuyData:NO Complete:^(BOOL isSuccess) {
            [collectionView.mj_header endRefreshing];
        }];
    }];
}

@end
