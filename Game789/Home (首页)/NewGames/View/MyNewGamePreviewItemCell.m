//
//  MyNewGamePreviewItemCell.m
//  Game789
//
//  Created by Maiyou on 2020/4/15.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyNewGamePreviewItemCell.h"

@implementation MyNewGamePreviewItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:dataDic[@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    
    self.gameName.text = dataDic[@"game_name"];
    
    self.showTime.text = dataDic[@"label"];
}

@end
