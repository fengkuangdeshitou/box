//
//  YYPersonalCollectionSectionView.h
//  52Talk
//
//  Created by Maiyou on 2019/3/15.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYPersonalCollectionSectionView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceView_top;
@property (weak, nonatomic) IBOutlet UIView *monthCardView;

@end

NS_ASSUME_NONNULL_END
