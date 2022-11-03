//
//  MySignedRuleView.m
//  Game789
//
//  Created by Maiyou on 2020/10/9.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MySignedRuleView.h"

@implementation MySignedRuleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MySignedRuleView" owner:self options:nil].firstObject;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.frame = frame;
        self.textView.backgroundColor = ColorWhite;
        self.textView.text = self.textView.text.localized;
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:self.textView.text];
        NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 6;
        paragraph.paragraphSpacingBefore = 5;
        [string addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(0, self.textView.text.length)];
        [string addAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR} range:[self.textView.text rangeOfString:@"3天/7天/15天/28天"]];
        [string addAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR} range:[self.textView.text rangeOfString:@"10金币/20金币/50金币/100金币".localized]];
        self.textView.attributedText = string;
        
    }
    return self;
}

- (IBAction)sureBtnClick:(id)sender
{
    [self removeFromSuperview];
}

@end
