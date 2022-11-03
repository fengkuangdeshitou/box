//
//  MyMainSearchFooterView.h
//  Game789
//
//  Created by Maiyou on 2020/12/2.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyMainSearchFooterView : BaseView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
