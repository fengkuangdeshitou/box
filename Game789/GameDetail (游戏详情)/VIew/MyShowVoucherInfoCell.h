//
//  MyShowVoucherInfoCell.h
//  Game789
//
//  Created by Maiyou on 2020/7/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyVoucherListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyShowVoucherInfoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *showMoney;
@property (weak, nonatomic) IBOutlet UILabel *showDiscount;
@property (weak, nonatomic) IBOutlet UIButton *receivedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *showBgImage;
@property (nonatomic, strong) MyVoucherListModel * voucherModel;

@end

NS_ASSUME_NONNULL_END
