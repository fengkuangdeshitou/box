//
//  MyDismissOperationView.m
//  Game789
//
//  Created by Maiyou on 2020/4/7.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyDismissOperationView.h"

@implementation MyDismissOperationView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyDismissOperationView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSDictionary * dic = [_dataDic[@"content"] deleteAllNullValue];
    
    self.showContent.text = dic[@"desc"];
    
    [self.sureButton setTitle:dic[@"button"] forState:0];
    
    self.showTitle.text = dic[@"title"];
}

- (IBAction)bottomButtonClick:(id)sender
{
    [self removeFromSuperview];
    
    NSDictionary *dic = [self.dataDic objectForKey:@"link_info"];
    [YYToolModel pushVcForType:dic[@"link_route"] Value:dic[@"link_value"] Vc:self.currentVC];

}

- (IBAction)closeButtonClick:(id)sender
{
    [self removeFromSuperview];
}

@end
