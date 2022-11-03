//
//  SpecialTopicGameCell.m
//  Game789
//
//  Created by Maiyou on 2018/12/5.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "SpecialTopicGameCell.h"
#import "MyProjectGameController.h"

@implementation SpecialTopicGameCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModelDic:(NSDictionary *)dic
{
    self.dataDic = dic;
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"project_banner"]] placeholderImage:[UIImage imageNamed:@"banner_photo"]];
    
    self.gameTypeTitle.text = dic[@"project_title"];
    
    NSArray * game_list = dic[@"game_list"];
    
    NSInteger count = IS_IPhoneX_All ? 6 : 5;
    CGFloat button_width = 40;
    CGFloat button_x = 20;
    CGFloat button_margin = (kScreenW - 60 - button_width * count - button_x) / count;
    for (int i = 0; i < game_list.count; i ++)
    {
        if (i == count)
        {
            break;
        }
//        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(button_margin + (button_margin + button_width) * i, CGRectGetMaxY(self.backImageView.frame) + 8, button_width, 40)];
        NSDictionary * dic = game_list[i];
        
        NSString * url = dic[@"game_image"][@"thumb"];
//        NSString * string = [YYToolModel contentTypeForImageData:url];
//        if ([string isEqualToString:@"gif"])
//        {
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//            [button setImage:[UIImage sd_animatedGIFWithData:data] forState:0];
//        }
//        else
//        {
        YYAnimatedImageView * imageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(button_x + (button_margin + button_width) * i, CGRectGetMaxY(self.backImageView.frame) + 8, button_width, 40)];
            [imageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:MYGetImage(@"game_icon")];
//        }
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
//        [button addTarget:self action:@selector(viewGameDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewGameDetailAction:)];
        [imageView addGestureRecognizer:tap];
    }
}
#pragma mark - 查看游戏详情
- (void)viewGameDetailAction:(UITapGestureRecognizer *)tap
{
    YYAnimatedImageView * imageView = (YYAnimatedImageView*) tap.view;
    NSArray * game_list = self.dataDic[@"game_list"];
    NSDictionary * dic = game_list[imageView.tag];
    [self gameContentTableCellBtn:dic];
}

- (void)gameContentTableCellBtn:(NSDictionary *)dic
{
    GameDetailInfoController * detailVC = [[GameDetailInfoController alloc] init];
    detailVC.gameID = dic[@"game_id"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)moreButtonAction:(id)sender
{
    [self pushProjectGames];
}

- (void)pushProjectGames
{
    MyProjectGameController * project = [MyProjectGameController new];
    project.dataDic = self.dataDic;
    project.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:project animated:YES];
}

@end
