//
//  WelfareCentreUserInfoHeaderView.m
//  Game789
//
//  Created by maiyou on 2021/9/15.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WelfareCentreUserInfoHeaderView.h"
#import "MyTaskCenterApi.h"
#import "MyTaskViewController.h"

@interface WelfareCentreUserInfoHeaderView ()

@property(nonatomic,weak)IBOutlet UIImageView * avatar;
@property(nonatomic,weak)IBOutlet UIImageView * level;
@property(nonatomic,weak)IBOutlet UILabel * username;
@property(nonatomic,weak)IBOutlet UILabel * account;

@end

@implementation WelfareCentreUserInfoHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [self.avatar yy_setImageWithURL:[NSURL URLWithString:data[@"avatar"]] placeholder:MYGetImage(@"avatar_default")];
    self.username.text = data[@"nickname"];
    self.level.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%@",data[@"gradeId"]]];
    self.account.text = [NSString stringWithFormat:@"%@:%@",@"账号".localized,data[@"account"]];
//    BOOL sign = [data[@"signed"] boolValue];
//    if (sign) {
//        [self.sign setTitle:@"已签到" forState:UIControlStateNormal];
//        self.sign.backgroundColor = [UIColor colorWithHexString:@"#999999"];
//    }else{
//        [self.sign setTitle:@"签到" forState:UIControlStateNormal];
//        self.sign.backgroundColor = MAIN_COLOR;
//    }
}

- (IBAction)signAction:(UIButton *)sender
{
    [MyAOPManager relateStatistic:@"ClickSignInOfWelfareCentrePage" Info:@{}];
    MyTaskViewController * task = [[MyTaskViewController alloc] init];
    task.hidesBottomBarWhenPushed = YES;
    task.signBlock = ^(){
//        [sender setTitle:@"已签到" forState:UIControlStateNormal];
//        sender.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    };
    [[YYToolModel getCurrentVC].navigationController pushViewController:task animated:YES];
}

@end
