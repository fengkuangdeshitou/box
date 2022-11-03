//
//  MyUserReturnModel.h
//  Game789
//
//  Created by Maiyou001 on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyUserReturnModel : BaseModel

@property (nonatomic,copy) NSString * imageName;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * desc;
@property (nonatomic,copy) NSString * type;
@property (nonatomic,assign) NSInteger status;

@property (nonatomic, assign) BOOL sign;
@property (nonatomic, assign) BOOL comments;
@property (nonatomic, assign) BOOL login_game;
@property (nonatomic, assign) BOOL amount1;
@property (nonatomic, assign) BOOL amount10;

@end

NS_ASSUME_NONNULL_END
