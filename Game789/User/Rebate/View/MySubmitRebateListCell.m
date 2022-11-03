//
//  MySubmitRebateListCell.m
//  Game789
//
//  Created by Maiyou on 2020/7/20.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MySubmitRebateListCell.h"

@implementation MySubmitRebateListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleDic:(NSDictionary *)titleDic
{
    _titleDic = titleDic;
    
    self.showIcon.image = MYGetImage(titleDic[@"icon"]);
    
    self.showTitle.text = titleDic[@"title"];
}

@end
