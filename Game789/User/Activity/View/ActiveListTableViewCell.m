//
//  ActiveListTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2018/3/18.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "ActiveListTableViewCell.h"
@interface ActiveListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;

@end

@implementation ActiveListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModelDic:(NSDictionary *)dic {
    self.publishTimeLabel.text = [self timeWithTimeIntervalString:[dic objectForKey:@"news_date"]];
    [self.contentImg sd_setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"new_image"] objectForKey:@"source"]] placeholderImage:MYGetImage(@"banner_photo")];
}
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
