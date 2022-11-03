//
//  MyTrumpetRecyclingCell.m
//  Game789
//
//  Created by yangyongMac on 2020/2/11.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTrumpetRecyclingCell.h"

@implementation MyTrumpetRecyclingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListModel:(MyRecycleGameListModel *)listModel
{
    _listModel = listModel;
    
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:listModel.img[@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    
    self.gameName.text = listModel.name;
    
    self.recycleNum.text = [NSString stringWithFormat:@"%@", listModel.recyclable];
    
    self.recycleAmount.text = [NSString stringWithFormat:@"%@%@", listModel.recyclableCoin, @"金币".localized];
    
    self.chargeAmount.text = [NSString stringWithFormat:@"%@", listModel.rechargedAmount];
    
    BOOL isNameRemark = [YYToolModel isBlankString:listModel.nameRemark];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", listModel.nameRemark];
    self.nameRemark.hidden = isNameRemark;
}

@end
