//
//  TradingHeaderView.m
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "TradingHeaderView.h"
#import "TransactionDynamicsViewController.h"
#import "SellingAccountViewController.h"
#import "TransactionRecordViewController.h"
#import "BindMobileViewController.h"
#import "TradingNoticeViewController.h"
#import "MyTrumpetRecyclingController.h"
#import "ModifyNameViewController.h"
#import "MyTradeOfficialSelectionCell.h"
#import "MyTradeFliterViewController.h"
#import "ProductDetailsViewController.h"
#import "MyCustomerServiceController.h"

@implementation TradingHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"MyTradeOfficialSelectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"MyTradeOfficialSelectionCell"];
}

- (void)setButtonImage
{
    for (int i = 0; i < 5; i ++)
    {
        UIButton * button = [self viewWithTag:100 + i];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:15];
    }
}


- (IBAction)topButtonAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    switch (button.tag) {
        case 100:
        {
//            if (![YYToolModel islogin])
//            {
//                [self pushLogin];
//                return;
//            }
//            NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
//            if (dic == NULL || [dic[@"mobile"] isEqualToString:@""])
//            {
//                BindMobileViewController * bind = [BindMobileViewController new];
//                bind.hidesBottomBarWhenPushed = YES;
//                [self.currentVC.navigationController pushViewController:bind animated:YES];
//                return;
//            }
//            if (dic == NULL || [dic[@"real_name"] isEqualToString:@""] || [dic[@"identity_card"] isEqualToString:@""])
//            {
//                ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
//                bindVC.title = @"实名认证".localized;
//                bindVC.hidesBottomBarWhenPushed = YES;
//                [self.currentVC.navigationController pushViewController:bindVC animated:YES];
//                return;
//            }
//            MyTrumpetRecyclingController * recycle = [MyTrumpetRecyclingController new];
//            recycle.hidesBottomBarWhenPushed = YES;
//            [self.currentVC.navigationController pushViewController:recycle animated:YES];
        }
            break;
        case 101:
        {
            TradingNoticeViewController * notice = [TradingNoticeViewController new];
            notice.hidesBottomBarWhenPushed = YES;
            [self.currentVC.navigationController pushViewController:notice animated:YES];
        }
            break;
        case 102:
        {
            if (![YYToolModel islogin])
            {
                [self pushLogin];
                return;
            }
            NSDictionary * dic = [YYToolModel getUserdefultforKey:@"member_info"];
            if (dic == NULL || [dic[@"mobile"] isEqualToString:@""])
            {
                BindMobileViewController * bind = [BindMobileViewController new];
                bind.hidesBottomBarWhenPushed = YES;
                [self.currentVC.navigationController pushViewController:bind animated:YES];
                return;
            }
            SellingAccountViewController * sell = [SellingAccountViewController new];
            sell.hidesBottomBarWhenPushed = YES;
            sell.finish = ^(BOOL isTrading) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadDataTradeStatus" object:nil];
            };
            [self.currentVC.navigationController pushViewController:sell animated:YES];
        }
            break;
        case 103:
        {
            if (![YYToolModel islogin])
            {
                [self pushLogin];
                return;
            }
            TransactionRecordViewController * transaction = [TransactionRecordViewController new];
            transaction.hidesBottomBarWhenPushed = YES;
            [self.currentVC.navigationController pushViewController:transaction animated:YES];
        }
            
            break;
        case 104:
        {
            MyCustomerServiceController *webVC = [[MyCustomerServiceController alloc] init];
            webVC.hidesBottomBarWhenPushed = YES;
            [self.currentVC.navigationController pushViewController:webVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)pushLogin
{
    LoginViewController * login = [LoginViewController new];
    login.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:login animated:YES];
}

- (IBAction)moreButtonClick:(id)sender
{
    MyTradeFliterViewController * fliter = [MyTradeFliterViewController new];
    fliter.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:fliter animated:YES];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
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
    return self.dataArray.count > 5 ? 5 : self.dataArray.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"MyTradeOfficialSelectionCell";
    MyTradeOfficialSelectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyTradeOfficialSelectionCell" owner:self options:nil].firstObject;
    }
    cell.listModel = self.dataArray[indexPath.item];
    return cell;
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(228, collectionView.height);
}

/**  每个分区的内边距（上左下右） */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**  分区内cell之间的最小行间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

/**  分区内cell之间的最小列间距  */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TradingListModel * model = self.dataArray[indexPath.item];
    [MyAOPManager relateStatistic:@"ClickTradeGameDetails" Info:@{@"gameName":model.game_name, @"price":model.trade_price}];
    ProductDetailsViewController * product = [ProductDetailsViewController new];
    product.hidesBottomBarWhenPushed = YES;
    product.trade_id = model.trade_id;
    [self.currentVC.navigationController pushViewController:product animated:YES];
}

@end
