//
//  GetSettingNewsMgsCell.m
//  Game789
//
//  Created by Maiyou on 2018/9/4.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "GetSettingNewsMgsCell.h"

@implementation GetSettingNewsMgsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setNewsModel:(GetSettingNewsMgsModel *)newsModel
{
    _newsModel = newsModel;
    
    self.showTitle.text = newsModel.title;
    self.showContent.text = newsModel.content;
    
    NSString * time = [NSDate dateWithFormat:@"MM-dd HH:mm" WithTS:[newsModel.message_time floatValue]];
    self.showTime.text = time;
    
    NSInteger isRead = newsModel.read_tag.integerValue;
    // 1已读
    self.readTagView.hidden = isRead == 1;
    
    if (newsModel.message_type.integerValue == 4)
    {
        self.enterText.text = @"进入对话框>";
    }
    else if (newsModel.message_type.integerValue == 5 || newsModel.message_type.integerValue == 6)
    {
        self.enterText.text = @"点击续费>";
    }
    else
    {
        self.enterText.text = @"点击查看详情>";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
