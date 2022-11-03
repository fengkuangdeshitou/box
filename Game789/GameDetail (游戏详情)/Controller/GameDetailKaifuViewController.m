//
//  GameDetailKaifuViewController.m
//  Game789
//
//  Created by Maiyou on 2018/11/6.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "GameDetailKaifuViewController.h"

@interface GameDetailKaifuViewController ()

@end

@implementation GameDetailKaifuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
}

- (void)prepareBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.title = @"开服列表";
    
    KaifuView * kaifuView = [[KaifuView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:kaifuView];
    self.kaifuView = kaifuView;
    
    kaifuView.kaifuArray = self.dataDic[@"game_info"][@"kaifu_info"];
    kaifuView.game_info  = self.dataDic[@"game_info"];
}


@end
