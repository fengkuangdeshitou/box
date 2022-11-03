//
//  MyActivityBunnerCell.m
//  Game789
//
//  Created by Maiyou on 2019/10/26.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyActivityBunnerCell.h"
#import "MyActivityBunnerImageCell.h"
#import "NoticeDetailViewController.h"
#import "MyProjectGameController.h"

@implementation MyActivityBunnerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    //活动banner显示统计
    [MyAOPManager userInfoRelateStatistic:@"ShowHomePageActivityBanner"];
    
    (dataArray.count > 1) ? (self.pageRollView.interval = 3) : (self.pageRollView.interval = 0);
    (dataArray.count > 1) ? (self.pageRollView.scrollEnabled = YES) : (self.pageRollView.scrollEnabled = 0);
    
    self.pageRollView.sourceArray = [NSMutableArray arrayWithArray:dataArray];
    [self.pageRollView reloadData];
}

- (WSLRollView *)pageRollView
{
    if (!_pageRollView)
    {
        WSLRollView * pageRollView = [[WSLRollView alloc] initWithFrame:CGRectMake(15, 10, kScreenW - 30, (kScreenW - 30) * 170 / 690)];
        pageRollView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
        pageRollView.scrollStyle = WSLRollViewScrollStylePage;
        pageRollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        pageRollView.loopEnabled = YES;
        pageRollView.interval = 3;
        pageRollView.delegate = self;
        pageRollView.layer.cornerRadius = 8;
        pageRollView.layer.masksToBounds = YES;
        [pageRollView registerNib:[UINib nibWithNibName:@"MyActivityBunnerImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PageRollID"];
        [self.contentView addSubview:pageRollView];
        _pageRollView = pageRollView;
    }
    return _pageRollView;
}

#pragma mark - WSLRollViewDelegate
//返回itemSize
- (CGSize)rollView:(WSLRollView *)rollView sizeForItemAtIndex:(NSInteger)index{
    
    return rollView.size;
}

//间隔
- (CGFloat)spaceOfItemInRollView:(WSLRollView *)rollView
{
    return 0;
}

//内边距
- (UIEdgeInsets)paddingOfRollView:(WSLRollView *)rollView{
    
    return UIEdgeInsetsMake(0,0,0,0);
}

//点击事件
- (void)rollView:(WSLRollView *)rollView didSelectItemAtIndex:(NSInteger)index
{
    //活动banner点击统计
    [MyAOPManager userInfoRelateStatistic:@"ClickHomePageActivityBanner"];
    
    MYLog(@" 点击了 %ld",index);
    NSDictionary * dic = self.dataArray[index];
    UIViewController * vc = [YYToolModel getCurrentVC];
    if ([dic[@"type"] isEqualToString:@"special"] && [dic[@"value"] isKindOfClass:[NSDictionary class]])
    {
        //专题
        MyProjectGameController * project = [MyProjectGameController new];
        project.hidesBottomBarWhenPushed = YES;
        project.project_id    =  dic[@"value"][@"id"];
        project.project_title =  dic[@"value"][@"title"];
        [vc.navigationController pushViewController:project animated:YES];
    }
    else
    {
        if ([dic[@"is_check_login"] boolValue] && ![YYToolModel isAlreadyLogin])
        {
            return;
        }
        [[YYToolModel shareInstance] showUIFortype:dic[@"type"] Parmas:dic[@"value"]];
    }
}

//返回自定义cell样式
- (WSLRollViewCell *)rollView:(WSLRollView *)rollView cellForItemAtIndex:(NSInteger)index
{
    MyActivityBunnerImageCell * cell = (MyActivityBunnerImageCell *)[rollView dequeueReusableCellWithReuseIdentifier:@"PageRollID" forIndex:index];
    cell.bunnerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.bunnerImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[index][@"img"]] placeholderImage:MYGetImage(@"banner_photo_corner")];
    cell.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
    return cell;
}

@end
