//
//  GoldExchangeAlertView.m
//  Game789
//
//  Created by maiyou on 2021/3/18.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "GoldExchangeAlertView.h"

@interface GoldExchangeAlertView ()

@property(nonatomic,weak)id<GoldExchangeAlertViewDelegate>delegate;
@property(nonatomic,weak)IBOutlet UILabel * contentLabel;

@end

@implementation GoldExchangeAlertView

+ (void)showGoldExchangeAlertViewWithNumber:(NSString *)number delegate:(id<GoldExchangeAlertViewDelegate>)delegate{
    GoldExchangeAlertView * alertView = [[GoldExchangeAlertView alloc] initWithNumber:number delegate:delegate];
    [alertView show];
}

- (instancetype)initWithNumber:(NSString *)number delegate:(id<GoldExchangeAlertViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        self.frame = UIScreen.mainScreen.bounds;
        self.alpha = 0;
        [UIApplication.sharedApplication.keyWindow addSubview:self];
        self.contentLabel.text = [NSString stringWithFormat:@"需消耗%@金币",number];
        self.delegate = delegate;
    }
    return self;
}

- (void)show{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
}

- (IBAction)dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)exchangeAction:(id)sender{
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(goldExchangeAlertViewDidEcchange)]) {
        [self.delegate goldExchangeAlertViewDidEcchange];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
