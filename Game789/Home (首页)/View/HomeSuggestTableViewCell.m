//
//  HomeSuggestTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2018/3/13.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "HomeSuggestTableViewCell.h"

@interface HomeSuggestTableViewCell ()

@property (nonatomic, strong) UIScrollView *containSV;
@property (nonatomic, strong) NSArray *dataArray;

@end


@implementation HomeSuggestTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initUI
{
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, 126)];
    sv.showsHorizontalScrollIndicator = NO;
    [self addSubview:sv];
    self.containSV = sv;
}

- (void)setContentArray:(NSArray *)array {
    if (array) {
        self.dataArray = array;
    }
    else {
        self.dataArray = [NSArray array];
    }
    [self resetViews];
}

- (void)resetViews
{
    for (UIView *view in self.containSV.subviews)
    {
        [view removeFromSuperview];
    }
    
    CGFloat width = 0.0;
    CGFloat needWidth = (kScreen_width-20)/4.5;
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *dic = [self.dataArray objectAtIndex:i];
        UIView *contantsView = [[UIView alloc] initWithFrame:CGRectMake(15+i*needWidth, 10, needWidth, 110)];
        [self.containSV addSubview:contantsView];

        NSString * url = @"";
        if (self.type == 3)
        {
            url = dic[@"game_image"][@"thumb"];
        }
        else
        {
            url = dic[@"game_icon"];
        }
        contantsView.tag = 5000+i;
        UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake((needWidth-60)/2, 0, 60, 60)];
        [iconImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"game_icon"]];
        iconImg.clipsToBounds = YES;
        [contantsView addSubview:iconImg];
        
        CGFloat discount = [dic[@"discount"] floatValue];
        NSString * string = [NSString stringWithFormat:@"%.1f折", discount * 10];
        if (discount > 0 && discount < 1)
        {
            UILabel * showDiscount = [[UILabel alloc] initWithFrame:CGRectMake(15, iconImg.center.y - 25, iconImg.width, 20)];
            showDiscount.textAlignment = NSTextAlignmentCenter;
            showDiscount.backgroundColor = [UIColor redColor];
            showDiscount.text = string;
            showDiscount.textColor = [UIColor whiteColor];
            showDiscount.font = [UIFont boldSystemFontOfSize:11];
            showDiscount.transform = CGAffineTransformMakeRotation(M_PI/4);
            [iconImg addSubview:showDiscount];
        }

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImg.frame), needWidth, 30)];
        title.font = [UIFont systemFontOfSize:13];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"game_name"]];
        [contantsView addSubview:title];
        
        if (self.type == 1)
        {
            UILabel *gameType = [[UILabel alloc] initWithFrame:CGRectMake(iconImg.x, CGRectGetMaxY(title.frame), iconImg.width, 20)];
            gameType.layer.masksToBounds = YES;
            gameType.layer.cornerRadius = gameType.height / 2;
            gameType.layer.borderColor = [UIColor colorWithHexString:@"#FF802F"].CGColor;
            gameType.layer.borderWidth = 0.5f;
            gameType.textColor = [UIColor colorWithHexString:@"#FF802F"];
            gameType.font = [UIFont systemFontOfSize:11];
            gameType.textAlignment = NSTextAlignmentCenter;
            gameType.text = [NSString stringWithFormat:@"%@", ([[dic objectForKey:@"label"] isKindOfClass:[NSNull class]] || [[dic objectForKey:@"label"] isEqualToString:@""]) ? @"精品推荐".localized : [dic objectForKey:@"label"]];
            [contantsView addSubview:gameType];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPress:)];
        [contantsView addGestureRecognizer:tap];
        width = CGRectGetMaxX(contantsView.frame);
    }

    self.containSV.contentSize = CGSizeMake(width, self.containSV.frame.size.height);
}

- (void)viewPress:(UITapGestureRecognizer *)tap {
    NSInteger index = tap.view.tag - 5000;
    if ([self.delegate respondsToSelector:@selector(selectedPress:)]) {
        [self.delegate selectedPress:index];
    }
}
@end
