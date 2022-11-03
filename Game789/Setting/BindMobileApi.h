//
//  BindMobileApi.h
//  Game789
//
//  Created by xinpenghui on 2017/9/28.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface BindMobileApi : BaseRequest

@property (strong, nonatomic) NSString *moblie;
@property (strong, nonatomic) NSString *code;

@end
