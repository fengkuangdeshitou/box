//
//  PromptDetailsView.h
//  Game789
//
//  Created by Maiyou on 2018/8/16.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReadAgreeProtocol)(BOOL isAgree);

@interface PromptDetailsView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showDetail;
@property (weak, nonatomic) IBOutlet UILabel *processName;
@property (weak, nonatomic) IBOutlet UILabel *process1;
@property (weak, nonatomic) IBOutlet UILabel *process2;
@property (weak, nonatomic) IBOutlet UILabel *process3;
@property (weak, nonatomic) IBOutlet UILabel *process4;
@property (weak, nonatomic) IBOutlet UILabel *tipName;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicationImage_height;
/**  1 买家提示 2 交易细则  */
@property (nonatomic, copy) NSString * type;

@property (nonatomic, copy) ReadAgreeProtocol agree;

@property (nonatomic, strong) NSArray * detailArray;

@end
