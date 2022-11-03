//
//  HomeCycleCell.h
//  Game789
//
//  Created by maiyou on 2021/5/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCycleCell : UICollectionViewCell

@property(nonatomic,weak)IBOutlet YYAnimatedImageView * icon;
@property(nonatomic,weak)IBOutlet UIView * infoView;
@property(nonatomic,strong)NSDictionary * data;
@property(nonatomic,assign)BOOL showGradientLayer;
@end

NS_ASSUME_NONNULL_END
