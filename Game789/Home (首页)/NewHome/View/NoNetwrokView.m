//
//  NoNetwrokView.m
//  Trading
//
//  Created by maiyou on 2021/8/13.
//

#import "NoNetwrokView.h"

@interface NoNetwrokView ()

@property(nonatomic,weak)IBOutlet UIButton * reloadButton;
@property(nonatomic,weak)IBOutlet UIButton * settingButton;
@property(nonatomic,weak)IBOutlet UIView * contentView;
@property(nonatomic,weak)IBOutlet UILabel * contentLabel;

@end

@implementation NoNetwrokView

+ (NoNetwrokView *)sharedInstance{
    NoNetwrokView * _noNetworkView = [[NoNetwrokView alloc] init];
    return _noNetworkView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle.mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        self.contentView.frame = CGRectMake(0, ScreenHeight/2-180, ScreenWidth, 260);
        self.contentLabel.text = [NSString stringWithFormat:@"1、检查Wi-Fi或蜂窝移动数据是否开启且可用\n2、前往\"设置->%@\"中允许访问无线数据",NSBundle.mainBundle.infoDictionary[@"CFBundleDisplayName"]];
        [self addBorderWithView:self.reloadButton];
        [self addBorderWithView:self.settingButton];
    }
    return self;
}

- (void)addBorderWithView:(UIView *)view{
    view.layer.borderColor = MAIN_COLOR.CGColor;
    view.layer.borderWidth = 0.5;
    view.layer.cornerRadius = 3;
    view.layer.masksToBounds = YES;
}

- (IBAction)reloadReauest:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onAgainRequestAction)]) {
        [self.delegate onAgainRequestAction];
    }
}

- (IBAction)settingAction:(id)sender{
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)show{
    self.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [[YYToolModel getCurrentVC].view addSubview:self];
}

- (void)dismiss{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
