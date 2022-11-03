//
//  MyGameListSectionView.m
//  Mycps
//
//  Created by Maiyou on 2018/11/13.
//  Copyright © 2018 Maiyou. All rights reserved.
//

#import "MyGameListSectionView.h"

@implementation MyGameListSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyGameListSectionView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        [self.searchButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    return self;
}

#pragma mark - 搜索游戏
- (IBAction)searchGameAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(keywordSearchAction:)])
    {
        [self.delegate keywordSearchAction:self.textField.text];
    }
}

@end
