//
//  HomeProjectDescCell.m
//  Game789
//
//  Created by maiyou on 2021/9/17.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "HomeProjectDescCell.h"
#import "GetGiftApi.h"
#import "MyGameGiftDetailController.h"

@interface HomeProjectDescCell ()

@property(nonatomic,weak)IBOutlet UIView * packView;
@property(nonatomic,weak)IBOutlet UIView * packContentView;
@property(nonatomic,weak)IBOutlet UILabel * packname;
@property(nonatomic,weak)IBOutlet UILabel * packcontent;
@property(nonatomic,weak)IBOutlet UILabel * use_desc;
@property(nonatomic,weak)IBOutlet UIButton * receive;

@end

@implementation HomeProjectDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.gameCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GameTableViewCell class]) owner:self options:nil] firstObject];
    self.gameCell.frame = CGRectMake(0, 0, ScreenWidth, 110);
    [self.contentView addSubview:self.gameCell];
    [YYToolModel clipRectCorner:UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8 view:self.packView];
    [YYToolModel clipRectCorner:UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight radius:8 view:self.packContentView];

}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [self.gameCell setModelDic:data];
    self.packname.text = data[@"packname"];
    self.packcontent.text = data[@"packcontent"];
    self.use_desc.text = data[@"use_desc"];
    
    if ([self.receive.backgroundColor isEqual:[UIColor colorWithHexString:@"#80C5FE"]]) {
        return;
    }
    BOOL receive = [data[@"isreceived"] boolValue];
    [self.receive setTitle:receive?@"复制":@"领取" forState:UIControlStateNormal];
    self.receive.backgroundColor = receive?[UIColor colorWithHexString:@"#80C5FE"]:MAIN_COLOR;
    self.gameCell.height = self.gameCell.cellHeight;
    self.radiusTop.constant = self.gameCell.cellHeight;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gameCell.height = self.gameCell.cellHeight+25;
}

- (IBAction)receiveAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"领取"])
    {
        MyGameGiftDetailController * detail = [MyGameGiftDetailController new];
        detail.isReceived = YES;
        detail.gift_id = self.data[@"packid"];
        detail.vc = YYToolModel.getCurrentVC;
        [[YYToolModel getCurrentVC] presentViewController:detail animated:YES completion:nil];
        detail.receivedGiftCodeBlock = ^{
            [sender setTitle:@"复制" forState:UIControlStateNormal];
            sender.backgroundColor = [UIColor colorWithHexString:@"#80C5FE"];
        };
        
//        GetGiftApi * api = [[GetGiftApi alloc] init];
//        api.gift_id = [NSString stringWithFormat:@"%@",self.data[@"packid"]];
//        [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
//            if (api.success == 1) {
//                [sender setTitle:@"复制" forState:UIControlStateNormal];
//                [MBProgressHUD showToast:@"领取成功" toView:[YYToolModel getCurrentVC].view];
//            }else {
//                [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
//            }
//        } failureBlock:^(BaseRequest * _Nonnull request) {
//
//        }];
    }
    else
    {
        UIPasteboard * board = [UIPasteboard generalPasteboard];
        board.string = self.data[@"card"];
        [MBProgressHUD showToast:@"礼包码已复制到剪贴板" toView:YYToolModel.getCurrentVC.view];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
