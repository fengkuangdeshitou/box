//
//  MyActivityBunnerCell.h
//  Game789
//
//  Created by Maiyou on 2019/10/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyActivityBunnerCell : BaseTableViewCell <WSLRollViewDelegate>

@property (nonatomic, strong) WSLRollView * pageRollView;

@property (nonatomic, strong) NSArray * dataArray;

@end

NS_ASSUME_NONNULL_END
