//
//  ReturnGuideContentTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2018/3/19.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "ReturnGuideContentTableViewCell.h"
@interface ReturnGuideContentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation ReturnGuideContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModelDic:(NSDictionary *)dic {
//    self.contentLabel.text = [dic objectForKey:@"guide_content"];
    self.contentLabel.text = [dic objectForKey:@"guide_content"];
}

@end
