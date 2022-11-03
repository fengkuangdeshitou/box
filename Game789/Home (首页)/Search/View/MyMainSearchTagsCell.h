//
//  MyMainSearchTagsCell.h
//  Game789
//
//  Created by Maiyou on 2020/12/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "WMZTagCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyMainSearchTagsCell : WMZTagCell

// tag的点击
@property (nonatomic, copy) void(^tagClickBlock)(NSInteger idx,NSString *tag);

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier IndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
