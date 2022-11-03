//
//  MyRebateDetailGiftCodeCell.m
//  Game789
//
//  Created by Maiyou on 2020/8/11.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyRebateDetailGiftCodeCell.h"

@implementation MyRebateDetailGiftCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pasteBtnClick:(id)sender
{
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.showCode.text;
    [MBProgressHUD showToast:@"已复制到粘贴板" toView:[YYToolModel getCurrentVC].view];
}

@end
