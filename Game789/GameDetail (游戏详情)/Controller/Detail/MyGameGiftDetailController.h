//
//  MyGameGiftDetailController.h
//  Game789
//
//  Created by Maiyou on 2021/1/19.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameGiftDetailController : BaseViewController

@property (nonatomic, strong) UIViewController * vc;

@property (nonatomic, copy) NSString * gift_id;
/** 是否可以领取   */
@property (nonatomic, assign) BOOL isReceived;

//领取成功
@property (nonatomic, copy) void(^receivedGiftCodeBlock)(void);

@end

NS_ASSUME_NONNULL_END
