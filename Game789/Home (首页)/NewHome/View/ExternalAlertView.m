//
//  ExternalAlertView.m
//  Game789
//
//  Created by maiyou on 2022/7/20.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "ExternalAlertView.h"
#import "WebViewController.h"

@interface ExternalAlertView ()

@property(nonatomic,weak)IBOutlet UILabel * content;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UIButton * done;

@end

@implementation ExternalAlertView

- (IBAction)dismissAction{
    [self dismissAnimation];
}

- (IBAction)doneAction{
    [self dismissAction];
    if (self.zt.length > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WebViewController * web = [[WebViewController alloc] init];
            web.urlString = [self.zu stringByRemovingPercentEncoding];
            web.hidesBottomBarWhenPushed = true;
            web.webTitle = self.content.text;
            [YYToolModel.getCurrentVC.navigationController pushViewController:web animated:true];
        });
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UINavigationController *nav = [[UIApplication sharedApplication] visibleNavigationController];
            GameDetailInfoController *vc = [[GameDetailInfoController alloc] init];
            if (self.c) {
                vc.c = self.c;
            }
            vc.hidesBottomBarWhenPushed = YES;
            vc.gameID = self.b;
            [nav pushViewController:vc animated:YES];
        });
    }
}

- (void)setZt:(NSString *)zt{
    _zt = zt;
    self.content.text = [[zt stringByRemovingPercentEncoding] stringByAppendingString:@"类游戏"];
    self.content.textColor = MAIN_COLOR;
    self.done.backgroundColor = MAIN_COLOR;
}

- (void)setB:(NSString *)b{
    _b = b;
    self.titleLabel.text = [[self.titleLabel.text stringByRemovingPercentEncoding] stringByAppendingString:@"游戏"];
    self.content.text = @"";
    self.content.textColor = MAIN_COLOR;
    self.done.backgroundColor = MAIN_COLOR;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
