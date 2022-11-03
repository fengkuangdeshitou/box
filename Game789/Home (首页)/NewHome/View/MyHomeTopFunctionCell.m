//
//  MyHomeTopFunctionCell.m
//  Game789
//
//  Created by Maiyou on 2020/7/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyHomeTopFunctionCell.h"

@implementation MyHomeTopFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.redView.hidden = YES;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [self.showImage yy_setImageWithURL:[NSURL URLWithString:dataDic[@"icon"]] placeholder:MYGetImage(@"game_icon")];
    
    NSString * title = dataDic[@"title"];
    self.showTitle.text = title;
    if ([YYToolModel isBlankString:title])
    {
        self.showImage_height.constant = 65;
    }
    else
    {
        self.showImage_height.constant = 54;
    }
    
    //友盟数据上报
    if ([dataDic[@"jumpType"] isEqualToString:@"active_novice"] || [dataDic[@"jumpType"] isEqualToString:@"active_flyback"])
    {
        [MyAOPManager relateStatistic:@"ShowNewAndOldUserWelfareIcon" Info:@{@"jumpType":dataDic[@"jumpType"]}];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
//    NSString * time = [YYToolModel getUserdefultforKey:@"MyNewGameReserve"];
//    NSString * nowTime = [NSDate getNowTimeTimestamp:@"yyyy-MM-dd"];
//    if (indexPath.item == 0 && ![time isEqualToString:nowTime])
//    {
//        self.redView.hidden = NO;
//    }
//    else
//    {
//        self.redView.hidden = YES;
//    }
}

- (IBAction)cellBtnClick:(id)sender
{
    UIButton * button = sender;
    
//    if (button.tag == 0)
//    {
//        self.redView.hidden = YES;
//        NSString * time = [NSDate getNowTimeTimestamp:@"yyyy-MM-dd"];
//        [YYToolModel saveUserdefultValue:time forKey:@"MyNewGameReserve"];
//    }

    if (self.cellBtnBlock)
    {
        self.cellBtnBlock(button.tag);
    }
}

@end
