//
//  GameDetailTradeViewController.h
//  Game789
//
//  Created by Maiyou on 2018/11/6.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"
#import "TradeDetailView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameDetailTradeViewController : BaseViewController

@property (nonatomic, strong) TradeDetailView * tradeView;

@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
