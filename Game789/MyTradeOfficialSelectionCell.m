//
//  MyTradeOfficialSelectionCell.m
//  Game789
//
//  Created by Maiyou on 2020/4/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTradeOfficialSelectionCell.h"

@implementation MyTradeOfficialSelectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListModel:(TradingListModel *)listModel
{
    _listModel = listModel;
    
    self.game_name.text = [NSString stringWithFormat:@"#%@#", listModel.title];
    
    self.game_des.text = listModel.game_name;
    
    self.showPrice.text = listModel.trade_price;
    
    [self.game_icon yy_setImageWithURL:[NSURL URLWithString:listModel.game_icon] placeholder:MYGetImage(@"game_icon")];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.game_des.text = dataDic[@"game_info"][@"game_name"];
    
    NSString * type = dataDic[@"game_info"][@"game_classify_type"];
    if ([type hasPrefix:@" "])
    {
        type = [type substringFromIndex:1];
    }
    self.game_name.text = [NSString stringWithFormat:@"%@｜%@人在玩", type, dataDic[@"game_info"][@"howManyPlay"]];
    self.game_name.textColor = FontColor99;
    self.game_name.font = [UIFont systemFontOfSize:12];
    self.game_name.backgroundColor = [UIColor whiteColor];
    
    self.showPrice.text = dataDic[@"total_amount"];
    
    [self.game_icon yy_setImageWithURL:[NSURL URLWithString:dataDic[@"game_info"][@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    
    self.showNum.text = [NSString stringWithFormat:@"共%@张券", dataDic[@"count_amount"]];
}

@end
