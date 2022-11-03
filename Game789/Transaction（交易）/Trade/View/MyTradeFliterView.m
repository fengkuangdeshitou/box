//
//  MyTradeFliterView.m
//  Game789
//
//  Created by Maiyou on 2020/4/2.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTradeFliterView.h"
#import "MyGameTypeCollectionViewCell.h"

#define CellBtnWidth (kScreenW - 25 * 2 - 16 * (4 - 1)) / 4
#define SelectNormalColor [UIColor colorWithHexString:@"#EDEDED"]

@implementation MyTradeFliterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyTradeFliterView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        [self prepareBasic];
        [self creatViewCorner];
        [self showView];
    }
    return self;
}

- (void)setHiddenPriceRang:(BOOL)hiddenPriceRang{
    if (hiddenPriceRang) {
        self.cateTop.constant = 25;
        self.cateTopView.hidden = false;
    }
}

- (void)prepareBasic
{
    self.backgroundColor = [UIColor whiteColor];
    self.btn_width.constant = CellBtnWidth;
    
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerNib:[UINib nibWithNibName:@"MyGameTypeCollectionViewCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"MyGameTypeCollectionViewCell"];
}

- (void)creatViewCorner
{
    CGRect frame = CGRectMake(0, 0, kScreenW, self.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20,20)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setGameTypeArr:(NSArray *)gameTypeArr
{
    _gameTypeArr = gameTypeArr;
    
    if (gameTypeArr)
    {
        [self.collection reloadData];
    }
    
    //游戏专区
    if (self.game_species_type)
    {
        UIButton * button = [self viewWithTag:self.game_species_type.integerValue == 0 ? 10 : self.game_species_type.integerValue * 10];
        button.selected = YES;
        button.backgroundColor = MAIN_COLOR;
        self.speciesSelectedBtn = button;
    }
    else
    {
        UIButton * button = [self viewWithTag:10];
        button.selected = YES;
        button.backgroundColor = MAIN_COLOR;
        self.speciesSelectedBtn = button;
    }
    //设备
    if (self.game_device_type)
    {
        UIButton * button = [self viewWithTag:self.game_device_type.integerValue == 0 ? 300 : self.game_device_type.integerValue * 100];
        button.selected = YES;
        button.backgroundColor = MAIN_COLOR;
        self.deviceSelectedBtn = button;
    }
    else
    {
        UIButton * button = [self viewWithTag:200];
        button.selected = YES;
        button.backgroundColor = MAIN_COLOR;
        self.deviceSelectedBtn = button;
    }
    //价格
    if (![self.trade_price_range isEqualToString:@"-"] && [self.trade_price_range containsString:@"-"])
    {
        NSArray * array = [self.trade_price_range componentsSeparatedByString:@"-"];
        self.lowestPrice.text = array[0];
        self.highestPrice.text = array[1];
    }
}

- (void)setBackView:(UIView *)backView
{
    _backView = backView;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    tap.delegate = self;
    [self.backView addGestureRecognizer:tap];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self])
    {
        return NO;
    }
    return YES;
}

