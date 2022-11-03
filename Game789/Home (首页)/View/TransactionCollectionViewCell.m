//
//  TransactionCollectionViewCell.m
//  Game789
//
//  Created by Maiyou on 2018/12/4.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "TransactionCollectionViewCell.h"

@implementation TransactionCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    UILabel * showDiscount = [[UILabel alloc] initWithFrame:CGRectMake(15, self.game_icon.center.y - 23, self.game_icon.width, 15)];
//    showDiscount.textAlignment = NSTextAlignmentCenter;
//    showDiscount.backgroundColor = [UIColor redColor];
//    showDiscount.text = @"出售中".localized;
//    showDiscount.textColor = [UIColor whiteColor];
//    showDiscount.font = [UIFont boldSystemFontOfSize:9];
//    showDiscount.transform = CGAffineTransformMakeRotation(M_PI/4);
//    [self.game_icon addSubview:showDiscount];
    
    self.game_icon.clipsToBounds = YES;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = [dataDic deleteAllNullValue];
    
    [self.game_icon yy_setImageWithURL:[NSURL URLWithString:_dataDic[@"game_icon"]] placeholder:[UIImage imageNamed:@"game_icon"]];
    
    self.game_name.text = _dataDic[@"game_name"];
    
    self.salePrice.text = [NSString stringWithFormat:@"￥%@", _dataDic[@"trade_price"]];
}

@end
