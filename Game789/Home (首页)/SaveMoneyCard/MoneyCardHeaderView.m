//
//  MoneyCardHeaderView.m
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MoneyCardHeaderView.h"
#import "PurchaseRecordsViewController.h"
#import "SaveMoneyAPI.h"

@interface MoneyCardHeaderView ()

@property(nonatomic,weak)IBOutlet UIImageView * avatar;
@property(nonatomic,weak)IBOutlet UILabel * userName;
@property(nonatomic,weak)IBOutlet UILabel * desc;

@end

@implementation MoneyCardHeaderView

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
    self.levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"member_level%d",[data[@"grade_id"] intValue]]];
    self.desc.text = data[@"info"];
    BOOL is_buy = [data[@"is_buy"]boolValue];
    if (is_buy) {
        self.time.text = data[@"end_date_time"];
        BOOL is_blend = [data[@"is_blend"] intValue] == 0;
        if (is_blend) {
            self.button.hidden = false;
            BOOL is_drwa = [data[@"is_drwa"] boolValue];
            if (is_drwa) {
                [self.button setTitle:[NSString stringWithFormat:@"领取%@金币",data[@"gold"]] forState:UIControlStateNormal];
                self.button.backgroundColor = [UIColor colorWithHexString:@"#3C2B05"];
                self.button.userInteractionEnabled = true;
            }else{
                [self.button setTitle:@"今日已领取" forState:UIControlStateNormal];
                self.button.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
                self.button.userInteractionEnabled = false;
            }
        }else{
            self.button.hidden = true;
        }
    }else{
        self.time.text = @"暂未购买";
        self.button.hidden = true;
    }
    
    

}

- (IBAction)purchaseRecordsAction:(UIButton *)sender{
    DrawGoldAPI * api = [[DrawGoldAPI alloc] init];
    api.isShow = true;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (api.success) {
            [self.button setTitle:@"今日已领取" forState:UIControlStateNormal];
            self.button.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
            self.button.userInteractionEnabled = false;
        }else{
            [MBProgressHUD showToast:api.error_desc toView:YYToolModel.getCurrentVC.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:YYToolModel.getCurrentVC.view];
    }];
//    if (sender.selected) {
//        WebViewController * web = [[WebViewController alloc] init];
//        web.urlString = @"http://sys.wakaifu.com/home/vip/summary.html";
//        [[YYToolModel getCurrentVC].navigationController pushViewController:web animated:YES];
//    }else{
//        PurchaseRecordsViewController * records = [[PurchaseRecordsViewController alloc] init];
//        [[YYToolModel getCurrentVC].navigationController pushViewController:records animated:YES];
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
