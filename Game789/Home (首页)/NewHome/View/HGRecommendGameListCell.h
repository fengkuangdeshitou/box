//
//  HGRecommendGameListCell.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/19.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGRecommendGameListCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary * dataDic;

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *showDiscount;
@property (weak, nonatomic) IBOutlet UIImageView *discountBg;
@property (weak, nonatomic) IBOutlet UILabel *showGameType;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@end

NS_ASSUME_NONNULL_END
