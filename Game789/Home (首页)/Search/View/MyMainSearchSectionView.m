//
//  MyMainSearchSectionView.m
//  Game789
//
//  Created by Maiyou on 2020/12/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyMainSearchSectionView.h"

@implementation MyMainSearchSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyMainSearchSectionView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

- (IBAction)deleteBtnClick:(id)sender
{
    if (self.deleteTagsBlock)
    {
        self.deleteTagsBlock();
    }
}

@end
