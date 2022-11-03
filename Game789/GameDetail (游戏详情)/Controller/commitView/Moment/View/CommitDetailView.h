//
//  CommitDetailView.h
//  Game789
//
//  Created by Maiyou on 2018/8/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CommitDataBack)(NSArray * commentList, NSString * commitTotal);
typedef void(^HiddenCommitPopView)(BOOL isHidden);

@interface CommitDetailView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * commitArrays;
@property (nonatomic, copy)   NSString * topicId;
@property (nonatomic, copy)   NSString * game_name;
@property (nonatomic, strong) BaseViewController * currentVC;
/**  是否对tableview底部view隐藏  */
@property (nonatomic, assign) BOOL isFooterHidden;

@property (nonatomic, strong) UIButton * moreCommit;
@property (nonatomic, copy) CommitDataBack commitData;
@property (nonatomic, copy) HiddenCommitPopView hiddenCommitPopView;

/**  是否显示问答  */
@property (nonatomic, assign) BOOL isShowQuestion;
@property (nonatomic, strong) NSDictionary * dataDic;

- (instancetype)initWithFrame:(CGRect)frame TopicId:(NSString *)topicId;
/**  获取评论数据  */
- (void)getCommitApiRequest;

@end
