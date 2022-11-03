//
//  KaifuCell.h
//  Game789
//
//  Created by Maiyou on 2018/8/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KaifuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *hsowType;
@property (weak, nonatomic) IBOutlet UIButton *remindButton;

@property (nonatomic, strong) NSDictionary * kaifuDic;
@property (nonatomic, strong) NSDictionary * game_info;

@end
