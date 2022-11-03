//
//  MyCommentReplyCell.h
//  Game789
//
//  Created by Maiyou on 2021/4/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCommentReplyCell : BaseTableViewCell <MLLinkLabelDelegate>

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *gameType;
@property (weak, nonatomic) IBOutlet MLLinkLabel *showContent;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@property (nonatomic, strong) Comment * comment;

@end

NS_ASSUME_NONNULL_END
