//
//  MyActivityGuideController.h
//  Game789
//
//  Created by Maiyou on 2019/10/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyActivityGuideController : BaseViewController

@property (nonatomic, copy) NSString *game_id;
@property (nonatomic, assign) int introduction_count;
@property (nonatomic, strong) NSDictionary * gameInfo;

@end

NS_ASSUME_NONNULL_END
