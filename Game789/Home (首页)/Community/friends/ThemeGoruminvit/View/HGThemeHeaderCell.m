//
//  HGThemeHeaderCell.m
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGThemeHeaderCell.h"

@implementation HGThemeHeaderCell

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
    
    NSArray * array = [YYToolModel getUserdefultforKey:@"MyUserCommentList"];
    if (array == NULL)
    {
        self.attentionBtn.selected = NO;
        self.attentionBtn.layer.borderColor = [UIColor colorWithHexString:@"FFC000"].CGColor;
    }
    else
    {
        self.attentionBtn.selected = [array containsObject:dataDic];
        self.attentionBtn.layer.borderColor = [UIColor colorWithHexString:[array containsObject:dataDic] ? @"#DEDEDE" : @"FFC000"].CGColor;
    }
}

- (IBAction)attentionBtnClick:(id)sender
{
    UIButton * btn = sender;
    
    btn.selected = !btn.selected;
    NSArray * array = [YYToolModel getUserdefultforKey:@"MyUserCommentList"];
    NSMutableArray * list = [NSMutableArray array];
    if (array != NULL)
    {
        list = [NSMutableArray arrayWithArray:array];
    }
    if (btn.isSelected)
    {
        btn.layer.borderColor = [UIColor colorWithHexString:@"#DEDEDE"].CGColor;
        if (![list containsObject:self.dataDic])
        {
            [list addObject:self.dataDic];
        }
    }
    else
    {
        btn.layer.borderColor = MAIN_COLOR.CGColor;
        
        if ([list containsObject:self.dataDic])
        {
            [list removeObject:self.dataDic];
        }
    }
    [YYToolModel saveUserdefultValue:list forKey:@"MyUserCommentList"];
}

@end
