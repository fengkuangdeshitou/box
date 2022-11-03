//
//  MyAddTopicViewController.h
//  Game789
//
//  Created by Maiyou on 2020/12/22.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyAddTopicViewController : BaseViewController

@property (nonatomic, copy) void(^AddTopicBlock)(NSString * _Nullable name, NSString * _Nullable titleId);

@end

NS_ASSUME_NONNULL_END
