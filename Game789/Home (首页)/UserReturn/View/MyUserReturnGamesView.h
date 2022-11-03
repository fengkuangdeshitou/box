//
//  MyUserReturnGamesView.h
//  Game789
//
//  Created by Maiyou001 on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "BaseView.h"
#import "MyUserReturnGameInfoCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyUserReturnGamesView : BaseView

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) BOOL newExclusive;

// 领取成功后
@property (nonatomic, copy) void(^receivedSuccess)(NSString * pack_ids);

@end

NS_ASSUME_NONNULL_END
