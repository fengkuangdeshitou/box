//
//  MyGameVideoTrackCell.m
//  Game789
//
//  Created by Maiyou on 2020/4/9.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameVideoTrackCell.h"

@implementation MyGameVideoTrackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAweme:(Aweme *)aweme
{
    _aweme = aweme;
    
    [self.gameVideoIcon sd_setImageWithURL:[NSURL URLWithString:aweme.video_img_url]];
    
    self.gameName.text = aweme.game_name;
    
    self.downloadCount.text = [NSString stringWithFormat:@"%@人玩过", aweme.game_download_num];
    
    self.addTime.text = [NSDate dateWithFormat:@"MM-dd HH:mm" WithTS:aweme.liketime.floatValue];
    
    self.gameType.text = aweme.game_classify_type;
    
    //返回福利标签或是一句话  如果有详情介绍，显示，没有显示送VIP送福利
    if ([YYToolModel isBlankString:aweme.introduction])
    {
        self.showContent.hidden = YES;
        self.firstLabel.hidden = YES;
        self.secondLabel.hidden = YES;
        self.thirdLabel.hidden = YES;
        self.fourLabel.hidden = YES;
        NSString *desc = aweme.game_desc;
        if (![YYToolModel isBlankString:desc])
        {
            NSArray *tagArray = [desc componentsSeparatedByString:@"+"];
            for (int i = 0; i < tagArray.count; i ++)
            {
                if (i == 0)
                {
                    self.firstLabel.hidden = NO;
                    self.firstLabel.text  = [NSString stringWithFormat:@" %@ ", tagArray[i]];
                }
                else if (i == 1)
                {
                    self.secondLabel.hidden = NO;
                    self.secondLabel.text = [NSString stringWithFormat:@" %@ ", tagArray[i]];
                }
                else if (i == 2)
                {
                    self.thirdLabel.hidden = NO;
                    self.thirdLabel.text = [NSString stringWithFormat:@" %@ ", tagArray[i]];
                }
                else if (i == 3)
                {
                    self.fourLabel.hidden = NO;
                    self.fourLabel.text = [NSString stringWithFormat:@" %@ ", tagArray[i]];
                }
            }
        }
    }
    else
    {
        self.showContent.hidden = NO;
        self.showContent.text = aweme.introduction;
        self.firstLabel.hidden = YES;
        self.secondLabel.hidden = YES;
        self.thirdLabel.hidden = YES;
        self.fourLabel.hidden = YES;
    }

}



@end
