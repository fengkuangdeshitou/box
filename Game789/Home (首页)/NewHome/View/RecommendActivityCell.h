//
//  RecommendActivityCell.h
//  Game789
//
//  Created by maiyou on 2021/11/24.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    RecommendStyleActivity,
    RecommendStyleGifs,
    RecommendStyleComment
} RecommendStyle;

@interface RecommendActivityCell : UITableViewCell

@property(nonatomic,assign)RecommendStyle style;
@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong)NSArray * voucherslist;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,strong)UIViewController * vc;

@end

NS_ASSUME_NONNULL_END
