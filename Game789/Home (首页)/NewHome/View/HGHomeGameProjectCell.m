//
//  HGHomeGameProjectCell.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGHomeGameProjectCell.h"

@implementation HGHomeGameProjectCell

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
    
    self.showTitle.text = dataDic[@"tips"];
    
    [self.showImage yy_setImageWithURL:[NSURL URLWithString:dataDic[@"top_image"]] placeholder:MYGetImage(@"banner_photo")];
}

@end
