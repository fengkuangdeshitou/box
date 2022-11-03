//
//  CommitDetailCell.h
//  Game789
//
//  Created by Maiyou on 2018/8/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *showIcon;
@property (weak, nonatomic) IBOutlet UILabel *showName;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *showMgs;

@property (nonatomic, strong) NSDictionary * commitDic;

@end
