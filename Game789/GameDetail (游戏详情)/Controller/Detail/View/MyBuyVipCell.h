//
//  MyBuyVipCell.h
//  Game789
//
//  Created by Maiyou001 on 2022/4/8.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyBuyVipCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *showTips;
@property (weak, nonatomic) IBOutlet UILabel *showAmount;
@property (weak, nonatomic) IBOutlet UILabel *showTips1;
@property (weak, nonatomic) IBOutlet UILabel *showTips2;
@property (weak, nonatomic) IBOutlet UILabel *showLable;
@property (weak, nonatomic) IBOutlet UIView *showTipsView;
@property (nonatomic,strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
