//
//  HGVideoCell.m
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGVideoCell.h"

@implementation HGVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.videoView = [SJPlayView new];
    self.videoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.videoView.layer.cornerRadius = 8;
    self.videoView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.videoView];
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVideo:(NSDictionary *)video{
    _video = video;
    
    if ([video isKindOfClass:[NSDictionary class]]) {
        
        [self.videoView.coverImageView yy_setImageWithURL:[NSURL URLWithString:video[@"videoImg"]] placeholder:MYGetImage(@"placehold_bg_image4")];
        
        CGFloat videoWidth = [video[@"width"] floatValue];
        CGFloat videoHeight = [video[@"height"] floatValue];
        
        NSArray * array = [MASViewConstraint installedConstraintsForView:self.videoView];
        for (MASConstraint * constraint in array) {
            [constraint uninstall];
        }
        
        [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(12);
            make.left.mas_equalTo(15);
            if (videoWidth < videoHeight) {
                make.height.mas_equalTo(194);
                make.width.mas_equalTo(194*videoWidth/videoHeight);
            }else{
                if (videoWidth > (ScreenWidth - 30)) {
                    make.right.mas_equalTo(-15);
                    make.height.mas_equalTo((ScreenWidth-30)*videoHeight/videoWidth);
                }else{
                    make.height.mas_equalTo(194);
                    make.width.mas_equalTo(194*videoWidth/videoHeight);
                }
            }
        }];
    }
    
    
}

@end
