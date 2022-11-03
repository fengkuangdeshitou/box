//
//  MyHomeVideoListCell.h
//  Game789
//
//  Created by Maiyou on 2020/8/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNewGameReserveListCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyHomeVideoListCell : UITableViewCell <WSLRollViewDelegate, SJVideoPlayerControlLayerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (nonatomic, strong) WSLRollView *pageRollView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, copy) NSString *type;
@property (weak, nonatomic) IBOutlet UIImageView * titleImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * titleImageWidthConstraint;
@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) MyNewGameReserveListCell * currentPlayingCell;

- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
