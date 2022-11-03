//
//  MyTaskFinishCell.m
//  Game789
//
//  Created by Maiyou on 2020/10/16.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTaskFinishCell.h"
#import "MyAttentionAlertView.h"
#import "ModifyNameViewController.h"
#import "ModifyPwdViewController.h"
#import "BindMobileViewController.h"
#import "BindVerifyViewController.h"
#import "SecureViewController.h"
#import "YHTimeLineListController.h"

#import "MyTaskCenterApi.h"
@class MyFinishTaskGetCoinsApi;

@implementation MyTaskFinishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = UIColor.clearColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTaskModel:(MyTaskCellModel *)taskModel
{
    _taskModel = taskModel;
    
    [self.showIcon sd_setImageWithURL:[NSURL URLWithString:taskModel.imageName] placeholderImage:MYGetImage(@"game_icon")];
    
    self.showTitle.text = taskModel.title.localized;
    
    self.showDesc.text = taskModel.desc.localized;
    
    self.showCoinNum.text = taskModel.coinNum;
    
    if (taskModel.total.intValue > 0)
    {
        self.showProgress.text = [NSString stringWithFormat:@"(%@/%@) ", taskModel.progess, taskModel.total];
    }
    else
    {
        self.showProgress.text = @"";
    }
    
    self.contentLabel.text = [NSString stringWithFormat:@"%@%@",self.showProgress.text,self.showCoinNum.text];
    // yiwancheng lingqu quwancheng
    
    [self.receiveBtn setTitle:taskModel.btnTitle forState:UIControlStateNormal];
    
    if (taskModel.status)
    {
        if (taskModel.taked)
        {
            [self.receiveBtn setBackgroundImage:MYGetImage(@"yiwancheng") forState:UIControlStateNormal];
        }
        else
        {
            [self.receiveBtn setBackgroundImage:MYGetImage(@"lingqu") forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.receiveBtn setBackgroundImage:MYGetImage(taskModel.source == 0 ? @"newquwancheng" : @"quwancheng") forState:UIControlStateNormal];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (IBAction)receiveBtnClick:(id)sender
{
    [self pushToVc:self.taskModel];
}

- (void)pushToVc:(MyTaskCellModel *)model
{
    //已完成任务
    if (model.status)
    {
        if (!model.taked)//未领取
        {
            [self receiceRequest:model.type];
        }
    }
    else
    {
        UIViewController * vc = [YYToolModel getCurrentVC];
        if ([model.eventType isEqualToString:@"msg"]) {
            [vc jxt_showAlertWithTitle:@"温馨提示" message:model.alertMsg appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
                alertMaker.addActionCancelTitle(@"知道了");
            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
                
            }];
            return;
        }
        if ([model.type isEqualToString:@"avatar"])
        {
            SecureViewController * secure = [SecureViewController new];
            secure.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:secure animated:YES];
        }
        else if ([model.type isEqualToString:@"nickname"])
        {
            ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
            bindVC.title = @"昵称".localized;
            bindVC.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:bindVC animated:YES];
        }
        else if ([model.type isEqualToString:@"mobile"])
        {
            [self pushBindMobileVC:vc];
        }
        else if ([model.type isEqualToString:@"authentication"])
        {
//            ModifyNameViewController *bindVC = [[ModifyNameViewController alloc] init];
//            bindVC.title = @"实名认证".localized;
//            bindVC.hidesBottomBarWhenPushed = YES;
//            [vc.navigationController pushViewController:bindVC animated:YES];
            [AuthAlertView showAuthAlertViewWithDelegate:self];
        }
        else if ([model.type isEqualToString:@"playGame"])
        {
//            [vc jxt_showAlertWithTitle:@"温馨提示" message:model.desc appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
//                alertMaker.addActionCancelTitle(@"知道了");
//            } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
//
//            }];
        }
        else if ([model.type isEqualToString:@"weixin"])
        {
            [self showAttentionView:YES];
        }
        else if ([model.type isEqualToString:@"douyin"])
        {
            [self showAttentionView:NO];
        }
//        else if ([model.type isEqualToString:@"loginGame"] || [model.type isEqualToString:@"recharge"])
//        {
//            [self showTipView:model];
//        }
        else if ([model.type isEqualToString:@"wxshare"] || [model.type isEqualToString:@"qqkongjian"])
        {
            [self pushShareInviteFriend:@""];
        }
//        else if ([model.type isEqualToString:@"CumulativeSignIn"] || [model.type isEqualToString:@"Recharge100"] || [model.type isEqualToString:@"Recharge1000"] || [model.type isEqualToString:@"goodCommentNew"])
//        {
//            [self showTipView:model];
//        }
        else if ([model.type isEqualToString:@"publishArticle"])
        {
            YHTimeLineListController *bindVC = [[YHTimeLineListController alloc] init];
            bindVC.hidesBottomBarWhenPushed = YES;
            [vc.navigationController pushViewController:bindVC animated:YES];
        }
    }
}

