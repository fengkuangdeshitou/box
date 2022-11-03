//
//  HGGameTypesViewController.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/6/5.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameTypesViewController : BaseViewController

@property (nonatomic, copy) NSString *game_classify_id;

@property (nonatomic, copy) void(^SureBtnClick)(NSDictionary *typeDic);

@end

NS_ASSUME_NONNULL_END
