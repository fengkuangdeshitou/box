//
//  MyAlertView.h
//  Game789
//
//  Created by Maiyou001 on 2022/8/30.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAlertConfigure.h"

typedef void (^MyAlertClickBlock)(NSInteger buttonIndex);

NS_ASSUME_NONNULL_BEGIN

@interface MyAlertView : UIView

@property (nonatomic, copy) MyAlertClickBlock buttonClickBlock;

+ (MyAlertView *)alertViewWithConfigure:(MyAlertConfigure *)configure buttonBlock:(nullable MyAlertClickBlock)btnBlock;

@end

NS_ASSUME_NONNULL_END
