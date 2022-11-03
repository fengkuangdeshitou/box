//
//  GameDetailCommentViewController.h
//  Game789
//
//  Created by Maiyou on 2018/11/6.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"
#import "CommitDetailView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameDetailCommentViewController : BaseViewController

@property (nonatomic, strong) CommitDetailView * commitView;

@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
