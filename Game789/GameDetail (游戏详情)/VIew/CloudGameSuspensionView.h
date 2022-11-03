//
//  CloudGameSuspensionView.h
//  Game789
//
//  Created by maiyou on 2021/6/22.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CloudGameSuspensionViewDelegate <NSObject>

/// 画质
- (void)onImageQualityAction;

/// 退出
- (void)onExitAction;

@end

@interface CloudGameSuspensionView : UIView

@property(nonatomic,weak)id<CloudGameSuspensionViewDelegate>delegate;

@property (nonatomic, assign) BOOL isH5Game;

@end

NS_ASSUME_NONNULL_END
