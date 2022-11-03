//
//  YYPersonalCollectionViewCell.m
//  52Talk
//
//  Created by Maiyou on 2019/3/15.
//  Copyright © 2019 yangyong. All rights reserved.
//

#import "YYPersonalCollectionViewCell.h"

@implementation YYPersonalCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = BackColor;
    
}

//- (void)layoutSubviews
//{
    //        NSInteger count = self.indexPath.item / 4;
    //        NSInteger index = self.indexPath.item % 4;
    //
    //        if (index == 0 || index == 3)
    //        {
    //            UIRectCorner corners = UIRectCornerTopLeft;
    //            if (count == 0)
    //            {
    //                corners = index == 0 ? UIRectCornerTopLeft : UIRectCornerTopRight;
    //            }
    //            else
    //            {
    //                corners = index == 0 ? UIRectCornerBottomLeft : UIRectCornerBottomRight;
    //            }
    //
    //            MYLog(@"%ld----%ld----%ld", _indexPath.section, _indexPath.item, corners);
    //            [YYToolModel clipRectCorner:corners radius:13 view:self.contentView];
    //        }
    //        NSInteger count = self.indexPath.item / 5;
    //        NSInteger index = self.indexPath.item % 5;
    //
    //        if (index == 0 || index == 4)
    //        {
    //            UIRectCorner corners = UIRectCornerTopLeft;
    //            if (count == 0)
    //            {
    //                corners = index == 0 ? UIRectCornerTopLeft : UIRectCornerTopRight;
    //            }
    //            else
    //            {
    //                corners = index == 0 ? UIRectCornerBottomLeft : UIRectCornerBottomRight;
    //            }
    //
    //            MYLog(@"%ld----%ld----%ld", _indexPath.section, _indexPath.item, corners);
    //            [YYToolModel clipRectCorner:corners radius:13 view:self.contentView];
    //        }
//}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}

- (void)setIsHiddenImage:(BOOL)isHiddenImage
{
    _isHiddenImage = isHiddenImage;
    
    self.showCourseCount.hidden = isHiddenImage;
    self.backImage.hidden = isHiddenImage;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showTitle.text = dataDic[@"title"];
    UIImage * image = MYGetImage(dataDic[@"image"]);
    self.showImage.image = image;
    if ([dataDic[@"vc"] isEqualToString:@"video"])
    {
        if ([YYToolModel getUserdefultforKey:@"videoPlay"] == NULL)
        {
            self.badgeCount.text = @"";
            self.badgeCount.hidden = NO;
            self.badgeLabel_width.constant = 6;
            self.badgeLabel_height.constant = 6;
            self.badgeLabel_left.constant = -4;
            self.badgeCount.layer.cornerRadius = 3;
        }
        else
        {
            self.badgeCount.hidden = YES;
        }
    }
    if ([dataDic[@"vc"] isEqualToString:@"intro"])
    {
        if ([YYToolModel getUserdefultforKey:@"vipIntro"] == NULL)
        {
            self.badgeCount.text = @"";
            self.badgeCount.hidden = NO;
            self.badgeLabel_width.constant = 6;
            self.badgeLabel_height.constant = 6;
            self.badgeLabel_left.constant = -4;
            self.badgeCount.layer.cornerRadius = 3;
        }
        else
        {
            self.badgeCount.hidden = YES;
        }
    }
}

@end
