//
//  MyPushGameAllVouchersController.h
//  Game789
//
//  Created by Maiyou on 2020/7/21.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"
#import "MyVoucherListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyPushGameAllVouchersController : BaseViewController

@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, assign) NSInteger game_species_type;
// 领取代金券刷新数据
@property (nonatomic, copy) void(^receivedVoucherAction)(NSArray * array, MyVoucherListModel * model);

@end

NS_ASSUME_NONNULL_END
