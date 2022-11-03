//
//  MyNewHomeHotGameListCell.h
//  Game789
//
//  Created by Maiyou on 2020/8/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHPageControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyNewHomeHotGameListCell : UITableViewCell <WSLRollViewDelegate, XHPageControlDelegate>

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) WSLRollView *pageRollView;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) NSMutableArray * dataArrSource;
@property (nonatomic, strong) UIViewController * currentVC;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) XHPageControl * pageControl;
@end

NS_ASSUME_NONNULL_END