- (void)showView
{
    [UIView animateWithDuration:0.26 animations:^{
        self.y = kScreenH - self.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissView
{
    [UIView animateWithDuration:0.26 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor clearColor];
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}

#pragma mark — 选择设备类型
- (IBAction)deviceTypeClick:(id)sender
{
    UIButton * button = sender;
    [self deviceTypeChangeStatus:button];
}
#pragma mark — 选择游戏类型
- (IBAction)gameSpeciesClick:(id)sender
{
    UIButton * button = sender;
    [self gameSpeciesChangeStatus:button];
}
#pragma mark — 重置选择
- (IBAction)resetButtonAction:(id)sender
{
    self.lowestPrice.text = @"";
    self.highestPrice.text = @"";
    [self gameClassifyChangeStatus:[NSIndexPath indexPathForItem:0 inSection:0]];
    UIButton * deviceBtn = [self viewWithTag:200];
    [self deviceTypeChangeStatus:deviceBtn];
    UIButton * speciesBtn = [self viewWithTag:10];
    [self gameSpeciesChangeStatus:speciesBtn];
}
#pragma mark — 确定筛选
- (IBAction)sureButtonAction:(id)sender
{
    NSString * trade_price_type = [NSString stringWithFormat:@"%@-%@", self.lowestPrice.text, self.highestPrice.text];
    if (!self.lowestPrice.text && self.highestPrice.text)
    {
        trade_price_type = [NSString stringWithFormat:@"%@-%@", @"0", self.highestPrice.text];
    }
    else if (self.lowestPrice.text && !self.highestPrice.text)
    {
        [MBProgressHUD showToast:@"请输入最高价格" toView:self.backView];
        return;
    }
    else if (self.lowestPrice.text.floatValue > self.highestPrice.text.floatValue)
    {
        [MBProgressHUD showToast:@"最低价格需小于最高价格" toView:self.backView];
        return;
    }
    if (self.gameTradeFliterBlock)
    {
        NSString * game_species_type = [NSString stringWithFormat:@"%ld", self.speciesSelectedBtn.tag / 10];
        NSString * game_device_type = [NSString stringWithFormat:@"%ld", self.deviceSelectedBtn.tag / 100];
        game_device_type = game_device_type.intValue == 3 ? @"0" : game_device_type;
        NSString * game_classify_id = self.gameTypeArr[self.game_classify_tag % 200][@"game_classify_id"];
        self.gameTradeFliterBlock(game_species_type, game_device_type, trade_price_type, game_classify_id);
        
        [self dismissView];
    }
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
    return self.gameTypeArr.count;
}

/**  创建cell  */
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifer = @"MyGameTypeCollectionViewCell";
    MyGameTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifer forIndexPath:indexPath];
    NSDictionary * dic = self.gameTypeArr[indexPath.item];
    cell.showText.text = dic[@"game_classify_name"];
    cell.showText.tag = indexPath.item + 200;
    if ([dic[@"game_classify_id"] isEqualToString:self.game_classify_id])
    {
        cell.showText.backgroundColor = MAIN_COLOR;
        cell.showText.textColor = [UIColor whiteColor];
        self.game_classify_tag = indexPath.item + 200;
    }
    else
    {
        cell.showText.textColor = [UIColor colorWithHexString:@"#282828"];
        cell.showText.backgroundColor = SelectNormalColor;
    }
    return cell;
}

/**  cell的大小  */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CellBtnWidth, 30);
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

/**
 点击某个cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self gameClassifyChangeStatus:indexPath];
}

//修改设备类型状态
- (void)deviceTypeChangeStatus:(UIButton *)button
{
    if (button != self.deviceSelectedBtn)
    {
        button.selected = YES;
        button.backgroundColor = MAIN_COLOR;
        self.deviceSelectedBtn.selected = NO;
        self.deviceSelectedBtn.backgroundColor = SelectNormalColor;
        self.deviceSelectedBtn = button;
    }
}

//修改游戏类型状态
- (void)gameSpeciesChangeStatus:(UIButton *)button
{
    if (button != self.speciesSelectedBtn)
    {
        button.selected = YES;
        button.backgroundColor = MAIN_COLOR;
        self.speciesSelectedBtn.selected = NO;
        self.speciesSelectedBtn.backgroundColor = SelectNormalColor;
        self.speciesSelectedBtn = button;
    }
}

//修改游戏分类状态
- (void)gameClassifyChangeStatus:(NSIndexPath *)indexPath
{
    NSInteger index = self.game_classify_tag % 200;
    if (indexPath.item != index)
    {
        MyGameTypeCollectionViewCell *cell = (MyGameTypeCollectionViewCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:0]];
        cell.showText.backgroundColor = MAIN_COLOR;
        cell.showText.textColor = [UIColor whiteColor];
        
        MyGameTypeCollectionViewCell *cell1 = (MyGameTypeCollectionViewCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        cell1.showText.textColor = [UIColor colorWithHexString:@"#282828"];
        cell1.showText.backgroundColor = SelectNormalColor;
        
        self.game_classify_tag = indexPath.item + 200;
    }
}

@end
