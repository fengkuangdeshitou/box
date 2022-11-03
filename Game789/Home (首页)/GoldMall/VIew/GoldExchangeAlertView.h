//
//  GoldExchangeAlertView.h
//  Game789
//
//  Created by maiyou on 2021/3/18.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GoldExchangeAlertViewDelegate <NSObject>

- (void)goldExchangeAlertViewDidEcchange;

@end

@interface GoldExchangeAlertView : UIView

+ (void)showGoldExchangeAlertViewWithNumber:(NSString *)number delegate:(id<GoldExchangeAlertViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
