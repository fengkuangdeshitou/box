//
//  RecommendViewController.m
//  Game789
//
//  Created by maiyou on 2021/11/23.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendTextCell.h"
#import "RecommendActivityCell.h"
#import "HGGameScreenshotsCell.h"
#import "RecommendVideoCell.h"
#import "SJVideoPlayer.h"
#import "SJBaseVideoPlayer.h"
#import "OneGameAPI.h"
#import "UIScrollView+ListViewAutoplaySJAdd.h"
CGFloat fixedHeight = 40 + 50 + 3;

@interface RecommendViewController ()<UITableViewDelegate,UITableViewDataSource,SJPlayerAutoplayDelegate>

@property(nonatomic,weak) IBOutlet NSLayoutConstraint * tableViewTopConstraint;
@property(nonatomic,weak) IBOutlet NSLayoutConstraint * backViewHeight;
@property(nonatomic,weak) IBOutlet UIView * colorView;
@property(nonatomic,strong) UIButton * button;

@property(nonatomic,strong) NSArray * titleArray;
@property(nonatomic,strong) UIImageView * icon;
@property(nonatomic,strong) NSDictionary * data;
@property(nonatomic,strong) SJVideoPlayer * player;

@property(nonatomic,strong)id<SJPlayStatusObserver> playStatusObserver;
@property(nonatomic,strong)CAGradientLayer * gradintLayer;
@end

@implementation RecommendViewController

- (CAGradientLayer *)gradintLayer{
    if (!_gradintLayer) {
        _gradintLayer = [CAGradientLayer layer];
        _gradintLayer.frame = CGRectMake(0, 0, ScreenWidth, 80);
        _gradintLayer.startPoint = CGPointMake(0.5, 0);
        _gradintLayer.endPoint = CGPointMake(0.5, 1);
    }
    return _gradintLayer;
}

- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _icon;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(ScreenWidth/2-182/2, ScreenWidth+8, 182, 44);
        [_button setImage:[UIImage imageNamed:@"recomment_download"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(gameDetail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)gameDetail{
    GameDetailInfoController * detail = [[GameDetailInfoController alloc] init];
    detail.gameID = self.data[@"game_info"][@"game_id"];
    [self.navigationController pushViewController:detail animated:true];
}

- (SJVideoPlayer *)player{
    if (!_player) {
        _player = [SJVideoPlayer lightweightPlayer];
        _player.autoPlayWhenPlayStatusIsReadyToPlay = true;
        _player.resumePlaybackWhenPlayerViewScrollAppears = true;
    }
    return _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navBar.hidden = true;
    self.backViewHeight.constant = kStatusBarAndNavigationBarHeight;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableViewTopConstraint.constant = kStatusBarAndNavigationBarHeight;
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth+61)];
    [header addSubview:self.icon];
    
    self.tableView.tableHeaderView = header;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameDetail) name:@"pushTuGameDetail" object:nil];
    self.titleArray = @[@"代金券/礼包",@"",@"",@"游戏特色",@"游戏活动",@"游戏攻略",@"热门点评"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendTextCell" bundle:nil] forCellReuseIdentifier:@"RecommendTextCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HGGameScreenshotsCell" bundle:nil] forCellReuseIdentifier:@"HGGameScreenshotsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendActivityCell" bundle:nil] forCellReuseIdentifier:@"RecommendActivityCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendVideoCell" bundle:nil] forCellReuseIdentifier:@"RecommendVideoCell"];
    [self requestGameData];
    
    self.tableView.mj_header = [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestGameData];
    }];
    [self.tableView sj_enableAutoplayWithConfig:[SJPlayerAutoplayConfig configWithPlayerSuperviewTag:10 autoplayDelegate:self]];
}

- (void)sj_playerNeedPlayNewAssetAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 1) {
        return;
    }
    RecommendVideoCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.player.view.frame = cell.pic.bounds;
    [cell.pic addSubview:self.player.view];
    SJUITableViewCellPlayModel * model = [[SJUITableViewCellPlayModel alloc] initWithPlayerSuperview:cell.pic atIndexPath:indexPath tableView:self.tableView];
    SJVideoPlayerURLAsset * asset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.data[@"game_info"][@"video_url"]] playModel:model];
    self.playStatusObserver = [self.player getPlayStatusObserver];

    self.playStatusObserver.playStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        if (player.playStatus == SJVideoPlayerPlayStatusPrepare || player.playStatus == SJVideoPlayerPlayStatusPlaying) {
            cell.cover.hidden = true;
            cell.play.hidden = true;
        }else if (player.playStatus == SJVideoPlayerPlayStatusPaused) {
            cell.cover.hidden = false;
            cell.play.hidden = false;
//            weakSelf.player.autoPlayWhenPlayStatusIsReadyToPlay = false;
//            weakSelf.player.resumePlaybackWhenPlayerViewScrollAppears = false;
//            [weakSelf.tableView sj_disenableAutoplay];
        }
    };
    self.player.playDidToEndExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        [player replay];
    };
    self.player.URLAsset = asset;
    [self.player play];
}

- (void)requestGameData{
    OneGameAPI * api = [[OneGameAPI alloc] init];
    api.gameId = self.gameId;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self.tableView.tableHeaderView addSubview:self.button];
        self.data = request.data;
        self.colorView.backgroundColor = [UIColor colorWithHexString:self.data[@"game_info"][@"banner_color"]];
        self.view.backgroundColor = [UIColor colorWithHexString:self.data[@"game_info"][@"banner_light"]];
        [self.icon sd_setImageWithURL:[NSURL URLWithString:self.data[@"game_info"][@"banner_750"]]
                     placeholderImage:MYGetImage(@"game_icon")];
        self.gradintLayer.colors = @[(__bridge id)self.colorView.backgroundColor.CGColor,(__bridge id)[self.colorView.backgroundColor colorWithAlphaComponent:0].CGColor];
        [self.icon.layer insertSublayer:self.gradintLayer atIndex:0];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)playVideo:(UIButton *)btn{
    RecommendVideoCell * cell = (RecommendVideoCell *)[[btn superview] superview];
    cell.cover.hidden = true;
    cell.play.hidden = true;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    SJUITableViewCellPlayModel * model = [[SJUITableViewCellPlayModel alloc] initWithPlayerSuperview:cell.pic atIndexPath:indexPath tableView:self.tableView];
    self.player.view.frame = cell.pic.bounds;
    [cell.pic addSubview:self.player.view];
    SJVideoPlayerURLAsset * asset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.data[@"game_info"][@"video_url"]] playModel:model];
    self.playStatusObserver = [self.player getPlayStatusObserver];
    self.playStatusObserver.playStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        if (player.playStatus == SJVideoPlayerPlayStatusPrepare || player.playStatus == SJVideoPlayerPlayStatusPlaying) {
            cell.cover.hidden = true;
            cell.play.hidden = true;
        }else if (player.playStatus == SJVideoPlayerPlayStatusPaused) {
            cell.cover.hidden = false;
            cell.play.hidden = false;
        }
    };
    self.player.URLAsset = asset;
    [self.player play];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player vc_viewDidAppear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player vc_viewDidDisappear];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player vc_viewWillDisappear];
}

