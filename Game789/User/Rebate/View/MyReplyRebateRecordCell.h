//
//  MyReplyRebateRecordCell.h
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyReplyRebateRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *showMoney;
@property (weak, nonatomic) IBOutlet UILabel *showStatus;
@property (weak, nonatomic) IBOutlet UILabel *showReason;
@property (weak, nonatomic) IBOutlet UILabel *showMoneyTitle;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSDictionary * transferDic;

@end

NS_ASSUME_NONNULL_END
