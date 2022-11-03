//
//  AuthAlertView.h
//  Game789
//
//  Created by maiyou on 2021/9/8.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AuthAlertViewDelegate <NSObject>

- (void)onAuthSuccess;

@end

@interface AuthAlertView : UIView

+ (void)showAuthAlertViewWithDelegate:(id<AuthAlertViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
