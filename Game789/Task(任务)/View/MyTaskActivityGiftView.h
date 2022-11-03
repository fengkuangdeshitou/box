//
//  MyTaskActivityGiftView.h
//  Game789
//
//  Created by Maiyou on 2020/10/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTaskActivityGiftView : BaseView

@property (weak, nonatomic) IBOutlet UITextField *exchangeCode;

@property (nonatomic, copy) void(^exchangeGiftBlock)(void);

@end

NS_ASSUME_NONNULL_END
