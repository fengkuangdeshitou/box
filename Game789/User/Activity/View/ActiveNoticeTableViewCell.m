//
//  ActiveNoticeTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2018/3/18.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "ActiveNoticeTableViewCell.h"

@interface ActiveNoticeTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titlesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end

@implementation ActiveNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModelDic:(NSDictionary *)dic {

    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"new_image"] objectForKey:@"source"]] placeholderImage:MYGetImage(@"game_icon")];

    self.titlesLabel.text = [dic objectForKey:@"news_title"];
    self.timeLable.text = [NSString stringWithFormat:@"%@:%@", @"发布时间".localized, [self timeWithTimeIntervalString:[dic objectForKey:@"news_date"]]];
}
@end
