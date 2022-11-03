//
//  HomeSectionTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2018/4/27.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "HomeSectionTableViewCell.h"

@interface HomeSectionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *gameStoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *gameStoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *coverBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@end

@implementation HomeSectionTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self.moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 2)];
    [self.moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 0, -32)];
    

}
//游戏大厅
- (IBAction)gameStorePress:(id)sender {
    [self.delegate gameStoreOpen:1];//游戏类型
}
//更多
- (IBAction)gameNowStorePress:(id)sender {
    [self.delegate gameStoreOpen:2]; //新游戏
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)resetTitleLabel:(NSString *)title {
    self.titleLabel.text = title;
    if ([title isEqualToString:@"精品推荐".localized]) {
        self.gameStoreBtn.hidden = NO;
        self.gameStoreLabel.hidden = NO;
        self.coverBtn.hidden = NO;

        //设置节日版背景显示
//        if ([DeviceInfo shareInstance].is_new_ui == 1) {
//            self.backImage.image = MYGetImage(@"section_bg_icon");
//        }
    }
    else {
        self.gameStoreBtn.hidden = YES;
        self.gameStoreLabel.hidden = YES;
        self.coverBtn.hidden = YES;
    }

    if ([title isEqualToString:@"最新上架".localized]) {
        self.moreBtn.hidden = NO;
    }
    else {
        self.moreBtn.hidden = YES;
    }
    if ([title isEqualToString:@"最近玩过".localized]) {
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#FF802F"];
    }
}
@end
