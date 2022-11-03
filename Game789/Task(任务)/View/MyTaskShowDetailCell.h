//
//  MyTaskShowDetailCell.h
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyTaskShowDetailCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showDesc;
@property (weak, nonatomic) IBOutlet UIButton *showStatus;
@property (weak, nonatomic) IBOutlet UIImageView *showTag;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSDictionary *taskDic;

@end

NS_ASSUME_NONNULL_END
