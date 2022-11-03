//
//  DownloadPromptViewController.m
//  Game789
//
//  Created by maiyou on 2021/6/24.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "DownloadPromptViewController.h"

@interface DownloadPromptViewController ()

@property(nonatomic,copy) NSString * gameIcon;
@property(nonatomic,weak)IBOutlet UIView * contentView;
@property(nonatomic,strong)BTCoverVerticalTransition * transition;

@end

@implementation DownloadPromptViewController

- (instancetype)initWithGameIcon:(NSString *)gameIcon
{
    self = [super init];
    if (self) {
        _transition = [[BTCoverVerticalTransition alloc] initPresentViewController:self withRragDismissEnabal:YES];
        self.transitioningDelegate = _transition;
        self.gameIcon = gameIcon;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (UIView * view in self.contentView.subviews) {
        UIImageView * icon = [view viewWithTag:10];
        [icon yy_setImageWithURL:[NSURL URLWithString:self.gameIcon] placeholder:MYGetImage(@"game_icon")];
    }
}

- (IBAction)trustAction:(id)sender
{
    NSURL * url = [NSURL URLWithString:@"https://api3.app.99maiyou.com/static/uuid/milu.mobileprovision"];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)dismiss{
    [self dismissViewControllerAnimated:YES completion:^{
            
    }];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection
{
    // 适配屏幕，横竖屏
    self.preferredContentSize = CGSizeMake(kScreenW, 315);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
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
