//
//  MainSearchView.h
//  Game789
//
//  Created by xinpenghui on 2017/9/7.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainSearchViewDelegate <NSObject>

- (void)getSearchViewText:(NSString *)string;

@end

@interface MainSearchView : UIView

@property (weak, nonatomic) IBOutlet GameTextField *searchTextField;
@property(nonatomic,assign)NSInteger current;

/**  是否是礼包页面的搜索  */
@property (nonatomic, assign) BOOL isGift;
@property (nonatomic, assign) BOOL isHome;
@property (weak, nonatomic)id <MainSearchViewDelegate>delegate;

- (void)textBecomeReigster;
- (void)resetColors;
- (NSString *)getSearchText;

@end
