//
//  MyGameCollectionCell.h
//  Game789
//
//  Created by Maiyou on 2018/12/5.
//  Copyright © 2018 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameCollectionCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *game_icon;

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showDetail;
@property (weak, nonatomic) IBOutlet UILabel *showMark;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showMark_width;

@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
