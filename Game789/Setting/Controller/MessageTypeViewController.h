//
//  MessageTypeViewController.h
//  Game789
//
//  Created by maiyou on 2021/4/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MessageTypeViewControllerDelegate <NSObject>

- (void)onReadMessageCompletion;

@end

@interface MessageTypeViewController : BaseViewController

@property(nonatomic,weak)id<MessageTypeViewControllerDelegate>delegate;

-(instancetype)initWithType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
