//
//  HomeSuggestTableViewCell.h
//  Game789
//
//  Created by xinpenghui on 2018/3/13.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"
@protocol homeSuggestTableViewCellDelegate <NSObject>

- (void)selectedPress:(NSInteger)index;

@end
@interface HomeSuggestTableViewCell : BaseTableViewCell

@property (nonatomic, strong) id<homeSuggestTableViewCellDelegate>delegate;

// h5 3 BT 1 折扣 2
@property (nonatomic, assign) NSInteger  type;

@end
