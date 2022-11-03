//
//  MyNewHomePopularGameCell.m
//  Game789
//
//  Created by Maiyou on 2019/10/15.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyNewHomePopularGameCell.h"

@implementation MyNewHomePopularGameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:dataDic[@"game_icon"]] placeholder:MYGetImage(@"game_icon")];
    
    self.gameName.text = dataDic[@"game_name"];
    
    self.gameType.text = [NSString stringWithFormat:@"%@ | %@%@%@", dataDic[@"game_classify_type"], dataDic[@"comment_total"], @"条".localized, @"点评".localized];
}

@end
