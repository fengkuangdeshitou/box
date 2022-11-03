//
//  BaseTableViewCell.h
//  Game789
//
//  Created by xinpenghui on 2017/9/2.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
#import "UIColor+HexString.h"
#import "macro.h"
#import "MBProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BaseTableViewCell : UITableViewCell

@property (strong, nonatomic)BaseModel *model;

@property (assign, nonatomic) NSInteger row;

@property (nonatomic, strong) UIViewController * currentVC;

@property (nonatomic, strong) UITableView * tableView;

- (CGSize)getTextSize:(NSString *)text fontSize:(float)size width:(CGFloat)width;

- (void)setModelData:(NSString *)icon text:(NSString *)text;
//用户名
-(void)setAccount:(NSString *)account;


- (void)setContentArray:(NSArray *)array;
- (void)setModelDic:(NSDictionary *)dic;
- (void)setChargeDic:(NSDictionary *)dic;
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
@end
