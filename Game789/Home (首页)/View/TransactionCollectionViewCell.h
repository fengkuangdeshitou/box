//
//  TransactionCollectionViewCell.h
//  Game789
//
//  Created by Maiyou on 2018/12/4.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransactionCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary * dataDic;

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *game_icon;
@property (weak, nonatomic) IBOutlet UILabel *game_name;
@property (weak, nonatomic) IBOutlet UILabel *salePrice;

@end

NS_ASSUME_NONNULL_END
