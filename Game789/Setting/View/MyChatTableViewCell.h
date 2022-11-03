//
//  MyChatTableViewCell.h
//  Game789
//
//  Created by Maiyou001 on 2022/8/26.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetSettingNewsMgsModel.h"
@class MyChatMessageModel;

NS_ASSUME_NONNULL_BEGIN

@interface MyChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *userIconLeft;
@property (weak, nonatomic) IBOutlet UIImageView *userIconRight;
@property (weak, nonatomic) IBOutlet UILabel *usernameLeft;
@property (weak, nonatomic) IBOutlet UILabel *usernameRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_right;

@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameView_height;
@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *gameDesc;

@property (weak, nonatomic) IBOutlet UILabel *msgContent;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downloadBtn_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downloadBtn_top;

@property (nonatomic, strong) MyChatMessageModel * chatModel;

@end

NS_ASSUME_NONNULL_END
