//
//  MyCustomServiceCell.m
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyCustomServiceCell.h"

@implementation MyCustomServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showTitle.text = dataDic[@"text"];
    
    if (self.isShowContent)
    {
        NSString * question = @"";
        NSInteger count = [dataDic[@"items"] count];
        for (int i = 0; i < count; i ++)
        {
            NSDictionary * dic = dataDic[@"items"][i];
            if (i == count - 1)
            {
                question = [question stringByAppendingFormat:@"%@", dic[@"q"]];
            }
            else
            {
                question = [question stringByAppendingFormat:@"%@\n\n", dic[@"q"]];
            }
        }
        self.showQuestion.text = question;
        
        self.showQuestion_top.constant = 15;
        self.showQuestion_bottom.constant = 13;
        self.dottedLine.hidden = NO;
    }
    else
    {
        self.showQuestion.text = @"";
        
        self.showQuestion_top.constant = 0;
        self.showQuestion_bottom.constant = 0;
        self.dottedLine.hidden = YES;
    }
    
    if ([dataDic[@"text"] isEqualToString:@"平台问题"])
    {
        self.showImageView.image = MYGetImage(@"service_title_icon1");
    }
    else if ([dataDic[@"text"] isEqualToString:@"游戏问题"])
    {
        self.showImageView.image = MYGetImage(@"service_title_icon2");
    }
    else if ([dataDic[@"text"] isEqualToString:@"交易问题"])
    {
        self.showImageView.image = MYGetImage(@"service_title_icon3");
    }
    else if ([dataDic[@"text"] isEqualToString:@"货币问题"])
    {
        self.showImageView.image = MYGetImage(@"service_title_icon4");
    }
    else if ([dataDic[@"text"] isEqualToString:@"会员问题"])
    {
        self.showImageView.image = MYGetImage(@"service_title_icon5");
    }
    else
    {
        self.showImageView.image = MYGetImage(@"service_title_icon1");
    }
}

- (IBAction)moreBtnClick:(id)sender
{
    if (self.moreBtnBlock) {
        self.moreBtnBlock();
    }
}


@end
