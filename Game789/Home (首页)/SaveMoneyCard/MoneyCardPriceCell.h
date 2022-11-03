//
//  MoneyCardPriceCell.h
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MoneyCardPriceCellDelegate <NSObject>

- (void)onSelectedGradeId:(NSString *)gradeid;

@end

@interface MoneyCardPriceCell : UITableViewCell

@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,weak)id<MoneyCardPriceCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
