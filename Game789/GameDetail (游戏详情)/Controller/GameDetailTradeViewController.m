//
//  GameDetailTradeViewController.m
//  Game789
//
//  Created by Maiyou on 2018/11/6.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "GameDetailTradeViewController.h"

@interface GameDetailTradeViewController ()

@end

@implementation GameDetailTradeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
}

- (void)prepareBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    TradeDetailView * tradeView = [[TradeDetailView alloc] initWithFrame:self.view.bounds Game_id:self.dataDic[@"game_info"][@"game_id"]];
    tradeView.currentVC = self;
    [self.view addSubview:tradeView];
    self.tradeView = tradeView;
}

@end
