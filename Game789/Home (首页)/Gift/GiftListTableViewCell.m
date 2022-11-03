//
//  GiftListTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2017/9/2.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "GiftListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface GiftListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftName;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *detail2Label;
@property (weak, nonatomic) IBOutlet UIButton *copysBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;
@property (nonatomic, strong) NSDictionary * dataDic;

@end

@implementation GiftListTableViewCell

- (IBAction)copyCodePress:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.dataDic[@"gift_code"];
    [MBProgressHUD showToast:@"礼包码已复制到剪贴板" toView:[UIApplication sharedApplication].delegate.window];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModelDic:(NSDictionary *)dic
{
    _dataDic = dic;
    
    NSString *url = [[dic objectForKey:@"gift_image"]objectForKey:@"thumb"];
    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:MYGetImage(@"game_icon")];
    self.titleLabel.text = dic[@"game_name"];
    self.giftName.text = [NSString stringWithFormat:@"%@：%@", @"名称".localized, dic[@"gift_name"]];
    self.detailLabel.text = [NSString stringWithFormat:@"%@：%@", @"内容".localized, dic[@"gift_desc"]];
    self.detail2Label.text = [NSString stringWithFormat:@"%@：%@", @"礼包码".localized, dic[@"gift_code"]];
    
    BOOL isNameRemark = [YYToolModel isBlankString:dic[@"nameRemark"]];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", dic[@"nameRemark"]];
    self.nameRemark.hidden = isNameRemark;
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
