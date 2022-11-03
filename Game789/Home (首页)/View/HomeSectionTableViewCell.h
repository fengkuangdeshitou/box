//
//  HomeSectionTableViewCell.h
//  Game789
//
//  Created by xinpenghui on 2018/4/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol HomeSectionTableViewCellDelegate <NSObject>

- (void)gameStoreOpen:(NSInteger)tag;

@end

@interface HomeSectionTableViewCell : BaseTableViewCell

@property (assign, nonatomic) id<HomeSectionTableViewCellDelegate>delegate;

- (void)resetTitleLabel:(NSString *)title;
@end
