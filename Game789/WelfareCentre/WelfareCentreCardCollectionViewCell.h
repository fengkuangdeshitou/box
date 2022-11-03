//
//  WelfareCentreCardCollectionViewCell.h
//  Game789
//
//  Created by maiyou on 2022/5/5.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WelfareCentreCardCollectionViewCell : UICollectionViewCell

@property (nonatomic,weak) IBOutlet UIImageView * icon;
@property (nonatomic,weak) IBOutlet UILabel * titleLabel;
@property (nonatomic,weak) IBOutlet UILabel * descLabel;
@property (nonatomic,weak) IBOutlet UILabel * content;


@end

NS_ASSUME_NONNULL_END
