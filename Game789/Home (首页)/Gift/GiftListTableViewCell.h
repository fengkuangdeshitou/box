//
//  HomeListTableViewCell.h
//  Game789
//
//  Created by xinpenghui on 2017/9/2.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol GiftListTableViewCellDelegate <NSObject>

- (void)showHUDView:(NSString *)codeStr;

@end

@interface GiftListTableViewCell : BaseTableViewCell

@property (weak, nonatomic) id <GiftListTableViewCellDelegate> delegate;

@end
