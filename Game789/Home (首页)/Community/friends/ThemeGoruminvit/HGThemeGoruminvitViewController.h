//
//  HGThemeGoruminvitViewController.h
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"
#import "HGThemeModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HGThemeGoruminvitViewControllerDelegate <NSObject>

- (void)themeGoruminvitDidchangeLike:(HGThemeModel *)model;
- (void)themeGoruminvitDidchangeDisLike:(HGThemeModel *)model;

@end

@interface HGThemeGoruminvitViewController : BaseViewController

@property (nonatomic,copy)NSString * themeId;
@property (nonatomic,weak)id<HGThemeGoruminvitViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
