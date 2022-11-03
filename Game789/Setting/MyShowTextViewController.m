//
//  MyShowTextViewController.m
//  Game789
//
//  Created by Maiyou on 2019/4/25.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyShowTextViewController.h"

@interface MyShowTextViewController ()

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UITextView * textView;

@end

@implementation MyShowTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = self.showTitle;
    
    self.timeLabel.text = [self timeWithTimeIntervalString:self.showTime];
    
    self.textView.text = self.showContent;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10+kStatusBarAndNavigationBarHeight, kScreen_width, 15)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        [self.view addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.timeLabel.frame) + 10, kScreenW - 20, kScreenH - CGRectGetMaxY(self.timeLabel.frame) - 10 - hxBottomMargin)];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.userInteractionEnabled = false;
        [self.view addSubview:_textView];
    }
    return _textView;
}

@end
