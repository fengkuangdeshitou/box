//
//  HomeAdTableViewCell.h
//  Game789
//
//  Created by xinpenghui on 2017/9/2.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^DidRollItemToIndex)(NSInteger index, BaseTableViewCell * cell);

@interface HomeAdTableViewCell : BaseTableViewCell <WSLRollViewDelegate>

@property (nonatomic, strong) WSLRollView * pageRollView;

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, copy) DidRollItemToIndex RollItemToIndex;

@end
