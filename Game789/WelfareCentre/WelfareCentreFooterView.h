//
//  WelfareCentreFooterView.h
//  Game789
//
//  Created by maiyou on 2021/9/15.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WelfareCentreFooterView : UICollectionReusableView <AuthAlertViewDelegate>

// 实名成功
@property (nonatomic, copy) void(^authVerifySuccess)(void);

@property(nonatomic,weak)IBOutlet UIView * radiusView;
@property(nonatomic,weak)IBOutlet UIView * verifyView;

@end

NS_ASSUME_NONNULL_END
