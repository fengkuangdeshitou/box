
//
//  MainSearchView.m
//  Game789
//
//  Created by xinpenghui on 2017/9/7.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "MainSearchView.h"
#import "GameTextField.h"

@interface MainSearchView () <UITextFieldDelegate>

@property(nonatomic,strong)NSTimer * timer;

@end

@implementation MainSearchView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.current = 0;
    NSString * holderText = @"请搜索您要玩的游戏".localized;
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithHexString:@"#999999"]
                            range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium]
                            range:NSMakeRange(0, holderText.length)];
    self.searchTextField.attributedPlaceholder = placeholder;
}

- (void)setIsHome:(BOOL)isHome
{
    _isHome = isHome;
    
    __block NSString * holderText = @"请搜索您要玩的游戏".localized;
    NSArray * homeSearchDefaultTitleList = [DeviceInfo shareInstance].homeSearchDefaultTitleList;
    if (homeSearchDefaultTitleList.count > 0) {
        NSString * string = homeSearchDefaultTitleList[0];
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:string];
        [placeholder addAttribute:NSForegroundColorAttributeName
                                value:[UIColor colorWithHexString:@"#999999"]
                                range:NSMakeRange(0, string.length)];
        [placeholder addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium]
                                range:NSMakeRange(0, string.length)];
        self.searchTextField.attributedPlaceholder = placeholder;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:true block:^(NSTimer * _Nonnull timer) {
            if (self.current == homeSearchDefaultTitleList.count-1) {
                self.current = 0;
            }else{
                self.current ++;
            };
            NSString * defaultText = homeSearchDefaultTitleList[self.current];
            if (isHome && homeSearchDefaultTitleList)
            {
                holderText = defaultText;
            }
            NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
            [placeholder addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorWithHexString:@"#999999"]
                                    range:NSMakeRange(0, holderText.length)];
            [placeholder addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium]
                                    range:NSMakeRange(0, holderText.length)];
            self.searchTextField.attributedPlaceholder = placeholder;
        }];
    }
}

- (void) done:(id)sender {
    NSLog(@"完成");
}

- (void)textBecomeReigster {
    [self.searchTextField becomeFirstResponder];
}

- (IBAction)searchTextChange:(id)sender
{
    MYLog(@"========%@", self.searchTextField.text);
    if (self.searchTextField.markedTextRange == nil)
    {
        if (self.searchTextField.text.length > 10)
        {
            self.searchTextField.text = [self.searchTextField.text substringToIndex:10];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(getSearchViewText:)])
        {
            [self.delegate getSearchViewText:self.searchTextField.text];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"text field = %@textField.text=%@",string,textField.text);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.delegate getSearchViewText:textField.text];
    NSLog(@"键盘消失textFieldShouldReturn");
    return YES;
}

- (NSString *)getSearchText {
    return self.searchTextField.text;
}


@end
