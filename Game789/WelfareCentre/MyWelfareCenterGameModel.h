//
//  MyWelfareCenterGameModel.h
//  Game789
//
//  Created by Maiyou001 on 2021/10/13.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyWelfareCenterGameModel : NSObject

@property (nonatomic,copy) NSString * amount;
@property (nonatomic,copy) NSString * desc;
@property (nonatomic,copy) NSString * gameId;
@property (nonatomic,copy) NSString * gameName;
@property (nonatomic,copy) NSString * logo;
@property (nonatomic,copy) NSString * maiyouGameId;
@property (nonatomic,copy) NSString * received;
@property (nonatomic,copy) NSString * voucherId;
@property (nonatomic,copy) NSString * voucherDesc;
@property (nonatomic,copy) NSString * nameRemark;
@property (nonatomic,strong) NSDictionary * data;
@property (nonatomic,strong) GameModel * model;

@end

NS_ASSUME_NONNULL_END
