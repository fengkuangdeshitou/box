//
//  MyProjectGameController.h
//  Game789
//
//  Created by Maiyou on 2018/12/6.
//  Copyright © 2018 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyProjectGameController : BaseViewController

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDictionary * dataDic;

@property (nonatomic, copy) NSString *project_id;
@property (nonatomic, copy) NSString *project_title;

@end

NS_ASSUME_NONNULL_END
