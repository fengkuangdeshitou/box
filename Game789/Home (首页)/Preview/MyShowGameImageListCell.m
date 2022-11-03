//
//  MyShowGameImageListCell.m
//  Game789
//
//  Created by Maiyou on 2019/10/25.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "MyShowGameImageListCell.h"

@implementation MyShowGameImageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)playButtonClick:(id)sender
{
    UIButton * button = sender;
    if (self.playVideoAction)
    {
        self.playVideoAction(button.tag);
    }
}

@end
