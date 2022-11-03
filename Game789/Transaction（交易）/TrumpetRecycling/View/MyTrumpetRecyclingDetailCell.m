//
//  MyTrumpetRecyclingDetailCell.m
//  Game789
//
//  Created by yangyongMac on 2020/2/11.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTrumpetRecyclingDetailCell.h"

@implementation MyTrumpetRecyclingDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecycleModel:(MyTrumpetRecyclingModel *)recycleModel
{
    _recycleModel = recycleModel;
    
    self.selectButton.selected = recycleModel.isSelected;
    
    self.xhName.text = recycleModel.alias;
    
    self.rechargeAmount.text = [NSString stringWithFormat:@"%@%@", recycleModel.rechargedAmount, @"元".localized];
    
    self.recycleAmount.text = [NSString stringWithFormat:@"%@%@", recycleModel.recycledCoin, @"金币".localized];
}

- (IBAction)recycleButtonClick:(id)sender
{
    UIButton * button = sender;
    button.selected = !_recycleModel.isSelected;
    _recycleModel.isSelected = button.selected;
    
    if (self.SelectAction)
    {
        self.SelectAction(button.selected, self.index);
    }
}


@end
