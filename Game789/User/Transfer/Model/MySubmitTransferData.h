//
//  MySubmitTransferData.h
//  Game789
//
//  Created by Maiyou on 2021/3/16.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MySubmitTransferData : NSObject

//转出
@property (nonatomic, copy) NSString *transfer_id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *gameid;
@property (nonatomic, copy) NSString *role_id;
@property (nonatomic, copy) NSString *amount;
//转入
@property (nonatomic, copy) NSString *transfer_type_id;
@property (nonatomic, copy) NSString *into_gameid;
@property (nonatomic, copy) NSString *into_username;
@property (nonatomic, copy) NSString *into_zone_id;
@property (nonatomic, copy) NSString *into_role_id;
@property (nonatomic, copy) NSString *into_pay_date;
@property (nonatomic, copy) NSString *into_pay_amount;

@end

NS_ASSUME_NONNULL_END
