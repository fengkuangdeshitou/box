//
//  TradingSectionView.m
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "TradingSectionView.h"
#import "GetGameListApi.h"

@interface TradingSectionView ()

@property(nonatomic,weak)IBOutlet UIView * contentView;

@end

@implementation TradingSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"TradingSectionView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.searchText.delegate = self;
        
        CGFloat width = (ScreenWidth-30-8*3)/4;
        NSArray * array = @[@"6-20元",@"20-50元",@"50-100元",@"100元以上"];
        for (int i=0;i<array.count;i++){
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((width+8)*i+15, 0, width, 30);
            [btn setTitle:array[i] forState:UIControlStateNormal];
            btn.tag = i+10;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.layer.cornerRadius = 15;
            [btn setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:UIControlStateNormal];
            btn.backgroundColor = UIColor.whiteColor;
            btn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
            btn.layer.borderWidth = 0.5;
            [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
        }
                
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectButtonAction)];
        [self.backView addGestureRecognizer:tap];
        
        [self gameTypeRequest];
    }
    return self;
}

- (void)btnclick:(UIButton *)btn
{
    if (self.selectedBtn == btn)
    {
        [btn setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:UIControlStateNormal];
        btn.backgroundColor = UIColor.whiteColor;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        btn.layer.borderWidth = 0.5;
        
        self.selectedBtn = nil;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(tradingPriceRange:)]){
            [self.delegate tradingPriceRange:@"0-9999999"];
        }
    }
    else
    {
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.backgroundColor = MAIN_COLOR;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        btn.layer.borderWidth = 0;
        
        [self.selectedBtn setTitleColor:[UIColor colorWithHexString:@"#282828"] forState:UIControlStateNormal];
        self.selectedBtn.backgroundColor = UIColor.whiteColor;
        self.selectedBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        self.selectedBtn.layer.borderWidth = 0.5;
        
        self.selectedBtn = btn;
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(tradingPriceRange:)]){
            if ([btn.titleLabel.text rangeOfString:@"-"].location==NSNotFound) {
                [self.delegate tradingPriceRange:@"101-9999999"];
            }else{
                [self.delegate tradingPriceRange:[btn.titleLabel.text substringToIndex:btn.titleLabel.text.length-1]];
            }
        }
    }
}

- (IBAction)styleChange:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tradingStyleChange:)]){
        [self.delegate tradingStyleChange:sender.selected];
    }
}

- (NSArray *)allItems
{
    NSArray *arr1 = @[@"最新发布".localized, @"性价比高".localized, @"价格升序".localized, @"价格降序".localized];
    NSMutableArray * actionAry = [NSMutableArray array];
    for (int i = 0; i < arr1.count; i++)
    {
        CGXPopoverItem *action1 = [CGXPopoverItem actionWithImage:[UIImage imageNamed:@""] Title:arr1[i] IsSelect:YES];
        action1.alignment = NSTextAlignmentCenter;
        [actionAry addObject:action1];
    }
    return actionAry;
}

- (void)selectButtonAction
{
    if (self.indexPath)
    {
        self.manager.selectIndexPath = self.indexPath;
    }
    WEAKSELF
    CGXPopoverView *popoverView = [[CGXPopoverView alloc] initWithFrame:CGRectNull WithManager:self.manager];
    [popoverView showToView:self.downImageView SelectItem:^(CGXPopoverItem *item, NSIndexPath *indexPath) {
        NSLog(@"%@--action2:%@" , indexPath,item.title);
        weakSelf.indexPath = indexPath;
        weakSelf.selectedTitle.text = item.title;
        if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(selectSortType:)])
        {
            [weakSelf.delegate selectSortType:indexPath.row];
        }
    }];
}

- (CGXPopoverManager *)manager
{
    if (!_manager)
    {
        _manager = [CGXPopoverManager new];
        _manager.selectTitleColor = [UIColor colorWithHexString:@"#FEAA51"];
        _manager.style = CGXPopoverManagerItemDefault;
        _manager.showShade = NO;
        _manager.isAnimate = YES;
        _manager.hideAfterTouchOutside = YES;
        _manager.modleArray = [NSMutableArray arrayWithArray:[self allItems]];
        _manager.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _manager.arrowStyle = CGXPopoverManagerArrowStyleTriangle;
    }
    return _manager;
}

- (IBAction)filterButtonAction:(id)sender
{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [[UIApplication sharedApplication].delegate.window addSubview:backView];
    
    CGFloat height = kScreenH * 7.5 / 10;
    if (IS_iPhone_Plus || IS_iPhone_Normal || IS_iPhone_5) {
        height = kScreenH * 9 / 10;
    } else if (IS_iPhoneX){
        height = kScreenH * 8.5 / 10;
    }
    MyTradeFliterView * fliterView = [[MyTradeFliterView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, height)];
    fliterView.game_classify_id = self.game_classify_id == nil ? @"" : self.game_classify_id;
    fliterView.game_device_type = self.game_device_type;
    fliterView.game_species_type = self.game_species_type;
    fliterView.trade_price_range = self.trade_price_range;
    fliterView.backView = backView;
    fliterView.hiddenPriceRang = self.hiddenPriceRang;
    fliterView.gameTypeArr = self.gameTypeArr;
    [backView addSubview:fliterView];
    
    WEAKSELF
    fliterView.gameTradeFliterBlock = ^(NSString * _Nonnull game_species_type, NSString * _Nonnull game_device_type, NSString * _Nonnull trade_price_range, NSString * _Nonnull game_classify_id) {
        weakSelf.game_species_type = game_species_type;
        weakSelf.game_device_type  = game_device_type;
        weakSelf.trade_price_range = [trade_price_range isEqualToString:@"-"] ? @"" : trade_price_range;
        weakSelf.game_classify_id  = game_classify_id;
        if (weakSelf.delegate && [self.delegate respondsToSelector:@selector(fliterRefreshData)])
        {
            [weakSelf.delegate fliterRefreshData];
        }
    };
}

- (IBAction)searchButtonAction:(id)sender
{
//    if (self.searchText.text.length == 0)
//        return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTradeGame:)])
    {
        [self.delegate searchTradeGame:self.searchText.text];
    }
}

- (void)gameTypeRequest
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
        self.gameTypeArr = [self allTitles:api.data[@"game_classify_list"]];
    }
    else
    {
        [MBProgressHUD showToast:api.error_desc toView:self.currentVC.view];
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

#pragma mark — UITextfieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchTradeGame:)])
    {
        [self.delegate searchTradeGame:@""];
    }
    return YES;
}

@end
