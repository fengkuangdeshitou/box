//
//  MyProjectGameController.m
//  Game789
//
//  Created by Maiyou on 2018/12/6.
//  Copyright © 2018 yangyong. All rights reserved.
//

#import "MyProjectGameController.h"
#import "MyHomeCouponCenterController.h"

#import "GameTableViewCell.h"
#import "MyHomeGameListApi.h"
#import "HomeProjectMediaCell.h"
#import "UIScrollView+ListViewAutoplaySJAdd.h"
#import "HomeProjectDescCell.h"
#import "MyReceiveFirstChargeCell.h"

@class MyGetProjectGameApi;

@interface MyProjectGameController () <UITableViewDelegate, UITableViewDataSource, SJVideoPlayerControlLayerDelegate>

@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) NSInteger style;
@property (nonatomic, assign) NSInteger currentSection;

@end

@implementation MyProjectGameController

- (SJVideoPlayer *)player{
    if (!_player) {
        _player = [SJVideoPlayer player];
    }
    return _player;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.player vc_viewWillDisappear];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.player vc_viewDidDisappear];
}

- (void)prepareBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProjectGameList) name:@"receiveGiftSuccess" object:nil];
    self.currentSection = -1;
    if (self.dataDic)
    {
        self.navBar.title = self.dataDic[@"title"];
        [self.tableView reloadData];
        //统计专题
        [MyAOPManager relateStatistic:@"BrowseTheTopicDetailsPage" Info:@{@"title" : self.dataDic[@"title"]}];

        NSString * key = [NSString stringWithFormat:@"%@list", self.type];
        self.dataArray = self.dataDic[key];
    }
    else
    {
        self.navBar.title = self.project_title ? self.project_title : @"专题游戏";
        [self getProjectGameList];
    }
}

- (void)getProjectGameList
{
    MyGetProjectGameApi * api = [[MyGetProjectGameApi alloc] init];
    api.isShow = YES;
    api.count = 100;
    api.project_id = self.project_id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSDictionary * dic = request.data;
            //统计专题
            [MyAOPManager relateStatistic:@"BrowseTheTopicDetailsPage" Info:@{@"title" : dic[@"title"]}];
            self.navBar.title = dic[@"title"];
            
            self.dataDic = request.data;
            self.style = [request.data[@"style"] integerValue];
            self.dataArray = dic[@"projectGameslist"];
            //0元首充
            if (self.style == 5)
            {
                NSMutableArray * array = [NSMutableArray array];
                for (NSDictionary * data in dic[@"projectGameslist"])
                {
                    MyWelfareCenterGameModel * model = [MyWelfareCenterGameModel mj_objectWithKeyValues:data];
                    model.data = data;
                    [array addObject:model];
                }
                self.dataArray = array;
            }
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:api.error_desc toView:self.view];
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    [self playVideo];
}

- (void)playVideo
{
    NSString * type = self.dataDic[@"gameinfo_bg_type"];
    if ([type isEqualToString:@"image"]) {
        return;
    }

    CGFloat offSetY = self.tableView.contentOffset.y + self.tableView.height/2;
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(0, offSetY)];
    if (self.currentSection == indexPath.section) {
        return;
    }
    [self.player stopAndFadeOut];
    self.player = [SJVideoPlayer player];
    self.currentSection = indexPath.section;
    NSIndexPath * mediaIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
    NSDictionary * item = self.dataArray[indexPath.section];
    HomeProjectMediaCell *cell = [self.tableView cellForRowAtIndexPath:mediaIndexPath];
    self.player.view.frame = cell.gameIcon.frame;
    self.player.view.layer.cornerRadius = 13;
    self.player.view.layer.masksToBounds = YES;
    [cell.contentView addSubview:self.player.view];
    SJPlayModel * model = [SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:10 atIndexPath:mediaIndexPath tableView:self.tableView];
    self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:item[@"game_video_url"]] playModel:model];
