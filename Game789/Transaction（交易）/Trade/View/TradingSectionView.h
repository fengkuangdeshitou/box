//
//  TradingSectionView.h
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGXPopoverView.h"
#import "MyTradeFliterView.h"

@protocol TradingSectionViewDelegate <NSObject>

- (void)searchTradeGame:(NSString *)text;
- (void)selectSortType:(NSInteger)index;
- (void)fliterRefreshData;
- (void)tradingStyleChange:(BOOL)more;
- (void)tradingPriceRange:(NSString *)trade_price_range;

@end

@interface TradingSectionView : UIView <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *selectedTitle;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIImageView *downImageView;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchBtn_width;
@property (nonatomic , strong) CGXPopoverManager *manager;
@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, weak) id<TradingSectionViewDelegate>delegate;
@property (nonatomic, strong) NSArray * gameTypeArr;
@property (nonatomic, assign) BOOL hiddenPriceRang;
@property (nonatomic, strong) UIButton * selectedBtn;

/**  1：BT 2:折扣 3：H5 4:GM，默认不传取全部  */
@property (nonatomic, copy) NSString * game_species_type;
/** 0:双端 1：ios 2：Android，默认不传取全部 */
@property (nonatomic, copy) NSString *game_device_type;
/**  价格区域  */
@property (nonatomic, copy) NSString *trade_price_range;
/** 游戏类型id  筛选游戏类型 */
@property (nonatomic, copy) NSString *game_classify_id;

@end
