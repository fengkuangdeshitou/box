//
//  HGHomeRecommendGamesCell.h
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNewGameReserveListCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HGHomeProjectGamesCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, SJVideoPlayerControlLayerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showTitle_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showTitle_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionView_left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionView_bottom;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBurron_right;

/**  hot 热门推荐 reserve 预约 video 视频专区 starting 首发 project 专题 classify 热门分类  */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSDictionary *issuerDic;
@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, strong) NSArray * dataArray;
//游戏大厅精选数据
@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, copy) void(^UpdateRelatedGames)(void);
@property (weak, nonatomic) IBOutlet UIView * colorView;
@property (weak, nonatomic) IBOutlet UIImageView * titleImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * titleImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * titleImageLeftConstraint;

@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) MyNewGameReserveListCell * currentPlayingCell;

@end

NS_ASSUME_NONNULL_END
