//
//  MyCustomerServiceFooterView.m
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyCustomerServiceFooterView.h"

@implementation MyCustomerServiceFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyCustomerServiceFooterView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

- (void)setTelNumber:(NSString *)telNumber
{
    _telNumber = telNumber;
    
    self.hidden = [telNumber isEqualToString:@""] ? YES : NO;
    self.showTelNumber.text = [NSString stringWithFormat:@"%@（仅处理投诉问题）", telNumber];
}

- (IBAction)callPhoneClick:(id)sender
{
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@", self.telNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
