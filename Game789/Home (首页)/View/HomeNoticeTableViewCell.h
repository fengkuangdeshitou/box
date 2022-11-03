//
//  HomeNoticeTableViewCell.h
//  Game789
//
//  Created by xinpenghui on 2017/9/2.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface HomeNoticeTableViewCell : BaseTableViewCell
@property (assign,nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UILabel *activity;
@end
