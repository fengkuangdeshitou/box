//
//  TuuHUD.h
//  test
//
//  Created by 张鸿 on 16/9/2.
//  Copyright © 2016年 张鸿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TuuHUD : NSObject
+ (void)showSuccessWithStr:(NSString *)str;
+ (void)showErrorWithStr:(NSString *)str;
+ (void)showmessage:(NSString *)str;
@end
