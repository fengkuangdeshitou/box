//
//  AwemeListController.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "BaseViewController.h"
#import "AwemeListCell.h"

typedef NS_ENUM(NSUInteger, AwemeType) {
    AwemeWork        = 0,
    AwemeFavorite    = 1
};

@class Aweme;
@interface AwemeListController : BaseViewController

@property (nonatomic, strong) UITableView                 *tableView;
@property (nonatomic, assign) NSInteger                   currentIndex;
@property (nonatomic, assign) NSInteger                   pastIndex;
@property (nonatomic, strong) NSMutableArray<Aweme *>     *data;
@property (nonatomic, assign) BOOL                        isTrack;
@property (nonatomic, assign) NSInteger                   pageIndex;

-(instancetype)initWithVideoData:(NSMutableArray<Aweme *> *)data currentIndex:(NSInteger)currentIndex pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize awemeType:(AwemeType)type uid:(NSString *)uid;

- (void)videoViewAppear;

@end
