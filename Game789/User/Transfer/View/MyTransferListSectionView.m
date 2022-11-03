//
//  MyTransferListSectionView.m
//  Game789
//
//  Created by Maiyou on 2021/3/11.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyTransferListSectionView.h"

@implementation MyTransferListSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyTransferListSectionView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        self.searchTextfield.delegate = self;
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchTextBlock)
    {
        self.searchTextBlock(textField.text);
    }
    return YES;
}

- (IBAction)searchBtnClick:(id)sender
{
    if (self.searchTextBlock)
    {
        self.searchTextBlock(self.searchTextfield.text);
    }
}

@end
