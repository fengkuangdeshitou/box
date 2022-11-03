//
//  MySetPasswordApi.h
//  Game789
//
//  Created by Maiyou on 2020/1/15.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MySetPasswordApi : BaseRequest

@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * password;

@end

@interface MyPswSetPasswordApi : BaseRequest

@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * member_id;

@end

NS_ASSUME_NONNULL_END
