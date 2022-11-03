//
//  HGContainerCell.m
//  HeiGuGame
//
//  Created by maiyou on 2020/10/23.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGPhotosCell.h"

@interface HGPhotosCell ()

@property(nonatomic,weak)IBOutlet UIView * photosView;

@end

@implementation HGPhotosCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setThumbArray:(NSArray *)thumbArray
{
    _thumbArray = thumbArray;
//    for (UIImageView * imageView in self.photosView.subviews) {
//        imageView.hidden = YES;
//    }
    self.imageArray = [NSMutableArray array];
    for (int i = 0; i < 9; i++)
    {
        UIImageView * imageView = [self.photosView viewWithTag:i+1000];
        if (i<thumbArray.count)
        {
            imageView.hidden = NO;
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:thumbArray[i] placeholderImage:MYGetImage(@"game_icon")];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhoto:)];
            [imageView addGestureRecognizer:tap];
            
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = thumbArray[i];
            data.projectiveView = imageView;
            data.allowSaveToPhotoAlbum = NO;
            [self.imageArray addObject:data];
            
        }
        else
        {
            imageView.hidden = YES;
        }
    }
}

- (void)showPhoto:(UITapGestureRecognizer *)tap
{
    UIImageView * view = (UIImageView *)tap.view;
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = self.imageArray;
    browser.currentPage = view.tag - 1000;
    [browser show];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
