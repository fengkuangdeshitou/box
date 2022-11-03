//
//  WelfareCentreHeaderView.h
//  Game789
//
//  Created by maiyou on 2021/9/15.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WelfareCentreHeaderView : UICollectionReusableView

@property(nonatomic,weak)IBOutlet UIView * radiusView;
@property(nonatomic,weak)IBOutlet UIImageView * icon;
@property(nonatomic,weak)IBOutlet UIButton * moreButton;

@end

NS_ASSUME_NONNULL_END
