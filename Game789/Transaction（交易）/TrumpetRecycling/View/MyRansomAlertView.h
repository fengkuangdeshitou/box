//
//  MyRansomAlertView.h
//  Game789
//
//  Created by yangyongMac on 2020/2/14.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

typedef void(^ReadAgreeProtocol)(BOOL isAgree);

NS_ASSUME_NONNULL_BEGIN

@interface MyRansomAlertView : BaseView <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showDetail;
@property (weak, nonatomic) IBOutlet UILabel *tipName;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_height;
/**  1 小号回收 2 小号赎回  */
@property (nonatomic, copy) NSString * type;

@property (nonatomic, copy) ReadAgreeProtocol agree;

@property (nonatomic, strong) NSArray * detailArray;

@end

NS_ASSUME_NONNULL_END
