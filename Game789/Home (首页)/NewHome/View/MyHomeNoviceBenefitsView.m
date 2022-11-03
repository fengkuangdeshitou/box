//
//  MyHomeNoviceBenefitsView.m
//  Game789
//
//  Created by Maiyou on 2020/10/14.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyHomeNoviceBenefitsView.h"
#import "UserPayGoldViewController.h"

@implementation MyHomeNoviceBenefitsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyHomeNoviceBenefitsView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor redColor];
        
        self.noviceBtn.imageView.userInteractionEnabled = YES;
    }
    return self;
}

- (IBAction)noviceBtnClick:(id)sender
{
    UserPayGoldViewController * pay = [[UserPayGoldViewController alloc] init];
    pay.isWelfare = YES;
    pay.hidesBottomBarWhenPushed = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:pay animated:YES];
}

@end
