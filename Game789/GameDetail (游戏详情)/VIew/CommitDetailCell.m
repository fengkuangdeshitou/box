//
//  CommitDetailCell.m
//  Game789
//
//  Created by Maiyou on 2018/8/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "CommitDetailCell.h"

@implementation CommitDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCommitDic:(NSDictionary *)commitDic
{
    _commitDic = commitDic;
    
    [self.showIcon sd_setImageWithURL:[NSURL URLWithString:commitDic[@"user"][@"img_url"]]];
    
    self.showName.text = commitDic[@"user"][@"nick_name"];
    
    self.showMgs.text = commitDic[@"content"];
    
    self.showTime.text = [NSDate dateTimeStringWithTS:[commitDic[@"create_time"] doubleValue]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
