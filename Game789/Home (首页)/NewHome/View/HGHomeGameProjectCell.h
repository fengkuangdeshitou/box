//
//  HGHomeGameProjectCell.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeGameProjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UIView *more;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *showImage;
@property (weak, nonatomic) IBOutlet UIImageView * titleImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * titleImageWidthConstraint;

@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
