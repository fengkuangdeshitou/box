//
//  HGGameCommitListTableViewCell.h
//  Game789
//
//  Created by xinpenghui on 2018/4/12.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "Moment.h"

@interface HGGameCommitListTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary * commentDic;
@property (nonatomic, strong) Comment * comment;
@property (nonatomic, strong) Moment  * moment;
/**  是否显示我的回复数据  */
@property (nonatomic, assign) BOOL  isMyReply;
@property (nonatomic, strong) UIViewController * currentVC;

@end
