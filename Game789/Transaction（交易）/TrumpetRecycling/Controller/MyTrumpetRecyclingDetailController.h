//
//  MyTrumpetRecyclingDetailController.h
//  Game789
//
//  Created by yangyongMac on 2020/2/11.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"
#import "MyRecycleGameListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTrumpetRecyclingDetailController : BaseViewController

@property (nonatomic, strong) MyRecycleGameListModel * listModel;

// 回收小号成功
@property (nonatomic, copy) void(^RecycleXhSuccess)();

@end

NS_ASSUME_NONNULL_END
