//
//  MyTaskShowDetailCell.m
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTaskShowDetailCell.h"

@implementation MyTaskShowDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showImageView.image = MYGetImage(dataDic[@"image"]);
    
    self.showTitle.text = [dataDic[@"title"] localized];
    
    self.showDesc.text = [dataDic[@"desc"] localized];
}

- (void)setTaskDic:(NSDictionary *)taskDic
{
    taskDic = [taskDic deleteAllNullValue];
    _taskDic = taskDic;
    
    if ([taskDic[@"completed"] boolValue] && ![self.dataDic[@"title"] isEqualToString:@"试玩任务"])
    {
        [self.showStatus setTitle:@"" forState:0];
        [self.showStatus setImage:MYGetImage(@"task_finish_icon") forState:0];
    }
    else if (![taskDic[@"completed"] boolValue] && [self.dataDic[@"title"] isEqualToString:@"试玩任务"])
    {
        [self.showStatus setTitle:@"已领取".localized forState:0];
        [self.showStatus setImage:MYGetImage(@"") forState:0];
    }
    else
    {
        if ([self.dataDic[@"title"] isEqualToString:@"活动礼包"])
        {
            [self.showStatus setTitle:@"待领取".localized forState:0];
        }
        else if ([self.dataDic[@"title"] isEqualToString:@"成就任务"])
        {
            [self.showStatus setTitle:[NSString stringWithFormat:@"%@/%@", taskDic[@"success_num"], taskDic[@"total"]] forState:0];
        }
        else if ([self.dataDic[@"title"] isEqualToString:@"试玩任务"])
        {
            [self.showStatus setTitle:@"待领取".localized forState:0];
        }
        else
        {
            [self.showStatus setTitle:@"待完成".localized forState:0];
        }
        [self.showStatus setImage:MYGetImage(@"") forState:0];
    }
    
    if ([self.dataDic[@"title"] isEqualToString:@"新手任务"])
    {
        self.showTag.hidden = [taskDic[@"completed"] boolValue];
    }
    else
    {
        self.showTag.hidden = YES;
    }
}

@end
