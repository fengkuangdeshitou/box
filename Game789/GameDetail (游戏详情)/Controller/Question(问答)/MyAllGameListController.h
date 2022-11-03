//
//  MyAllGameListController.h
//  Game789
//
//  Created by yangyongMac on 2020/2/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SelectGameAction)(NSDictionary *dic);

NS_ASSUME_NONNULL_BEGIN

@interface MyAllGameListController : BaseViewController

@property (nonatomic, copy) SelectGameAction selectGame;

@end

NS_ASSUME_NONNULL_END
