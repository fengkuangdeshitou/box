//
//  CardMemberHeaderView.m
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "CardMemberHeaderView.h"
#import "PurchaseRecordsViewController.h"

@interface CardMemberHeaderView ()

@property(nonatomic,weak)IBOutlet UIImageView * avatar;
@property(nonatomic,weak)IBOutlet UILabel * userName;

@end

@implementation CardMemberHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        self.frame = frame;
    }
    return self;
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:data[@"avatar"]] placeholderImage:MYGetImage(@"avatar_default")];
    self.userName.text = data[@"nicknaame"];
    self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%d",[data[@"vip"][@"grade_id"] intValue]]];
}

- (IBAction)purchaseRecordsAction:(UIButton *)sender{
    if (sender.selected) {
        WebViewController * web = [[WebViewController alloc] init];
        web.urlString = @"http://sys.wakaifu.com/home/vip/summary.html";
        [[YYToolModel getCurrentVC].navigationController pushViewController:web animated:YES];
    }else{
        PurchaseRecordsViewController * records = [[PurchaseRecordsViewController alloc] init];
        [[YYToolModel getCurrentVC].navigationController pushViewController:records animated:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
