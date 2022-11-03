//
//  MyGameHallBannerCell.m
//  Game789
//
//  Created by Maiyou on 2020/10/13.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameHallBannerCell.h"

@implementation MyGameHallBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSString *url = [[dataDic objectForKey:@"game_image"] objectForKey:@"thumb"];
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:url] placeholder:MYGetImage(@"game_icon")];
    
    [self.imageViews yy_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholder:MYGetImage(@"game_icon")];
    
    NSString *class_type = dataDic[@"game_classify_type"];
    self.titleLabel.text = dataDic[@"game_name"];
    
    //返回福利标签或是一句话  如果有详情介绍，显示，没有显示送VIP送福利
    NSString * introduction = dataDic[@"introduction"];
    self.firstTagLabel.hidden = YES;
    self.secondTagLabel.hidden = YES;
    self.thirdTagLabel.hidden = YES;
    self.showDetail.hidden = YES;
    NSString *desc = dataDic[@"game_desc"];
    if ([desc containsString:@"+"])
    {
        NSArray *tagArray = [desc componentsSeparatedByString:@"+"];
        for (int i = 0; i < tagArray.count; i ++)
        {
            NSString * str = [NSString stringWithFormat:@"%@", tagArray[i]];
            str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (i == 0)
            {
                self.firstTagLabel.hidden = NO;
                self.firstTagLabel.text  = str;
            }
            else if (i == 1)
            {
                self.secondTagLabel.hidden = NO;
                self.secondTagLabel.text = str;
            }
            else if (i == 2)
            {
                self.thirdTagLabel.hidden = NO;
                self.thirdTagLabel.text = str;
            }
        }
    }
    else
    {
        self.showDetail.hidden = NO;
        self.showDetail.text = introduction;
    }
    //去掉游戏类型前面的空格
    if ([class_type hasPrefix:@" "])
    {
        class_type = [class_type substringFromIndex:1];
    }
    NSString * detailStr = [NSString stringWithFormat:@"%@ | %@人在玩", class_type, dataDic[@"howManyPlay"]];
    self.detailLabel.text = detailStr;
    
    BOOL isNameRemark = [YYToolModel isBlankString:dataDic[@"nameRemark"]];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", dataDic[@"nameRemark"]];
    self.nameRemark.hidden = isNameRemark;
}

@end
