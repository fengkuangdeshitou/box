//
//  RecommendTextCell.m
//  Game789
//
//  Created by maiyou on 2021/11/23.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "RecommendTextCell.h"

@interface RecommendTextCell ()

@property(nonatomic,weak)IBOutlet UIImageView * backImageView;

@end

@implementation RecommendTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIImage * image = self.backImageView.image;
    CGFloat top = image.size.height/2;
    CGFloat left = image.size.width/2;
    CGFloat bottom = image.size.height/2;
    CGFloat right = image.size.width/2;
    self.backImageView.image  = [self.backImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
    
}

- (IBAction)gameDetail:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushTuGameDetail" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
