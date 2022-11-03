//
//  WelfareCentreSpecialGiftCell.m
//  Game789
//
//  Created by maiyou on 2021/9/16.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WelfareCentreSpecialGiftCell.h"
#import "MyGetVoucherListApi.h"

@interface WelfareCentreSpecialGiftCell ()

@property(nonatomic,weak)IBOutlet YYAnimatedImageView * logo;
@property(nonatomic,weak)IBOutlet UILabel * gamename;
@property(nonatomic,weak)IBOutlet UILabel * amount;
@property(nonatomic,weak)IBOutlet UILabel * desc;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@end

@implementation WelfareCentreSpecialGiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGameModel:(MyWelfareCenterGameModel *)gameModel
{
    _gameModel = gameModel;
    
    [self.logo yy_setImageWithURL:[NSURL URLWithString:gameModel.logo] placeholder:MYGetImage(@"game_icon")];
    self.gamename.text = gameModel.gameName;
    self.amount.text = [NSString stringWithFormat:@"%@", gameModel.amount];
    self.desc.text = gameModel.desc;
    
    if (!gameModel.received.boolValue)
    {
        [self.receiveBtn setTitle:@"领取".localized forState:0];
        self.receiveBtn.backgroundColor = MAIN_COLOR;
    }
    else
    {
        [self.receiveBtn setTitle:@"已领取".localized forState:0];
        self.receiveBtn.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    }
    
    if (![YYToolModel isBlankString:gameModel.nameRemark])
    {
        self.gamename.numberOfLines = 1;
        self.nameRemark.text = [NSString stringWithFormat:@"%@  ", gameModel.nameRemark];
        self.nameRemark.hidden = NO;
    }
    else
    {
        self.gamename.numberOfLines = 0;
        self.nameRemark.text = @"";
        self.nameRemark.hidden = YES;
    }
}

- (IBAction)receiveAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"已领取".localized])
    {
        return;
    }
    MyReceiveGameVoucherApi * api = [[MyReceiveGameVoucherApi alloc] init];
    api.voucher_id = [NSString stringWithFormat:@"%@",self.gameModel.voucherId];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (api.success == 1) {
            //如果没有可领取的该状态
            if (![request.data[@"hasSome"] boolValue])
            {
                [sender setTitle:@"已领取".localized forState:UIControlStateNormal];
                sender.backgroundColor = [UIColor colorWithHexString:@"#999999"];
                self.gameModel.received = @"1";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveCoucherSuccess" object:nil];
            }
            else
            {
                [YJProgressHUD showSuccess:@"领取成功" inview:[YYToolModel getCurrentVC].view];
            }
        }else {
            [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

@end
