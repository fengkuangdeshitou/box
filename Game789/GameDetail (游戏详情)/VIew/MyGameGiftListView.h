//
//  MyGameGiftListView.h
//  Game789
//
//  Created by Maiyou001 on 2022/5/30.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameGiftListView : BaseView

@property (nonatomic,strong) NSMutableArray *dataArray;
// 领取成功
@property (nonatomic, copy) void(^receivedSuccessblock)(void);

@end

NS_ASSUME_NONNULL_END
