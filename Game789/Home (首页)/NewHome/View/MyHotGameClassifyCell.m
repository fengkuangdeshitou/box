//
//  MyHotGameClassifyCell.m
//  Game789
//
//  Created by Maiyou on 2020/7/14.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyHotGameClassifyCell.h"

@implementation MyHotGameClassifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showName.text = dataDic[@"game_classify_name"];
}

@end
