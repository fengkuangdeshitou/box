//
//  DetailIntroduceView.h
//  Game789
//
//  Created by xinpenghui on 2017/9/12.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailIntroduceViewDelegate <NSObject>

- (void)expandPress:(BOOL)expand withHeight:(float)height;

@end

@interface DetailIntroduceView : UIView

@property (weak, nonatomic) id<DetailIntroduceViewDelegate>delegate;

- (CGSize)getLabelSize:(NSString *)string;
- (void)ifExpendBtnHidden:(BOOL)hidden;
- (void)resetLabelFrame;
- (void)resetIntrLabelFrame;
@end
