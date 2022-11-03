//
//  SellAccountUploadApi.h
//  Game789
//
//  Created by Maiyou on 2018/8/21.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseRequest.h"

@interface SellAccountUploadApi : BaseRequest

@property (nonatomic, copy) NSString * server_name;
@property (nonatomic, copy) NSString * sell_price;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * game_screenshots;
@property (nonatomic, copy) NSString * game_uploadedshots;
@property (nonatomic, copy) NSString * second_level_pwd;
@property (nonatomic, copy) NSString * member_id;
@property (nonatomic, copy) NSString * xh_username;
@property (nonatomic, copy) NSString * game_id;

@end
