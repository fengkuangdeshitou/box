//
//  ForgotPwdApi.h
//  Game789
//
//  Created by xinpenghui on 2017/9/29.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface ForgotPwdApi : BaseRequest
@property (strong, nonatomic)NSString *mobile;
@property (strong, nonatomic)NSString *newpassword;
@property (strong, nonatomic)NSString *code;

@end
