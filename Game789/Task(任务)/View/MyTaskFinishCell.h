//
//  MyTaskFinishCell.h
//  Game789
//
//  Created by Maiyou on 2020/10/16.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyTaskCellModel.h"
#import "AuthAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTaskFinishCell : BaseTableViewCell<AuthAlertViewDelegate>

@property (nonatomic, strong) MyTaskCellModel *taskModel;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *showIcon;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showDesc;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *showProgress;
@property (weak, nonatomic) IBOutlet UILabel *showCoinNum;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showIcon_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiveBtn_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *content_height;

/** 是否是ua8x渠道或者子渠道   */
@property (nonatomic, assign) BOOL is_ua8x;

@property (nonatomic, copy) void(^receiveBtnBlock)(MyTaskCellModel *model);
//点击领取
- (void)receiceRequest:(NSString *)name;
//点击跳转
- (void)pushToVc:(MyTaskCellModel *)model;

@end

NS_ASSUME_NONNULL_END
