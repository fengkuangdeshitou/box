//
//  MyTradeOfficialSelectionCell.h
//  Game789
//
//  Created by Maiyou on 2020/4/1.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradingListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyTradeOfficialSelectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet YYAnimatedImageView *game_icon;
@property (weak, nonatomic) IBOutlet UILabel *showPrice;
@property (weak, nonatomic) IBOutlet UILabel *game_name;
@property (weak, nonatomic) IBOutlet UILabel *game_des;
@property (weak, nonatomic) IBOutlet UILabel *showNum;
@property (nonatomic, strong) TradingListModel * listModel;
@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