- (void)stopPlayVideo{
    if (self.player.playStatus == SJVideoPlayerPlayStatusPlaying) {
        [self.player pause];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        RecommendActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendActivityCell" forIndexPath:indexPath];
        cell.style = RecommendStyleGifs;
        cell.titleLabel.text = self.titleArray[indexPath.section];
        cell.dataArray = self.data[@"game_info"][@"gift_bag_list"];
        cell.voucherslist = self.data[@"voucherslist"];
        cell.vc = self;
        return cell;
    }else if (indexPath.section == 1) {
        RecommendVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendVideoCell" forIndexPath:indexPath];
        [cell.play addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.pic sd_setImageWithURL:[NSURL URLWithString:self.data[@"game_info"][@"video_img_url"]] placeholderImage:MYGetImage(@"game_icon")];
        return cell;
    }else if(indexPath.section == 2){
        static NSString *reuseID = @"HGGameScreenshotsCell";
        HGGameScreenshotsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
        cell.contentView.backgroundColor = self.tableView.backgroundColor;
        cell.collectionView.backgroundColor = self.view.backgroundColor;
        cell.backgroundColor = self.tableView.backgroundColor;
        cell.collectionView.contentInset = UIEdgeInsetsMake(-20, -10, -10, 0);
        cell.dataArray = self.data[@"game_info"][@"game_ur_list"];
        return cell;
    }else if (indexPath.section == 3){
        RecommendTextCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTextCell" forIndexPath:indexPath];
        cell.imageTopConstraint.constant = 0;
        cell.imageHeightConstraint.constant = 0;
        cell.titleLabel.text = self.titleArray[indexPath.section];
        cell.contentLabel.numberOfLines = 6;
        cell.contentLabel.text = self.data[@"game_info"][@"summary"];
        return cell;
    }else if (indexPath.section == 4){
        RecommendActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendActivityCell" forIndexPath:indexPath];
        cell.style = RecommendStyleActivity;
        cell.dataArray = self.data[@"game_info"][@"game_activity"];
        cell.titleLabel.text = self.titleArray[indexPath.section];
        return cell;
    }else if (indexPath.section == 5){
        RecommendTextCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendTextCell" forIndexPath:indexPath];
        cell.titleLabel.text = self.titleArray[indexPath.section];
        cell.contentLabel.text = self.data[@"game_info"][@"introduction"];
        cell.contentLabel.numberOfLines = 5;
        [cell.banner sd_setImageWithURL:[NSURL URLWithString:self.data[@"game_info"][@"banner_url"]] placeholderImage:MYGetImage(@"game_icon")];
        return cell;
    }else if (indexPath.section == 6){
        RecommendActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendActivityCell" forIndexPath:indexPath];
        cell.style = RecommendStyleComment;
        cell.titleLabel.text = self.titleArray[indexPath.section];
        cell.dataArray = self.data[@"comments"];
        return cell;
    }else{
        static NSString * cellIdentifity = @"RecommendStyleImageCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifity];
        }
        cell.contentView.backgroundColor = self.tableView.backgroundColor;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3 || indexPath.section == 5) {
        [self gameDetail];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.data == nil) {
        return 0;
    }
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat voucherHeight = 0;
        if ([self.data[@"voucherslist"] count] > 0) {
            voucherHeight = 65;
        }
        return [self.data[@"game_info"][@"gift_bag_list"] count] * 99 - 10 + fixedHeight + voucherHeight;
    }else if(indexPath.section == 1){
        return 194;
    }else if(indexPath.section == 2){
        return 210;
    }else if(indexPath.section == 4){
        return [self.data[@"game_info"][@"game_activity"] count] * 28 + fixedHeight;
    }
     
     if (indexPath.section == 6) {
         CGFloat contentHeight = 0;
         CGFloat footerHeight = 0;
         NSArray * comment = self.data[@"comments"];
         if (comment.count > 0) {
             footerHeight = (comment.count-1)*15;
         }
         for (NSDictionary * obj in comment) {
             NSString * content = obj[@"content"];
             CGSize size = [content boundingRectWithSize:CGSizeMake(ScreenWidth-30-46, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
             if (size.height > 75) {
                 contentHeight += 75;
             }else{
                 contentHeight += size.height;
             }
         }
         return comment.count*(44+47)+fixedHeight+contentHeight+footerHeight;
     }
     
    return UITableViewAutomaticDimension;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y <= 0) {
            self.backViewHeight.constant = -scrollView.contentOffset.y + kStatusBarAndNavigationBarHeight+SCREEN_WIDTH;
        }else{
            self.backViewHeight.constant = kStatusBarAndNavigationBarHeight;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
