//
//  MemberPriceCollectionView.m
//  Game789
//
//  Created by maiyou on 2021/4/29.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MemberPriceCollectionView.h"

@interface MemberPriceCollectionView ()

@property(nonatomic,weak)IBOutlet UILabel * monthLabel;
@property(nonatomic,weak)IBOutlet UILabel * priceLabel;
@property(nonatomic,weak)IBOutlet UILabel * typeLabel;
@property(nonatomic,weak)IBOutlet UILabel * descLabel;
@property(nonatomic,weak)IBOutlet UIView * containerView;
@property(nonatomic,weak)IBOutlet UIView * activeView;
@property(nonatomic,weak)IBOutlet UILabel * activeLabel;

@end

@implementation MemberPriceCollectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.borderColor = [UIColor colorWithHexString:@"#DEDEDE"].CGColor;
    self.containerView.layer.borderWidth = 1;
    
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    self.monthLabel.text = data[@"title"];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",data[@"price"]];
    self.typeLabel.text = data[@"grade_name"];
    self.descLabel.text = data[@"give"];
    self.activeView.hidden = [data[@"hot_title"] length] == 0;
    self.activeLabel.text = data[@"hot_title"];
}

@end
