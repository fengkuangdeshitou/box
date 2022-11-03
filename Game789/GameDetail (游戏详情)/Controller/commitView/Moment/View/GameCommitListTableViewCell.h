//
//  GameCommitListTableViewCell.h
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Comment.h"
#import "Moment.h"

@interface GameCommitListTableViewCell : BaseTableViewCell

@property (nonatomic, strong) Comment * comment;
@property (nonatomic, strong) Moment  * moment;

@property (nonatomic, assign) BOOL  isShowComment;
@property (nonatomic, assign) BOOL  isComments;

@end
