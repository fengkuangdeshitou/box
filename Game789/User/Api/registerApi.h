//
//  registerApi.h
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface registerApi : BaseRequest

@property (nonatomic, copy) NSString *regtype;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *code;

@end
