//
//  MyReplyRebateDetailController.h
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyReplyRebateDetailController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerView_height;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *showAccount;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *showService;
@property (weak, nonatomic) IBOutlet UILabel *showRoleName;
@property (weak, nonatomic) IBOutlet UILabel *showRoleId;
@property (weak, nonatomic) IBOutlet UILabel *showMark;
@property (weak, nonatomic) IBOutlet UILabel *handleTime;
@property (weak, nonatomic) IBOutlet UILabel *showMoney;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitBtn_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitBtn_width;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_top;
@property (weak, nonatomic) IBOutlet UILabel *codeTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeTitle_top;

@property (nonatomic, strong) NSDictionary * dataDic;

@property (nonatomic, copy) NSString *rebate_id;

@end

NS_ASSUME_NONNULL_END
