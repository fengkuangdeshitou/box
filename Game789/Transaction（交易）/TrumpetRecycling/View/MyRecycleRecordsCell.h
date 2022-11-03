//
//  MyRecycleRecordsCell.h
//  Game789
//
//  Created by yangyongMac on 2020/2/12.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRecycleRecordsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyRecycleRecordsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *xhName;
@property (weak, nonatomic) IBOutlet UILabel *recycleAmount;
@property (weak, nonatomic) IBOutlet UILabel *ransomAmount;
@property (weak, nonatomic) IBOutlet UILabel *redeemedTime;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) MyRecycleRecordsModel *recordModel;


@end

NS_ASSUME_NONNULL_END
