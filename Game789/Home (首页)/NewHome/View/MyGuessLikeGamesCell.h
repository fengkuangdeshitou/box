//
//  MyGuessLikeGamesCell.h
//  Game789
//
//  Created by Maiyou on 2020/8/29.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyGuessLikeGamesCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *gameImage;
@property (weak, nonatomic) IBOutlet UILabel *showDiscount;
@property (weak, nonatomic) IBOutlet UIImageView *discountBg;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *gameType;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
