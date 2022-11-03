//
//  MyNewGamesSectionView.m
//  Game789
//
//  Created by Maiyou on 2020/4/16.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyNewGamesSectionView.h"
#import "MyGamePreviewController.h"

@implementation MyNewGamesSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyNewGamesSectionView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = BackColor;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewMorePreviewGames)];
        [self.moreView addGestureRecognizer:tap];
    }
    return self;
}

- (void)viewMorePreviewGames
{
    MyGamePreviewController * preview = [MyGamePreviewController new];
    preview.hidesBottomBarWhenPushed = YES;
    [self.currentVC.navigationController pushViewController:preview animated:YES];
}

@end
