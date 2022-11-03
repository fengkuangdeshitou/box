//
//  MyActivityDetailController.h
//  Game789
//
//  Created by Maiyou001 on 2021/11/23.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyActivityDetailController : BaseViewController

@property (nonatomic,copy) NSString *news_id;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) NSDictionary *gameInfo;

@end

NS_ASSUME_NONNULL_END
