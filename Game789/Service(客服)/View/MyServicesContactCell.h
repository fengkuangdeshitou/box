//
//  MyServicesContactCell.h
//  Game789
//
//  Created by Maiyou on 2020/10/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyAddWxView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyServicesContactCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showIcon;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showValue;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *showTag;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSDictionary *kefuDic;
@property (nonatomic,strong) MyAddWxView *addWxView;

@end

NS_ASSUME_NONNULL_END
