//
//  YYPersonalCollectionViewCell.h
//  52Talk
//
//  Created by Maiyou on 2019/3/15.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYPersonalCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *radiusView;
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *badgeCount;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *showCourseCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeLabel_width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeLabel_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeLabel_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeLabel_top;

@property (nonatomic, assign) BOOL isHiddenImage;
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, strong) NSIndexPath * indexPath;

@end

NS_ASSUME_NONNULL_END
