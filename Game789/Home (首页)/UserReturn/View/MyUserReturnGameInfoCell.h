//
//  MyUserReturnGameInfoCell.h
//  Game789
//
//  Created by Maiyou001 on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyUserReturnGamesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyUserReturnGameInfoCell : BaseTableViewCell

@property(nonatomic,weak)IBOutlet YYAnimatedImageView * logo;
@property(nonatomic,weak)IBOutlet UILabel * gamaname;
@property(nonatomic,weak)IBOutlet UIStackView * stackView;
@property(nonatomic,weak)IBOutlet UIStackView * stackView1;
@property (weak, nonatomic) IBOutlet UILabel *playGames;
@property(nonatomic,weak)IBOutlet UILabel * desc;
@property (weak, nonatomic) IBOutlet UIButton *selectedStatus;

@property (nonatomic,strong) MyUserReturnGamesModel *gamesModel;

@end

NS_ASSUME_NONNULL_END
