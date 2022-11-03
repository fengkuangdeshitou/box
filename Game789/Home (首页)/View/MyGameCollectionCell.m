//
//  MyGameCollectionCell.m
//  Game789
//
//  Created by Maiyou on 2018/12/5.
//  Copyright © 2018 yangyong. All rights reserved.
//

#import "MyGameCollectionCell.h"
#import "MyProjectGameController.h"

@implementation MyGameCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //设置渐变色背景
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.viewButton.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHexString:@"#00CC8A"].CGColor,(id)[UIColor colorWithHexString:@"#52EECA"].CGColor, nil];
    [self.viewButton.layer addSublayer:gradient];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1.0, 0);
    self.viewButton.layer.masksToBounds = YES;
    self.viewButton.layer.cornerRadius = 13;
}

- (void)setModelDic:(NSDictionary *)dic
{
    self.dataDic = dic;
    
    self.showTitle.text  = dic[@"project_title"];
    self.showDetail.text = dic[@"project_desc"];
    
    CGSize size = [YYToolModel sizeWithText:dic[@"project_label"] size:CGSizeMake(MAXFLOAT, self.showMark.height) font:self.showMark.font];
    self.showMark.text = dic[@"project_label"];
    self.showMark_width.constant = size.width + 15;
    
    NSString * imageName = ([dic[@"project_icon"] isEqualToString:@""] || [dic[@"project_icon"] isKindOfClass:[NSNull class]]) ? @"main_game_collection" : dic[@"project_icon"];
    self.game_icon.image = [UIImage imageNamed:imageName];
}


- (IBAction)viewButtonAction:(id)sender
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
