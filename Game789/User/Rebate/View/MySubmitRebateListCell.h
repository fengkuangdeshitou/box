//
//  MySubmitRebateListCell.h
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MySubmitRebateListCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showIcon;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UIButton *showDetail;
@property (weak, nonatomic) IBOutlet UIImageView *dropIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showDetail_right;

@property (nonatomic, strong) NSDictionary * titleDic;

@end

NS_ASSUME_NONNULL_END
