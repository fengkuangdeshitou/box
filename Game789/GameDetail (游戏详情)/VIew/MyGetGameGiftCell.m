//
//  MyGetGameGiftCell.m
//  Game789
//
//  Created by Maiyou on 2019/10/23.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyGetGameGiftCell.h"

@implementation MyGetGameGiftCell

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
    
    self.packageName.text = dataDic[@"packname"];
    
    self.packageContent.text = dataDic[@"packcontent"];
}

- (IBAction)getGiftPackageClick:(id)sender
{
    UIButton * button = sender;
    if (self.packageAction)
    {
        self.packageAction(button.tag);
    }
}

@end
