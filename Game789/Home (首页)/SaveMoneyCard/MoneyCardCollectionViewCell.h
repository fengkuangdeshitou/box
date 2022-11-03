//
//  MoneyCardCollectionViewCell.h
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoneyCardCollectionViewCell : UICollectionViewCell

@property(nonatomic,weak)IBOutlet UIView * badge;
@property(nonatomic,weak)IBOutlet UIView * container;

@property(nonatomic,weak)IBOutlet UIImageView * selectImageView;
@property(nonatomic,weak)IBOutlet UIImageView * icon;

@property(nonatomic,strong)NSDictionary * data;

@end

NS_ASSUME_NONNULL_END
