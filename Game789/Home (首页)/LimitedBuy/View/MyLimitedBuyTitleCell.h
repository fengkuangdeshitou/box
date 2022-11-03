//
//  MyLimitedBuyTitleCell.h
//  Game789
//
//  Created by Maiyou on 2021/1/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyLimitedBuyTitleCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *showStatus;
@property (nonatomic, strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