//    self.player.mute = YES;
//    _player.lockedScreen = YES;
    self.player.disableAutoRotation = YES;
    self.player.autoPlayWhenPlayStatusIsReadyToPlay = YES;
    [self.player play];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self playVideo];
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self creatHeaderView];
        _tableView.tableFooterView = [self creatFooterView];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerNib:[UINib nibWithNibName:@"HomeProjectDescCell" bundle:nil] forCellReuseIdentifier:@"HomeProjectDescCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HomeProjectMediaCell" bundle:nil] forCellReuseIdentifier:@"HomeProjectMediaCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:nil] forCellReuseIdentifier:@"GameTableViewCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MyReceiveFirstChargeCell" bundle:nil] forCellReuseIdentifier:@"MyReceiveFirstChargeCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)creatHeaderView
{
//    NSString * big_block_color = self.dataDic[@"big_block_color"];
//    UIColor * color = [UIColor colorWithHexString:![big_block_color isBlankString] ? big_block_color : @"#ffffff"];
    
//    NSString * tips_bg_color = self.dataDic[@"tips_bg_color"];
//    UIColor * color1 = [UIColor colorWithHexString:![tips_bg_color isBlankString] ? tips_bg_color : @"#ffffff"];
//    
//    NSString * tips_font_color = self.dataDic[@"tips_font_color"];
//    UIColor * color2 = [UIColor colorWithHexString:![tips_font_color isBlankString] ? tips_font_color : @"#ffffff"];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 211 / 375)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, view.height)];
    if (![YYToolModel isBlankString:self.dataDic[@"top_image"]])
    {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"top_image"]] placeholderImage:MYGetImage(@"banner_photo")];
    }
    imageView.layer.cornerRadius = 1;
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imageView];
    
    CGFloat viewHeight = 0;
    if (![self.dataDic[@"desc"] isBlankString])
    {
        if ([self.dataDic[@"style"] intValue] == 2)
        {
            CGSize size = [YYToolModel sizeWithText:self.dataDic[@"desc"] size:CGSizeMake(kScreenW - 30 - 10.5*2, MAXFLOAT) font:[UIFont systemFontOfSize:14]];
            UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(15, imageView.bottom + 13, kScreenW - 30, size.height + 11.5 * 2)];
            backView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
            backView.layer.cornerRadius = 13;
            backView.layer.masksToBounds = YES;
            [view addSubview:backView];
            
            UILabel * des_label = [[UILabel alloc] initWithFrame:CGRectMake(10.5, 11.5, backView.width - 10.5*2, size.height)];
            des_label.font = [UIFont systemFontOfSize:14];
            des_label.textColor = [UIColor colorWithHexString:@"#282828"];
            des_label.text = self.dataDic[@"desc"];
            des_label.numberOfLines = 0;
            [backView addSubview:des_label];
            
            viewHeight = backView.bottom + 13;
        }
        else
        {
            CGSize size = [YYToolModel sizeWithText:self.dataDic[@"desc"] size:CGSizeMake(kScreenW - 30, MAXFLOAT) font:[UIFont systemFontOfSize:14]];
            UILabel * des_label = [[UILabel alloc] initWithFrame:CGRectMake(15, imageView.bottom + 13, kScreenW - 30, size.height)];
            des_label.font = [UIFont systemFontOfSize:14];
            des_label.textColor = FontColor28;
            des_label.text = self.dataDic[@"desc"];
            des_label.numberOfLines = 0;
            [view addSubview:des_label];
            
            viewHeight = des_label.bottom + 13;
        }
    }
    else
    {
        viewHeight = imageView.bottom + 13;
    }
    
    if ([self.dataDic[@"is_show_jump_voucher"] boolValue])
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.frame = CGRectMake(15, viewHeight, kScreenW - 30, (kScreenW - 30) * 75 / 345);
        NSString * gifPathSource = [[NSBundle mainBundle] pathForResource:@"more_game_voucher" ofType:@"gif"];
        [button sd_setImageWithURL:[NSURL fileURLWithPath:gifPathSource] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moreVoucherBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        viewHeight = button.bottom + 20;
    }
    
    view.height = viewHeight;
    return view;
}

