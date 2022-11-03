//
//  MyUserReturnTaskCell.m
//  Game789
//
//  Created by Maiyou001 on 2022/3/1.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyUserReturnTaskCell.h"

@implementation MyUserReturnTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserModel:(MyUserReturnModel *)userModel
{
    _userModel = userModel;
    
    self.showImage.image = [UIImage imageNamed:userModel.imageName];
    
    self.showTitle.text = userModel.title;
    
    self.showDesc.text = userModel.desc;
    
    if ([userModel.type isEqualToString:@"sign"])
    {
        [self.showStatus setTitle:userModel.sign ? @"已完成" : @"前往" forState:0];
        self.showStatus.backgroundColor = [UIColor colorWithHexString:userModel.sign ? @"#CCCCCC" : @"#F85835"];
    }
    else
    {
        NSDictionary * dic = [userModel mj_keyValues];
        BOOL isFinish = [dic[userModel.type] boolValue];
        [self.showStatus setTitle:isFinish ? @"已完成" : @"未完成" forState:0];
        self.showStatus.backgroundColor = [UIColor colorWithHexString:isFinish ? @"#CCCCCC" : @"#F85835"];
    }
//    else if ([userModel.type isEqualToString:@"login_game"])
//    {
//
//    }
//    else if ([userModel.type isEqualToString:@"comments"])
//    {
//
//    }
//    else if ([userModel.type isEqualToString:@"amount1"])
//    {
//
//    }
//    else if ([userModel.type isEqualToString:@"amount10"])
//    {
//
//    }
    
}

- (IBAction)btnClick:(id)sender
{
    if (!self.userModel.sign && [self.userModel.type isEqualToString:@"sign"])
    {
        [[YYToolModel getCurrentVC].navigationController pushViewController:[MyTaskViewController new] animated:YES];
    }
}

@end
