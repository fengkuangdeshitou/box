//
//  HomeAlertImageView.m
//  Game789
//
//  Created by maiyou on 2022/10/18.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "HomeAlertImageView.h"

@implementation HomeAlertImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close_tips"]];
        icon.frame = CGRectMake(15, 7, 6, 6);
        [self addSubview:icon];
        self.userInteractionEnabled = true;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)ges{
    CGPoint point = [ges locationInView:self];
    if (point.x < 60){
        [self removeFromSuperview];
    }else{
        if(self.didBlock){
            self.didBlock();
        }
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