- (void)moreVoucherBtnClick
{
    [MyAOPManager userInfoRelateStatistic:@"ClickToReceiveMoreVoucher"];
    
    [self.navigationController pushViewController:[MyHomeCouponCenterController new] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.style == 1) {
        GameModel * model = [GameModel mj_objectWithKeyValues:self.dataArray[indexPath.section]];
        return model.cellHeight+25;
    }else if (self.style == 2 || (self.style == 3 && indexPath.section % 5 == 0)) {
        GameModel * model = [GameModel mj_objectWithKeyValues:self.dataArray[indexPath.section]];
        CGFloat descheight = model.fuli_desc.length == 0 ? 0 : [[model.fuli_desc stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n"] boundingRectWithSize:CGSizeMake(ScreenWidth-30-26, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
        return model.cellHeight+25 + (ScreenWidth-56)*9/16+29+(descheight > 62 ? 62 : descheight);
    }else if (self.style == 4) {
        GameModel * model = [GameModel mj_objectWithKeyValues:self.dataArray[indexPath.section]];
        return model.cellHeight+25+183;
    }else if (self.style == 5) {
        MyWelfareCenterGameModel * welfareModel = self.dataArray[indexPath.section];
        GameModel * model = [GameModel mj_objectWithKeyValues:welfareModel.data];
        return model.cellHeight+20+54;
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.style == 2 || (self.style == 3 && indexPath.section % 5 == 0)) {
        NSString * type = self.dataDic[@"gameinfo_bg_type"];
        static NSString * identifier = @"HomeProjectMediaCell";
        HomeProjectMediaCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary * dic = self.dataArray[indexPath.section];
        cell.descLabel.text = [dic[@"fuli_desc"] stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n"];
        if ([type isEqualToString:@"image"]){
            [cell.gameIcon sd_setImageWithURL:[NSURL URLWithString:dic[@"image"]] placeholderImage:MYGetImage(@"banner_photo")];
            cell.playButton.hidden = YES;
        }else if([type isEqualToString:@"video"]){
            NSString * image = dic[@"image"];
            if (image.length > 0) {
                [cell.gameIcon sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:MYGetImage(@"banner_photo")];
            }else{
                [cell.gameIcon sd_setImageWithURL:[NSURL URLWithString:dic[@"game_video_thumb"]] placeholderImage:MYGetImage(@"banner_photo")];
            }
            cell.playButton.hidden = NO;
        }
        [cell.playButton addTarget:self action:@selector(playVideoAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.gameCell.viewTop = 5;
        [cell.gameCell setModelDic:dic];
        [YYToolModel clipRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight radius:13 view:cell.gameCell.radiusView];
        [YYToolModel clipRectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:13 view:cell.radiusView];
        return cell;
    }else if (self.style == 4){
        HomeProjectDescCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HomeProjectDescCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"HomeProjectDescCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary * data = self.dataArray[indexPath.section];
        cell.data = data;
        [YYToolModel clipRectCorner:UIRectCornerTopLeft | UIRectCornerTopRight radius:13 view:cell.gameCell.radiusView];
        [YYToolModel clipRectCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:13 view:cell.radiusView];
        return cell;
    }else if (self.style == 5){
        static NSString * identifier = @"MyReceiveFirstChargeCell";
        MyReceiveFirstChargeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"MyReceiveFirstChargeCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MyWelfareCenterGameModel * model = self.dataArray[indexPath.section];
        cell.gameModel = model;
        return cell;
    }else{
        static NSString * identifity = @"GameTableViewCell";
        GameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifity];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GameTableViewCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.currentVC = self;
        cell.source = @"home";
        cell.containViewHeight = 20;
        [cell setModelDic:self.dataArray[indexPath.section]];
        [YYToolModel clipRectCorner:UIRectCornerAllCorners radius:13 view:cell.radiusView];
        return cell;
    }
}

- (void)playVideoAction:(UIButton *)btn{
    btn.hidden = YES;
    [self.player stopAndFadeOut];
    self.player = [SJVideoPlayer player];
    HomeProjectMediaCell * cell = (HomeProjectMediaCell *)[[[btn superview] superview] superview];
    self.player.view.frame = cell.gameIcon.frame;
    self.player.view.layer.cornerRadius = 13;
    self.player.view.layer.masksToBounds = YES;
    [cell.radiusView addSubview:self.player.view];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    self.currentSection = indexPath.section;
    NSDictionary * item = self.dataArray[indexPath.section];
    SJPlayModel * model = [SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:10 atIndexPath:indexPath tableView:self.tableView];
    self.player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:item[@"game_video_url"]] playModel:model];
    self.player.playerViewWillDisappearExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
        [videoPlayer stopAndFadeOut];
    };
}
//- (void)videoPlayer:(__kindof SJBaseVideoPlayer *)videoPlayer statusDidChanged:(SJVideoPlayerPlayStatus)status{
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:self.currentSection];
//    HomeProjectMediaCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
////    cell.playButton.hidden = status == SJVideoPlayerPlayStatusPlaying;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArray[indexPath.section];
    NSString * newsid = @"";
    if (self.style == 2){
        NSString * fuli_type = self.dataDic[@"fuli_type"];
        NSString * newid = [NSString stringWithFormat:@"%@",dic[@"newid"]];
        if ([fuli_type isEqualToString:@"news"] && newid.length > 0) {
            newsid = newid;
        }
    }
    if (self.style == 5)
    {
        MyWelfareCenterGameModel * model = self.dataArray[indexPath.section];
        dic = model.data;
    }
    [self gameContentTableCellBtn:dic Newsid:newsid];
}

- (void)gameContentTableCellBtn:(NSDictionary *)dic Newsid:(NSString *)newsid
{
    //专题详情的游戏点击
    NSMutableDictionary * tplDic = [NSMutableDictionary dictionary];
    [tplDic setValue:[self.dataDic objectForKey:@"title"] forKey:@"title"];
    [tplDic setValue:@"detail" forKey:@"clickIndex"];
    [MyAOPManager gameRelateStatistic:@"ClickTheGameInTheTopic" GameInfo:dic Add:tplDic];
    
    GameDetailInfoController * detailVC = [[GameDetailInfoController alloc] init];
    detailVC.gameID = [dic objectForKey:@"game_id"];
    detailVC.hidesBottomBarWhenPushed = YES;
    if (newsid.length > 0)
    {
        detailVC.isShowActivityAlert = true;
        detailVC.newid = newsid;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
