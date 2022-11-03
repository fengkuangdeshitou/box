//
//  GameDetailKaifuViewController.h
//  Game789
//
//  Created by Maiyou on 2018/11/6.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "BaseViewController.h"
#import "KaifuView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameDetailKaifuViewController : BaseViewController

@property (nonatomic, strong) KaifuView * kaifuView;

@property (nonatomic, strong) NSDictionary * dataDic;

@end

NS_ASSUME_NONNULL_END
