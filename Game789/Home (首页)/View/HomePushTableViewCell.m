//
//  HomePushTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2018/3/14.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "HomePushTableViewCell.h"

@interface HomePushTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UILabel *gameTitle;
@property (weak, nonatomic) IBOutlet UILabel *hotLabel;

@end

@implementation HomePushTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.hotLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.hotLabel.layer.borderWidth = 1;
    self.hotLabel.layer.cornerRadius = 5;
    self.hotLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModelDic:(NSDictionary *)dic {
    NSLog(@"ad_name ni = %@",dic);
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"ad_image"] objectForKey:@"source"]] placeholderImage:[UIImage imageNamed:@"banner_photo"]];
    self.gameTitle.text = [dic objectForKey:@"ad_name"];
}
@end
