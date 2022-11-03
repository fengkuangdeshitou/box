//
//  LoginApi.h
//  Game789
//
//  Created by xinpenghui on 2017/8/31.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface LoginApi : BaseRequest

@property (nonatomic, copy) NSString *phoneNO;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *logintype;

@end

@interface VerifyCodeLoginApi : BaseRequest

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *code;

@end

@interface TickLoginApi : BaseRequest

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *tick;

@end


@interface GetCountryCodeApi : BaseRequest

@end
