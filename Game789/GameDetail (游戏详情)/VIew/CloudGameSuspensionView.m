//
//  CloudGameSuspensionView.m
//  Game789
//
//  Created by maiyou on 2021/6/22.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "CloudGameSuspensionView.h"

@interface CloudGameSuspensionView ()

@property(nonatomic,weak)IBOutlet UIView * contentView;
@property (weak, nonatomic) IBOutlet UIButton *clarityBtn;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;

@end

@implementation CloudGameSuspensionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]lastObject];
        self.frame = frame;
        self.layer.cornerRadius = frame.size.height/2;
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]];
        
        [self.clarityBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:2.5];
        [self.returnBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:2.5];
    }
    return self;
}

- (void)setIsH5Game:(BOOL)isH5Game
{
    _isH5Game = isH5Game;
    
    self.clarityBtn.hidden = YES;
}

- (IBAction)imageQualityAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onImageQualityAction)]) {
        [self.delegate onImageQualityAction];
    }
}

- (IBAction)exitAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onExitAction)]) {
        [self.delegate onExitAction];
    }
}

- (IBAction)rotatingAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.contentView.hidden = sender.selected;
    
    [UIView animateWithDuration:0.25 animations:^{
        if (sender.selected) {
            sender.transform = CGAffineTransformMakeRotation(M_PI);
        }else{
            sender.transform = CGAffineTransformMakeRotation(0);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)panAction:(UIPanGestureRecognizer *)gestureRecognizer{
    UIView *piece = [gestureRecognizer view];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        piece.center = CGPointMake(piece.center.x + translation.x, piece.center.y + translation.y);
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat y = 0;
        if (self.y-35 < kStatusBarAndNavigationBarHeight) {
            y = kStatusBarAndNavigationBarHeight;
        }else if (self.y > SCREEN_HEIGHT-kTabbarHeight-self.height){
            y = SCREEN_HEIGHT-kTabbarHeight-35-self.height;
        }else{
            y = self.y;
        }
        [UIView animateWithDuration:0.25 animations:^{
//            if (self.x+self.width/2 <= SCREEN_WIDTH/2) {
//                self.frame = CGRectMake(0, y , self.width, self.height);
//            }else{
                self.frame = CGRectMake(SCREEN_WIDTH-self.width, y, self.width, self.height);
//            }
        }];
    }
}

@end
