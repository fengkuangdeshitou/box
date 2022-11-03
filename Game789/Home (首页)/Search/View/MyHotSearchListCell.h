//
//  MyHotSearchListCell.h
//  Game789
//
//  Created by Maiyou on 2020/12/2.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyHotSearchListCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showIndex;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *tagIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagIcon_width;
@property (weak, nonatomic) IBOutlet UILabel *showGameType;
@property (weak, nonatomic) IBOutlet UIImageView *gameRankIcon;

@property (nonatomic, assign) NSInteger cellItem;
@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
