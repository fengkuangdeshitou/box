//
//  HGHomeRecommendGamesCell.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNewGameReserveListCell.h"
#import "XHPageControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeHotGamesCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, SJVideoPlayerControlLayerDelegate, XHPageControlDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionView_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionView_right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionView_bottom;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showImageViewWidthConstraint;
/**  hot 热门推荐 reserve 预约 video 视频专区 starting 首发 project 专题 classify 热门分类 youLike 你可能还喜欢  */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSDictionary *issuerDic;
@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, copy) void(^UpdateRelatedGames)(void);

@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) MyNewGameReserveListCell * currentPlayingCell;

@property (nonatomic, strong) XHPageControl * pageControl;
/** ab测试 1 默认 2 新需求   */
@property (nonatomic, assign) NSInteger ab_test_index_swiper;
/** 是否为985   */
@property (nonatomic, assign) BOOL is_985;

@property (nonatomic, copy) NSString *source;

- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
