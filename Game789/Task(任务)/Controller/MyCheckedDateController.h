//
//  MyCheckedDateController.h
//  Game789
//
//  Created by Maiyou on 2020/10/9.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCheckedDateController : BaseViewController

@property (nonatomic, assign) BOOL isSigned;
@property (nonatomic, strong) NSArray *signedDateArray;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, copy) NSString *getCoin;

@end

NS_ASSUME_NONNULL_END
