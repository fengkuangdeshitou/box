//
//  ModifyPwdApi.h
//  Game789
//
//  Created by xinpenghui on 2017/9/17.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface ModifyPwdApi : BaseRequest

@property (strong, nonatomic) NSString *oldPwd;
@property (strong, nonatomic) NSString *newsPwd;

@end
