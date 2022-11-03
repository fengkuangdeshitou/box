//
//  MyCouponCenterListCell.h
//  Game789
//
//  Created by Maiyou on 2020/7/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCouponCenterListCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UILabel *firstTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *showMoney;
@property (weak, nonatomic) IBOutlet UILabel *showVoucherCount;
@property (weak, nonatomic) IBOutlet UIButton *receivedBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, copy) void(^refreshDataAction)(void);

@end

NS_ASSUME_NONNULL_END
