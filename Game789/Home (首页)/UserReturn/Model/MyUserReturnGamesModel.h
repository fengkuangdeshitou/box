//
//  MyUserReturnGamesModel.h
//  Game789
//
//  Created by Maiyou001 on 2022/3/2.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyUserReturnGamesModel : BaseModel

@property (nonatomic,copy) NSString * appid;
@property (nonatomic,copy) NSString * briefsummary;
@property (nonatomic,copy) NSString * downloadcount;
@property (nonatomic,copy) NSString * gamename;
@property (nonatomic,copy) NSString * is_received;
@property (nonatomic,copy) NSString * logo;
@property (nonatomic,copy) NSString * maiyou_gameid;
@property (nonatomic,copy) NSString * packid;
@property (nonatomic,copy) NSString * packname;
@property (nonatomic,copy) NSString * size;
@property (nonatomic,strong) NSArray * version;
@property (nonatomic,copy) NSString * versioncode;
@property (nonatomic,copy) NSString * how_many_play;

@end

NS_ASSUME_NONNULL_END
