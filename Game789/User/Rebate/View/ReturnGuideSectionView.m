//
//  ReturnGuideSectionView.m
//  Game789
//
//  Created by xinpenghui on 2018/3/19.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "ReturnGuideSectionView.h"

@interface ReturnGuideSectionView ()
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ReturnGuideSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@"awakeFromNib");
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideSectionViewPress:)];
    [self addGestureRecognizer:tap];
}

- (void)guideSectionViewPress:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(ReturnGuideSectionViewPressAction:)]) {
        [self.delegate ReturnGuideSectionViewPressAction:self.row];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"initWithCoder");
    if([super initWithCoder:aDecoder])
    {
    }
    return self;
}

- (void)resetTitles:(NSString *)title
{
    self.titleNameLabel.text = [NSString stringWithFormat:@"%ld、%@", self.row + 1, title];
    
    self.countLabel.text = [NSString stringWithFormat:@"%li",self.row+1];
}

@end
