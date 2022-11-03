//
//  TUAlerterView.h
//  TuuDemo
//
//  Created by 张鸿 on 16/3/8.
//  Copyright © 2016年 张鸿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTSingleton.h"
#import "TuuHUD.h"

@interface TUAlerterView : NSObject
AS_SINGLETON(TUAlerterView)
- (void)showWithTitle:(NSString *)title;
- (void)showWithTitle:(NSString *)title Completion:(void(^)())completion;
- (void)showWithTitle:(NSString *)title msg:(NSString *)msg cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle  Completion:(void(^)(BOOL isVerify))completion;
@end
