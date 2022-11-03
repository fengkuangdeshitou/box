//
//  MyCouponCenterListCell.m
//  Game789
//
//  Created by Maiyou on 2020/7/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyCouponCenterListCell.h"

#import "MyGetVoucherListApi.h"
@class MyReceiveGameVoucherApi;

@implementation MyCouponCenterListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSDictionary * gameInfo = dataDic[@"game_info"];
    
    self.titleLabel.text = gameInfo[@"game_name"];
    
    [self.imageViews yy_setImageWithURL:[NSURL URLWithString:gameInfo[@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    
    NSString * game_classify_type = gameInfo[@"game_classify_type"];
    if ([game_classify_type hasPrefix:@" "])
    {
        game_classify_type = [game_classify_type substringFromIndex:1];
    }
    if ([gameInfo[@"game_species_type"] integerValue] == 3)
    {
        self.detailLabel.text = game_classify_type;
    }
    else
    {
        self.detailLabel.text = [NSString stringWithFormat:@"%@｜%@人在玩", game_classify_type, gameInfo[@"howManyPlay"]];
    }
    
    self.showMoney.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:[dataDic[@"total_amount"] floatValue]]];
    
    self.showVoucherCount.text = [NSString stringWithFormat:@"共%@张券", dataDic[@"count_amount"]];
    
    BOOL isNameRemark = [YYToolModel isBlankString:gameInfo[@"nameRemark"]];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", gameInfo[@"nameRemark"]];
    self.nameRemark.hidden = isNameRemark;
    
    self.introduction.hidden = YES;
    self.firstTagLabel.hidden = YES;
    self.secondTagLabel.hidden = YES;
    self.thirdTagLabel.hidden = YES;
    NSString *desc = gameInfo[@"game_desc"];
    if (![YYToolModel isBlankString:desc])
    {
        NSArray *tagArray = [desc componentsSeparatedByString:@"+"];
        for (int i = 0; i < tagArray.count; i ++)
        {
            NSString * tagStr = [tagArray[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (i == 0)
            {
                self.firstTagLabel.hidden = NO;
                self.firstTagLabel.text  = [NSString stringWithFormat:@"%@", tagStr];
            }
            else if (i == 1)
            {
                self.secondTagLabel.hidden = NO;
                self.secondTagLabel.text = [NSString stringWithFormat:@"%@", tagStr];
            }
            else if (i == 2)
            {
                self.thirdTagLabel.hidden = NO;
                self.thirdTagLabel.text = [NSString stringWithFormat:@"%@", tagStr];
            }
        }
    }
    else
    {
        self.introduction.hidden = NO;
        self.introduction.text = gameInfo[@"introduction"];
    }
}

- (IBAction)receivedBtnClick:(id)sender
{
    UIViewController * vc = [YYToolModel getCurrentVC];
//
//    MyReceiveGameVoucherApi * api = [[MyReceiveGameVoucherApi alloc] init];
//    api.voucher_id = self.dataDic[@"id"];
//    [MBProgressHUD showProgress:@"请稍后..." toView:vc.view];
//    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
//        [MBProgressHUD hideHUDForView:vc.view];
//        if (request.success == 1)
//        {
//            [MBProgressHUD showToast:@"领取成功" toView:vc.view];
//            if (self.refreshDataAction)
//            {
//                self.refreshDataAction();
//            }
//        }
//        else
//        {
//            [MBProgressHUD showToast:request.error_desc toView:vc.view];
//        }
//    } failureBlock:^(BaseRequest * _Nonnull request) {
//        [MBProgressHUD hideHUDForView:vc.view];
//        [MBProgressHUD showToast:request.error_desc toView:vc.view];
//    }];
    
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.gameID = self.dataDic[@"game_info"][@"game_id"];
    info.isVoucherCenter = YES;
    info.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:info animated:YES];
}

@end
