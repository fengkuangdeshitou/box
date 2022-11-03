//
//  MemberDescCell.h
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MemberDescCellDelegate <NSObject>

- (void)onDidselectedIndex:(NSInteger)index;

@end

@interface MemberDescCell : UITableViewCell

@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,weak)id<MemberDescCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
