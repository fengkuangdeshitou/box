//
//  MyBuyVipCell.m
//  Game789
//
//  Created by Maiyou001 on 2022/4/8.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyBuyVipCell.h"

@implementation MyBuyVipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showAmount.text = dataDic[@"price"];
    self.showTips.text = dataDic[@"topLable"];
    self.showTips1.text = dataDic[@"comment1"];
    self.showTips2.text = dataDic[@"comment2"];
    self.showLable.text = dataDic[@"buttonTitle"];
    self.showTipsView.hidden = [YYToolModel isBlankString:dataDic[@"topLable"]];
}

@end
