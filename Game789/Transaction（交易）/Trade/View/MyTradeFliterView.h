//
//  MyTradeFliterView.h
//  Game789
//
//  Created by Maiyou on 2020/4/2.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTradeFliterView : BaseView <UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

// 筛选参数回调
@property (nonatomic, copy) void(^gameTradeFliterBlock)(NSString *game_species_type, NSString * game_device_type, NSString * trade_price_range, NSString * game_classify_id);

@property (nonatomic, strong) UIView * backView;
@property (strong, nonatomic)  UIButton * speciesSelectedBtn;
@property (strong, nonatomic)  UIButton * deviceSelectedBtn;
@property (weak, nonatomic) IBOutlet UITextField *lowestPrice;
@property (weak, nonatomic) IBOutlet UITextField *highestPrice;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cateTop;
@property (weak, nonatomic) IBOutlet UIView *cateTopView;

@property (nonatomic, assign) BOOL hiddenPriceRang;

@property (nonatomic, strong) NSArray * gameTypeArr;

/**  1：BT 2:折扣 3：H5 4:GM，默认不传取全部  */
@property (nonatomic, copy) NSString * game_species_type;
/** 0:双端 1：ios 2：Android，默认不传取全部 */
@property (nonatomic, copy) NSString *game_device_type;
/**  价格区域  */
@property (nonatomic, copy) NSString *trade_price_range;
/** 游戏类型id  筛选游戏类型 */
@property (nonatomic, copy) NSString *game_classify_id;

@property (nonatomic, assign) NSInteger game_classify_tag;

@end

NS_ASSUME_NONNULL_END
