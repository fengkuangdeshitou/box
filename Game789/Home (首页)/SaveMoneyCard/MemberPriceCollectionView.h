//
//  MemberPriceCollectionView.h
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemberPriceCollectionView : UICollectionViewCell

@property(nonatomic,weak)IBOutlet UIImageView * selectedImageView;

@property(nonatomic,strong)NSDictionary * data;

@end

NS_ASSUME_NONNULL_END
