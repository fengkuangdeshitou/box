//
//  ExclusiveRulesView.m
//  Game789
//
//  Created by maiyou on 2022/3/2.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "ExclusiveRulesView.h"

@implementation ExclusiveRulesView

+ (void)showExclusiveRulesView{
    ExclusiveRulesView * view = [[ExclusiveRulesView alloc] init];
    [view show];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle.mainBundle loadNibNamed:@"ExclusiveRulesView" owner:nil options:nil] lastObject];
        self.frame = UIScreen.mainScreen.bounds;
        self.alpha = 0;
        [UIApplication.sharedApplication.keyWindow addSubview:self];
    }
    return self;
}

- (void)show{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
}

- (IBAction)dismiss:(id)sender{
    [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
