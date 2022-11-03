//
//  MyLimitedBuyingCell.h
//  Game789
//
//  Created by Maiyou on 2021/1/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyLimitedBuyingCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *showAmountTag;
@property (weak, nonatomic) IBOutlet UIImageView *showBgImage;
/** 兑换金额   */
@property (weak, nonatomic) IBOutlet UILabel *showAmount;
/** 满减金额   */
@property (weak, nonatomic) IBOutlet UILabel *showMeetAmount;
/** 会员显示价格   */
@property (weak, nonatomic) IBOutlet UILabel *showMemberCoin;
/** 非会员显示价格   */
@property (weak, nonatomic) IBOutlet UILabel *showcoin;
/** 显示剩余数量   */
@property (weak, nonatomic) IBOutlet UILabel *showCount;

@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *giftImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showMeetAmount_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftImage_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giftImage_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleView_bottom;

@property (nonatomic, strong) NSDictionary *dataDic;
/** 兑换时间段 */
@property (nonatomic, copy) NSString *exchangeTime;

// 领取成功回调
@property (nonatomic, copy) void(^receivedActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
