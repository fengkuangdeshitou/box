//
//  SpecialTopicGameCell.h
//  Game789
//
//  Created by Maiyou on 2018/12/5.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpecialTopicGameCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *gameTypeTitle;

@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
