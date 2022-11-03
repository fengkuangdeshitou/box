//
//  MyLimitedBuyingGiftCell.h
//  Game789
//
//  Created by Maiyou on 2021/1/14.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoScrollLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyLimitedBuyingGiftCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *showGiftName;
@property (weak, nonatomic) IBOutlet UILabel *showMoney;
@property (weak, nonatomic) IBOutlet UILabel *showCount;
@property (weak, nonatomic) IBOutlet UILabel *showCoin;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
@property (weak, nonatomic) IBOutlet UIView *scrollLabelView;
@property (weak, nonatomic) IBOutlet UIImageView *giftBgImage;
@property (nonatomic, strong) AutoScrollLabel *autoScrollLabel;

@property (nonatomic, strong) NSDictionary *dataDic;
/** 兑换时间段 */
@property (nonatomic, copy) NSString *exchangeTime;
// 领取成功回调
@property (nonatomic, copy) void(^receivedActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
