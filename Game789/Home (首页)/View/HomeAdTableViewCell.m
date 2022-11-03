//
//  HomeAdTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2017/9/2.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "HomeAdTableViewCell.h"
#import "MyActivityBunnerImageCell.h"
#import "NoticeDetailViewController.h"
#import "UserGoldCoinsViewController.h"

@interface HomeAdTableViewCell ()

@end

@implementation HomeAdTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    (dataArray.count > 1) ? (self.pageRollView.interval = 3) : (self.pageRollView.interval = 0);
    (dataArray.count > 1) ? (self.pageRollView.scrollEnabled = YES) : (self.pageRollView.scrollEnabled = 0);
    
    self.pageRollView.sourceArray = [NSMutableArray arrayWithArray:self.dataArray];
    [self.pageRollView reloadData];
}

- (WSLRollView *)pageRollView
{
    if (!_pageRollView)
    {
        _pageRollView = [[WSLRollView alloc] initWithFrame:CGRectMake(15, 8, kScreenW - 30, 160)];
        _pageRollView.backgroundColor = [UIColor whiteColor];
        _pageRollView.scrollStyle = WSLRollViewScrollStylePage;
        _pageRollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _pageRollView.loopEnabled = YES;
        _pageRollView.interval = 3;
        _pageRollView.delegate = self;
        _pageRollView.layer.cornerRadius = 8;
        _pageRollView.layer.masksToBounds = YES;
        [_pageRollView registerNib:[UINib nibWithNibName:@"MyActivityBunnerImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PageRollID"];
        [self addSubview:_pageRollView];
    }
    return _pageRollView;
}

#pragma mark - WSLRollViewDelegate
//返回itemSize
- (CGSize)rollView:(WSLRollView *)rollView sizeForItemAtIndex:(NSInteger)index{
    
    return self.pageRollView.size;
}

//间隔
- (CGFloat)spaceOfItemInRollView:(WSLRollView *)rollView
{
    return 0;
}

//内边距
- (UIEdgeInsets)paddingOfRollView:(WSLRollView *)rollView
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//返回自定义cell样式
- (WSLRollViewCell *)rollView:(WSLRollView *)rollView cellForItemAtIndex:(NSInteger)index
{
    MyActivityBunnerImageCell * cell = (MyActivityBunnerImageCell *)[rollView dequeueReusableCellWithReuseIdentifier:@"PageRollID" forIndex:index];
    NSString * str = self.dataArray[index][@"banner_image"][@"thumb"];
    [cell.bunnerImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:MYGetImage(@"banner_photo")];
//    cell.bunnerImageView.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}

//点击事件
- (void)rollView:(WSLRollView *)rollView didSelectItemAtIndex:(NSInteger)index
{
//    NSDictionary * dic = self.dataArray[index];
//    GameDetailInfoController * info = [GameDetailInfoController new];
//    info.gameID = dic[@"banner_id"];
//    info.hidesBottomBarWhenPushed = YES;
//    [self.currentVC.navigationController pushViewController:info animated:YES];
    
    NSDictionary * dic = self.dataArray[index];
    if ([dic[@"banner_type"] isEqualToString:@"game_info"]) {
        //游戏详情
        GameDetailInfoController *detailVC = [[GameDetailInfoController alloc] init];
        detailVC.gameID = dic[@"banner_id"];
        //        detailVC.title = dic[@"game_name"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:detailVC animated:YES];
    }
    else if ([dic[@"banner_type"] isEqualToString:@"news_info"]) {
        //资讯详情
        NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] init];
        detailVC.news_id = dic[@"banner_id"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.currentVC.navigationController pushViewController:detailVC animated:YES];
    }
    else if ([dic[@"banner_type"] isEqualToString:@"outer_web"]) {
        //web 外部
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dic[@"banner_id"]]];
    }
    else if ([dic[@"banner_type"] isEqualToString:@"inner_web"])
    {
        if (![YYToolModel islogin])
        {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
            [self.currentVC.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        NSString * url = [NSString stringWithFormat:@"%@?username=%@&token=%@", dic[@"banner_id"], [YYToolModel getUserdefultforKey:@"user_name"], [YYToolModel getUserdefultforKey:TOKEN]];
        //web详情
        UserGoldCoinsViewController *webVC = [[UserGoldCoinsViewController alloc] init];
        webVC.hidesBottomBarWhenPushed = YES;
        webVC.url = url;
        [self.currentVC.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)rollView:(WSLRollView *)rollView didRollItemToIndex:(NSInteger)currentIndex
{
    if (self.RollItemToIndex)
    {
        self.RollItemToIndex(currentIndex, self);
    }
}

@end
