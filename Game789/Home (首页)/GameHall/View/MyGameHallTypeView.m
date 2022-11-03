//
//  MyGameHallTypeView.m
//  Game789
//
//  Created by Maiyou on 2020/9/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameHallTypeView.h"

@implementation MyGameHallTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyGameHallTypeView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self.typeBtn1 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:12.5];
        [self.typeBtn2 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:12.5];
        [self.typeBtn3 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:12.5];
        
        NSDictionary * dic = [DeviceInfo shareInstance].data;
        BOOL is_open_discount = [dic[@"is_open_discount"] boolValue];
        BOOL is_open_h5 = [dic[@"is_open_h5"] boolValue];
        if (!is_open_discount && is_open_h5)
        {
            self.typeBtn2Width.constant = 0;
            self.typeBtn2.hidden = YES;
            self.typeBtn3Width.constant = kScreen_width / 2;
        }
        else if (is_open_discount && !is_open_h5)
        {
            self.typeBtn3Width.constant = 0;
            self.typeBtn3.hidden = YES;
            self.typeBtn2Width.constant = kScreen_width / 2;
        }else{
            self.typeBtn3Width.constant = kScreen_width / 3;
            self.typeBtn2Width.constant = kScreen_width / 3;
        }
        
        self.typeBtn1.selected = YES;
        self.selectedButton = self.typeBtn1;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)closeView
{
    [self dismissView];
    
    if (self.selectGameTypeBlock)
    {
        self.selectGameTypeBlock(self.gameSpeciesType, self.selectedButton.titleLabel.text);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.backView])
    {
        return NO;
    }
    return YES;
}

- (IBAction)typeBtnClick:(id)sender
{
    UIButton * button = sender;
    if (self.selectedButton != button)
    {
        NSString * str = [NSString stringWithFormat:@"%ld", button.tag - 10];
        button.selected = YES;
        self.selectedButton.selected = NO;
        self.selectedButton = button;
        if (self.selectGameTypeBlock)
        {
            self.selectGameTypeBlock(str, self.selectedButton.titleLabel.text);
        }
        
        [self dismissView];
    }
}

- (void)showView
{
    self.hidden = NO;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//    [UIView animateWithDuration:0.26 animations:^{
//        self.y = kStatusBarAndNavigationBarHeight;
//    } completion:^(BOOL finished) {
//    }];
}

- (void)dismissView
{
    [UIView animateWithDuration:0.26 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

@end
