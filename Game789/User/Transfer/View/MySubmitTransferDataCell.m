//
//  MySubmitTransferDataCell.m
//  Game789
//
//  Created by Maiyou on 2021/3/12.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MySubmitTransferDataCell.h"

@implementation MySubmitTransferDataCell

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
    
    self.showTitle.text = dataDic[@"title"];
    
    self.downIcon.hidden = ![dataDic[@"type"] boolValue];
}

@end
