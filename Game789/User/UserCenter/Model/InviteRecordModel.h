//
//  InviteRecordModel.h
//  Game789
//
//  Created by maiyou on 2021/6/25.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteRecordModel : NSObject

@property(nonatomic,copy)NSString * username;
@property(nonatomic,copy)NSString * invite;
@property(nonatomic,copy)NSString * coin_total;
@property(nonatomic,copy)NSString * amount;

@end

NS_ASSUME_NONNULL_END
