//
//  BPPCalendarCell.m
//  Animation
//
//  Created by Onway on 2017/4/7.
//  Copyright © 2017年 Onway. All rights reserved.
//

#import "BPPCalendarCell.h"

@implementation BPPCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    self.signImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.signImageView.image = MYGetImage(@"task_checked_selected");
    self.signImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.signImageView];
    
    self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
   // self.textLabel.backgroundColor = [UIColor redColor];
    self.textLabel.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
   // self.textLabel.text = @"sss";
    self.textLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.textLabel];
}

@end
