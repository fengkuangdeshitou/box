//
//  MyAlertView.m
//  Game789
//
//  Created by Maiyou001 on 2022/8/30.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyAlertView.h"

@interface MyAlertView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIImageView * icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancleBtn_centerX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtn_centerX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtn_width;

@end

@implementation MyAlertView

+ (MyAlertView *)alertViewWithConfigure:(MyAlertConfigure *)configure buttonBlock:(nullable MyAlertClickBlock)btnBlock
{
    if (!configure) {
        return nil;
    }
    
    if (configure.btnTitles.count == 0){
        return nil;
    }
    
    CGFloat btn_width = 120;
    if (configure.btnWidth > 0)
    {
        btn_width = configure.btnWidth;
    }
    CGFloat btn_Space = 20;
    if (configure.btnSpace > 0)
    {
        btn_Space = configure.btnSpace;
    }
    
    MyAlertView * alertView = [[MyAlertView alloc] init];
    alertView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    alertView.contentLabel.text = configure.content;
    alertView.contentLabel.textAlignment = configure.textAlignment;
    if (configure.title) {
        alertView.titleLabel.text = configure.title;
    }
    if (configure.currentVC) {
        [configure.currentVC.view addSubview:alertView];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    }
    if (configure.tag) {
        alertView.tag = configure.tag;
    }
    
    alertView.sureBtn_width.constant = btn_width;
    if (configure.showIcon){
        alertView.title_top.constant = 92;
        alertView.icon.hidden = false;
    }else{
        alertView.title_top.constant = 36.5;
        alertView.icon.hidden = true;
    }
    
    if (configure.btnTitles.count == 1)
    {
        alertView.sureBtn.hidden = YES;
        [alertView.cancleBtn setTitle:configure.btnTitles[0] forState:0];
        if (configure.btnTitleColors.count == 1)
        {
            [alertView.cancleBtn setTitleColor:configure.btnTitleColors[0] forState:UIControlStateNormal];
        }
        
        if (configure.btnBackColors.count == 1)
        {
            alertView.cancleBtn.backgroundColor = configure.btnBackColors[0];
        }
    }
    else if (configure.btnTitles.count == 2)
    {
        alertView.cancleBtn_centerX.constant = -(btn_width + btn_Space) / 2;
        alertView.sureBtn_centerX.constant = (btn_width + btn_Space) / 2;
        
        [alertView.cancleBtn setTitle:configure.btnTitles[0] forState:0];
        [alertView.sureBtn setTitle:configure.btnTitles[1] forState:0];
        
        if (configure.btnTitleColors.count == 2)
        {
            [alertView.cancleBtn setTitleColor:configure.btnTitleColors[0] forState:UIControlStateNormal];
            [alertView.sureBtn setTitleColor:configure.btnTitleColors[1] forState:UIControlStateNormal];
        }
        
        if (configure.btnBackColors.count == 2)
        {
            alertView.cancleBtn.backgroundColor = configure.btnBackColors[0];
            alertView.sureBtn.backgroundColor = configure.btnBackColors[1];
        }
    }
    
    alertView.buttonClickBlock = ^(NSInteger buttonIndex) {
        if (btnBlock) {
            btnBlock(buttonIndex);
        }
    };
    return alertView;
}

- (instancetype)init
{
    if ([super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyAlertView" owner:self options:nil].firstObject;
    }
    return self;
}

- (IBAction)cancleBtnClick:(id)sender
{
    [self removeFromSuperview];
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(0);
    }
}

- (IBAction)sureBtnClick:(id)sender
{
    [self removeFromSuperview];
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(1);
    }
}

- (IBAction)closeBtnClick:(id)sender
{
    [self removeFromSuperview];
}

@end
