//
//  SellingAccountViewController.h
//  Game789
//
//  Created by Maiyou on 2018/8/17.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^PublishFinish)(BOOL isTrading);

@interface SellingAccountViewController : BaseViewController

@property (nonatomic, copy) PublishFinish finish;

@property (nonatomic, strong) NSDictionary * detailDic;


@end
