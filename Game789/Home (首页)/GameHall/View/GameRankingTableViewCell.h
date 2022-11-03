//
//  GameRankingTableViewCell.h
//  Game789
//
//  Created by Maiyou on 2018/7/20.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol GameRankingTableViewCellDelegate <NSObject>

- (void)rankTopClcik:(NSInteger)index;

@end

@interface GameRankingTableViewCell : BaseTableViewCell

@property (nonatomic, weak) id <GameRankingTableViewCellDelegate>delegate;

@end
