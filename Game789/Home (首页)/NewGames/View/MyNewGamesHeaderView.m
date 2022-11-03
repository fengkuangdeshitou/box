//
//  MyNewGamesHeaderView.m
//  Game789
//
//  Created by Maiyou on 2019/10/31.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyNewGamesHeaderView.h"

@implementation MyNewGamesHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyNewGamesHeaderView" owner:self options:nil].firstObject;
        self.frame = frame;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    for (int i = 0; i < dataArray.count; i ++)
    {
        NSDictionary * dic = dataArray[i];
        
        NSString * gameIcon = dic[@"game_icon"];
        YYAnimatedImageView * imageView = (YYAnimatedImageView *)[self viewWithTag:i + 10];
        [imageView yy_setImageWithURL:[NSURL URLWithString:gameIcon] placeholder:MYGetImage(@"game_icon")];
        
        UILabel * label1 = [self viewWithTag:i + 20];
        label1.text = dic[@"game_name"];
        
        UILabel * label2 = [self viewWithTag:i + 30];
        label2.text = dic[@"game_classify_type"];
    }
}

- (IBAction)downLoadClick:(id)sender
{
    UIButton * button = sender;
    
    NSDictionary * dic = self.dataArray[button.tag - 50];
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.gameID = dic[@"game_id"];
    [self.currentVC.navigationController pushViewController:info animated:YES];
}

@end
