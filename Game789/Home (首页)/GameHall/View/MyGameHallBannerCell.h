//
//  MyGameHallBannerCell.h
//  Game789
//
//  Created by Maiyou on 2020/10/13.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyGameHallBannerCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageViews;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *showDetail;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentIcon_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabel_left;

@property (nonatomic, strong) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
