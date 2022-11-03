//
//  ConfirmAccountViewController.m
//  Game789
//
//  Created by maiyou on 2021/5/26.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "ConfirmAccountViewController.h"
#import "AccountCencelSubmitAPI.h"

@interface ConfirmAccountViewController ()

@property(nonatomic,weak)IBOutlet NSLayoutConstraint * top;
@property(nonatomic,weak)IBOutlet UILabel * contentLabel;
@property(nonatomic,weak)IBOutlet UIView * coverView;

@end

@implementation ConfirmAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.top.constant = kStatusBarAndNavigationBarHeight + 20;
    self.navBar.title = @"账号资产确认";
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] init];
    NSDictionary * attrDic = @{NSForegroundColorAttributeName:FontColor28, NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSDictionary * attrDic1 = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF5E00"]};
    for (int i = 0; i < self.assetsList.count; i++)
    {
        NSString * key = [self.assetsList allKeys][i];
        NSString * value = [NSString stringWithFormat:@"%@", self.assetsList[key]];
        NSString * item = @"";
        if ([key isEqualToString:@"ptb"])
        {
            item = [NSString stringWithFormat:@"%d.剩余%@平台币\n", i + 1, value];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:item];
            NSRange range = NSMakeRange(0, item.length - 1);
            NSRange range1 = [item rangeOfString:value];
            [attr addAttributes:attrDic range:range];
            [attr addAttributes:attrDic1 range:range1];
            [attributedString appendAttributedString:attr];
        }
        else if ([key isEqualToString:@"balance"])
        {
            item = [NSString stringWithFormat:@"%d.剩余%@金币\n", i + 1, value];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:item];
            NSRange range = NSMakeRange(0, item.length - 1);
            NSRange range1 = [item rangeOfString:value];
            [attr addAttributes:attrDic range:range];
            [attr addAttributes:attrDic1 range:range1];
            [attributedString appendAttributedString:attr];
        }
        else if ([key isEqualToString:@"voucher"])
        {
            item = [NSString stringWithFormat:@"%d.可用优惠券%@张\n", i + 1, value];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:item];
            NSRange range = NSMakeRange(0, item.length - 1);
            NSRange range1 = [item rangeOfString:value];
            [attr addAttributes:attrDic range:range];
            [attr addAttributes:attrDic1 range:range1];
            [attributedString appendAttributedString:attr];
        }
        else if ([key isEqualToString:@"vip"])
        {
            item = [NSString stringWithFormat:@"%d.VIP剩余%@天\n", i + 1, value];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:item];
            NSRange range = NSMakeRange(0, item.length - 1);
            NSRange range1 = [item rangeOfString:value];
            [attr addAttributes:attrDic range:range];
            [attr addAttributes:attrDic1 range:range1];
            [attributedString appendAttributedString:attr];
        }
        else if ([key isEqualToString:@"mcard"])
        {
            item = [NSString stringWithFormat:@"%d.省钱卡剩余%@天\n", i + 1, value];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:item];
            NSRange range = NSMakeRange(0, item.length - 1);
            NSRange range1 = [item rangeOfString:value];
            [attr addAttributes:attrDic range:range];
            [attr addAttributes:attrDic1 range:range1];
            [attributedString appendAttributedString:attr];
        }
    }
    self.contentLabel.attributedText = attributedString;
}

- (IBAction)showAlert:(id)sender{
    [UIView animateWithDuration:0.1 animations:^{
        self.coverView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)cancellationAction:(id)sender{
    AccountCencelSubmitAPI * api = [[AccountCencelSubmitAPI alloc] init];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginExitNotice object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showMessage:request.error_desc toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (IBAction)dismiss:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.1 animations:^{
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)submitAction:(id)sender{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
