//
//  EditUserInfoApi.h
//  Game789
//
//  Created by xinpenghui on 2017/9/17.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface EditUserInfoApi : BaseRequest

@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *real_name;
@property (strong, nonatomic) NSString *nick_name;
@property (strong, nonatomic) NSString *icon_link;
@property (strong, nonatomic) NSString *identity_card;
@property (strong, nonatomic) NSString *qq;
@property (strong, nonatomic) NSString *ios_down_style;

@end
