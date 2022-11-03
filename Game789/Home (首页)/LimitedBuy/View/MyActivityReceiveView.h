//
//  HGGameReceiveGiftView.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/6/3.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyActivityReceiveView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSDictionary * voucherDic;
@property (nonatomic, copy) void(^receiveGiftAction)(void);

@end

NS_ASSUME_NONNULL_END
