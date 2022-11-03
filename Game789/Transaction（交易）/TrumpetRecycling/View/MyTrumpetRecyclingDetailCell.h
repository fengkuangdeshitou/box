//
//  MyTrumpetRecyclingDetailCell.h
//  Game789
//
//  Created by yangyongMac on 2020/2/11.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTrumpetRecyclingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTrumpetRecyclingDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *xhName;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *rechargeAmount;
@property (weak, nonatomic) IBOutlet UILabel *recycleAmount;

@property (nonatomic, strong) MyTrumpetRecyclingModel *recycleModel;

@property (nonatomic, assign) NSInteger index;


// 选择回调
@property (nonatomic, copy) void(^SelectAction)(BOOL isSelected, NSInteger index);

@end

NS_ASSUME_NONNULL_END
