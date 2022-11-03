//
//  GetSettingNewsMgsCell.h
//  Game789
//
//  Created by Maiyou on 2018/9/4.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GetSettingNewsMgsModel.h"

@interface GetSettingNewsMgsCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *showTitle;
@property (weak, nonatomic) IBOutlet UILabel *showTime;
@property (weak, nonatomic) IBOutlet UILabel *showContent;
@property (weak, nonatomic) IBOutlet UIView *readTagView;
@property (weak, nonatomic) IBOutlet UILabel *enterText;

@property (nonatomic, strong) GetSettingNewsMgsModel * newsModel;

@end
