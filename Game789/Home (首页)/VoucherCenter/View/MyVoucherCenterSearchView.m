//
//  MyVoucherCenterSearchView.m
//  Game789
//
//  Created by Maiyou on 2020/7/29.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyVoucherCenterSearchView.h"

@implementation MyVoucherCenterSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyVoucherCenterSearchView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.searchView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    }
    return self;
}

- (IBAction)searchBtnClick:(id)sender
{
    if (self.searchTextBlock)
    {
        self.searchTextBlock(self.textField.text);
    }
}

@end
