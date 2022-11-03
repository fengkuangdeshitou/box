//
//  SignCollectionViewCell.m
//  Game789
//
//  Created by maiyou on 2022/7/15.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "SignCollectionViewCell.h"

@interface SignCollectionViewCell ()

@property(nonatomic,weak)IBOutlet UILabel * signDate;
@property(nonatomic,weak)IBOutlet UILabel * text;

@end

@implementation SignCollectionViewCell

- (void)setModel:(NSDictionary *)model{
    _model = model;
    self.signDate.text = model[@"signDate"];
    self.text.text = model[@"text"];
    if ([model[@"isToday"] boolValue] == true) {
        self.text.backgroundColor = MAIN_COLOR;
        self.text.textColor = UIColor.whiteColor;
    }else{
        self.text.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        self.text.textColor = [UIColor colorWithHexString:@"#999999"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
