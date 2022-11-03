//
//  HGEvaluationCell.h
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HGEvaluationCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView * avatarImageView;
@property (nonatomic,weak) IBOutlet UIImageView * evaluationImageView;
@property (nonatomic,weak) IBOutlet UILabel * nickNameLabel;
@property (nonatomic,weak) IBOutlet UIButton * likeButton;
@property (nonatomic,weak) IBOutlet UILabel * contentLabel;

@end

NS_ASSUME_NONNULL_END
