//
//  MyChatTableViewCell.m
//  Game789
//
//  Created by Maiyou001 on 2022/8/26.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyChatTableViewCell.h"

@implementation MyChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChatModel:(MyChatMessageModel *)chatModel
{
    _chatModel = chatModel;
    
    self.usernameLeft.text  = chatModel.agentName;
    self.usernameRight.text = chatModel.playName;
    
    [self.userIconLeft sd_setImageWithURL:[NSURL URLWithString:chatModel.agentAvatar] placeholderImage:MYGetImage(@"game_icon")];
    [self.userIconRight sd_setImageWithURL:[NSURL URLWithString:chatModel.userAvatar] placeholderImage:MYGetImage(@"game_icon")];
    
    self.gameName.text = chatModel.gameInfo[@"gameName"];
    [self.gameIcon sd_setImageWithURL:[NSURL URLWithString:chatModel.gameInfo[@"gameLogo"]] placeholderImage:MYGetImage(@"game_icon")];
    self.gameDesc.text = [NSString stringWithFormat:@"%@ | %@人在玩 | %@", chatModel.gameInfo[@"tags"], chatModel.gameInfo[@"howManyPla"], chatModel.gameInfo[@"gameSize"][@"iosSize"]];
    self.msgContent.text = chatModel.content;
    
    
    if(chatModel.type.integerValue == 1)
    {
        //显示左边
        self.userIconRight.hidden = YES;
        self.usernameRight.hidden = YES;
        self.userIconLeft.hidden = NO;
        self.usernameLeft.hidden = NO;
        
        self.backView.backgroundColor = UIColor.whiteColor;
        self.msgContent.textColor = [UIColor colorWithHexString:@"##666666"];
    }
    else
    {
        //显示右边
        self.userIconRight.hidden = NO;
        self.usernameRight.hidden = NO;
        self.userIconLeft.hidden = YES;
        self.usernameLeft.hidden = YES;
        
        self.backView.backgroundColor = MAIN_COLOR;
        self.msgContent.textColor = [UIColor colorWithHexString:@"#282828"];
    }
    
    if ([chatModel.messageType isEqualToString:@"game"])
    {
        //显示游戏
        self.gameView_height.constant = 70;
        self.gameView.hidden = NO;
        self.downloadBtn.hidden = NO;
        self.downloadBtn_height.constant = 12;
        self.downloadBtn_top.constant = 10;
        
        self.backView_left.constant = 69;
        self.backView_right.constant = 51;
    }
    else
    {
        //显示纯文字
        self.gameView_height.constant = 0;
        self.gameView.hidden = YES;
        self.downloadBtn.hidden = YES;
        self.downloadBtn_height.constant = 0;
        self.downloadBtn_top.constant = 0;
        
        if(chatModel.type.integerValue == 1)
        {
            CGSize size = [chatModel.content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            self.backView_left.constant = 69;
            if (size.width < kScreenW-51-69-25) {
                self.backView_right.constant = kScreenW-69-size.width-26;
            }else{
                self.backView_right.constant = 51;
            }
        }
        else
        {
            CGSize size = [chatModel.content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            self.backView_right.constant = 69;
            if (size.width < kScreenW-51-69-25) {
                self.backView_left.constant = kScreenW-69-size.width-26;
            }else{
                self.backView_left.constant = 51;
            }
        }
    }
}

- (IBAction)viewGameDetailClick:(id)sender
{
    GameDetailInfoController * detail = [GameDetailInfoController new];
    detail.gameID = self.chatModel.gameInfo[@"gameId"];
    [[YYToolModel getCurrentVC].navigationController pushViewController:detail animated:YES];
}

@end
