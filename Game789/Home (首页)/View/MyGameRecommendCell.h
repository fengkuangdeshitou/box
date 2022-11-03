//
//  MyGameRecommendCell.h
//  Game789
//
//  Created by Maiyou on 2019/10/15.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameRecommendCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bunnerImageView;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *gameDesc;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *recommendName;
@property (weak, nonatomic) IBOutlet UILabel *buttonTitle;

@property (nonatomic, strong) NSDictionary * dataDic;

- (void)gameContentTableCellBtn:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
