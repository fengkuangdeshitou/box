//
//  AreaViewController.h
//  Game789
//
//  Created by maiyou on 2021/10/28.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AreaViewControllerDelegate <NSObject>

- (void)onSelectedArea:(NSDictionary *)area;

@end

@interface AreaViewController : BaseViewController

@property(nonatomic,weak)id<AreaViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
