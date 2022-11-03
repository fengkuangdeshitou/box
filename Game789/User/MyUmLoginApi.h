//
//  MyUmLoginApi.h
//  Game789
//
//  Created by Maiyou on 2020/1/15.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyUmLoginApi : BaseRequest

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *appkey;

@end

NS_ASSUME_NONNULL_END
