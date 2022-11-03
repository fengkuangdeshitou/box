//
//  MyReplyRebateCodeFooterView.m
//  Game789
//
//  Created by Maiyou001 on 2021/6/28.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyReplyRebateCodeFooterView.h"

#import "MyRebateMoreGiftCodeController.h"

@implementation MyReplyRebateCodeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
//        self = [[NSBundle mainBundle] loadNibNamed:@"MyReplyRebateCodeFooterView" owner:self options:nil].firstObject;
        self.frame = frame;
//        self.backgroundColor = UIColor.whiteColor;
//        [self.moreBtn setTitleColor:MAIN_COLOR forState:0];
//        self.moreBtn.backgroundColor = UIColor.redColor;
//        [self.moreBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(self.hx_centerX - 50, 0, 100, 40)];
        [button setTitle:@"查看更多" forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:MAIN_COLOR forState:0];
        [button setImage:MYGetImage(@"game_detail_more_down") forState:0];
        [button addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [self addSubview:button];
    }
    return self;
}

- (void)moreBtnClick:(UIButton *)sender
{
    MyRebateMoreGiftCodeController * gift = [MyRebateMoreGiftCodeController new];
    gift.dataArray = self.dataArray;
    [[YYToolModel getCurrentVC].navigationController pushViewController:gift animated:YES];
}

@end
