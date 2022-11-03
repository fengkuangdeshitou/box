//
//  RecommendViewController.h
//  Game789
//
//  Created by maiyou on 2021/11/23.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendViewController : BaseViewController

@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,copy)NSString * gameId;

- (void)stopPlayVideo;

@end

NS_ASSUME_NONNULL_END
