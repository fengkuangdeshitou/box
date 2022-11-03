//
//  MyGameFeedbackCell.h
//  Game789
//
//  Created by Maiyou on 2020/7/27.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyGameFeedbackCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *gameName;

@end

NS_ASSUME_NONNULL_END
