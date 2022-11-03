//
//  MyGameHallSortSectionView.m
//  Game789
//
//  Created by Maiyou on 2020/7/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameHallSortSectionView.h"

@implementation MyGameHallSortSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyGameHallSortSectionView" owner:self options:nil].firstObject;
        self.frame = frame;
        
        self.selectedBtn = self.defaultBtn;
    }
    return self;
}

- (IBAction)sortBtnClick:(id)sender
{
    UIButton * button = sender;
    if (self.selectedBtn != button)
    {
        self.selectedBtn.selected = NO;
        button.selected = YES;
        self.selectedBtn = button;
        
        NSArray * array = @[@"def", @"new", @"hot"];
        if (self.sortValueChangedAction)
        {
            self.sortValueChangedAction(array[button.tag - 10]);
        }
    }
}

@end
