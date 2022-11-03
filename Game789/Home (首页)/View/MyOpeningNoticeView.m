//
//  MyOpeningNoticeView.m
//  Game789
//
//  Created by Maiyou on 2019/11/9.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyOpeningNoticeView.h"
#import "NoticeDetailViewController.h"

@implementation MyOpeningNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyOpeningNoticeView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showContent.text = dataDic[@"content"];
    
    [self.sureButton setTitle:dataDic[@"button"] forState:0];
    
    self.showTitle.text = dataDic[@"title"];
}

- (IBAction)bottomButtonClick:(id)sender
{
    [self removeFromSuperview];
    
//    NSDictionary *dic = [self.dataDic objectForKey:@"link_info"];
//    [[YYToolModel shareInstance] showUIFortype:dic[@"link_route"] Parmas:dic[@"link_value"]];
    
    if (self.ClickActionBlock) {
        self.ClickActionBlock();
    }
    
    [[YYToolModel shareInstance] showUIFortype:self.dataDic[@"jumpType"] Parmas:self.dataDic[@"value"]];
}

@end
