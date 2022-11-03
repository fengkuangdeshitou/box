//
//  WelfareCentreGifsCollectionViewCell.m
//  Game789
//
//  Created by maiyou on 2021/9/24.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "WelfareCentreGifsCollectionViewCell.h"
#import "GetGiftApi.h"
#import "MyGameGiftDetailController.h"

@interface WelfareCentreGifsCollectionViewCell ()

@property(nonatomic,weak)IBOutlet YYAnimatedImageView * logo;
@property(nonatomic,weak)IBOutlet UILabel * gamaname;
@property(nonatomic,weak)IBOutlet UILabel * desc;
@property(nonatomic,weak)IBOutlet UILabel * packname;
@property(nonatomic,weak)IBOutlet UILabel * packcontent;
@property(nonatomic,weak)IBOutlet UIButton * receive;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UILabel *nameRemark;

@end

@implementation WelfareCentreGifsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    [self.logo yy_setImageWithURL:[NSURL URLWithString:data[@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    self.gamaname.text = data[@"game_name"];
    
    //有描述显示描述，没有显示福利标签
    for (UILabel * label in self.stackView.subviews) {
        label.text = @"";
    }
    NSString * introduction = data[@"introduction"];
    if (introduction.length > 0) {
        self.desc.text = introduction;
        self.stackView.hidden = YES;
        self.desc.hidden = NO;
    }else{
        self.stackView.hidden = NO;
        self.desc.hidden = YES;
        NSArray * array = [data[@"game_desc"] componentsSeparatedByString:@"+"];
        for (int i = 0; i<array.count; i++) {
            UILabel * label = [self.stackView viewWithTag:i+20];
            label.text = [NSString stringWithFormat:@"%@",array[i]];
        }
    }
    
    self.packname.text = data[@"packname"];
    
    self.packcontent.text = data[@"packcontent"];
    
//    if ([self.receive.backgroundColor isEqual:[UIColor colorWithHexString:@"#80C5FE"]]) {
//        return;
//    }
    BOOL receive = [data[@"isreceived"] boolValue];
    [self.receive setTitle:receive?@"复制".localized:@"领取".localized forState:UIControlStateNormal];
    self.receive.backgroundColor = receive?[UIColor colorWithHexString:@"#80C5FE"]:MAIN_COLOR;
    
    BOOL isNameRemark = [YYToolModel isBlankString:data[@"nameRemark"]];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", data[@"nameRemark"]];
    self.nameRemark.hidden = isNameRemark;
}

- (IBAction)receiveAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"领取".localized]) {
                
        MyGameGiftDetailController * detail = [MyGameGiftDetailController new];
        detail.isReceived = YES;
        detail.gift_id = self.data[@"packid"];
        detail.vc = YYToolModel.getCurrentVC;
        [[YYToolModel getCurrentVC] presentViewController:detail animated:YES completion:nil];
//        detail.receivedGiftCodeBlock = ^{
//            [sender setTitle:@"复制".localized forState:UIControlStateNormal];
//            sender.backgroundColor = [UIColor colorWithHexString:@"#80C5FE"];
//        };
        
        
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
    }else{
        UIPasteboard * board = [UIPasteboard generalPasteboard];
        board.string = self.data[@"card"];
        [MBProgressHUD showToast:@"礼包码已复制到剪贴板" toView:YYToolModel.getCurrentVC.view];
    }
}

@end