- (void)onAuthSuccess{
    if (self.receiveBtnBlock) {
        self.receiveBtnBlock(self.taskModel);
    }
}

- (void)showTipView:(MyTaskCellModel *)model
{
    NSString * desc = model.desc;
    if ([model.type isEqualToString:@"Recharge100"] || [model.type isEqualToString:@"Recharge1000"] || [model.type isEqualToString:@"recharge"])
    {
        desc = @"仅计算现金/平台币充值游戏";
    }
    UIViewController * vc = [YYToolModel getCurrentVC];
    [vc jxt_showAlertWithTitle:@"温馨提示" message:desc appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"知道了");
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        
    }];
}

#pragma mark ——— 关注微信公众号和抖音
- (void)showAttentionView:(BOOL)isWx
{
    MyAttentionAlertView * attentionView = [[MyAttentionAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    attentionView.tips = self.taskModel.tips;
    attentionView.is_ua8x = self.is_ua8x;
    attentionView.isWx = isWx;
    attentionView.exchangeCodeBlock = ^(BOOL isWx) {
        if (self.receiveBtnBlock) {
            self.receiveBtnBlock(self.taskModel);
        }
    };
    [[YYToolModel getCurrentVC].view addSubview:attentionView];
}

#pragma mark ——— 绑定手机号
- (void)pushBindMobileVC:(UIViewController *)vc
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"member_info"];
    NSString *moblie = dic[@"mobile"];

    if (!moblie || moblie.length == 0) {
        BindMobileViewController *bindVC = [[BindMobileViewController alloc] init];
        [vc.navigationController pushViewController:bindVC animated:YES];
    }else{
        [vc jxt_showActionSheetWithTitle:nil message:nil appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
            alertMaker.
            addActionDefaultTitle(@"解绑当前手机号").
            addActionDefaultTitle(@"更换当前手机号").
            addActionCancelTitle(@"取消");
        } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
            MYLog(@"==============%ld", (long)buttonIndex);
            if (buttonIndex == 0 || buttonIndex == 1)
            {
                BindVerifyViewController *verifyVC = [[BindVerifyViewController alloc]init];
                verifyVC.bandMobile = moblie;
                verifyVC.isRebind = (buttonIndex == 0 ? NO : YES);
                [vc.navigationController pushViewController:verifyVC animated:YES];
            }
        }];
    }
}
#pragma mark ——— 点击领取
- (void)receiceRequest:(NSString *)name
{
    MyFinishTaskGetCoinsApi * api = [MyFinishTaskGetCoinsApi new];
    api.isShow = YES;
    api.name = name;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [YJProgressHUD showSuccess:@"领取成功" inview:[YYToolModel getCurrentVC].view];
            if (self.receiveBtnBlock) {
                self.receiveBtnBlock(self.taskModel);
            }
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark - 分享邀请好友
- (void)pushShareInviteFriend:(NSString *)type
{
    [[YYToolModel getCurrentVC].navigationController pushViewController:[MyInviteFriendsController new] animated:YES];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat maxWidth = CGRectGetMaxX(self.showCoinNum.frame);
    if (maxWidth+76+7+30>ScreenWidth) {
        self.showCoinNum.hidden = true;
        self.showProgress.hidden = true;
        self.content_height.constant = 10;
    }else{
        self.content_height.constant = 0;
    }
}

@end
