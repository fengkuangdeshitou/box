//
//  HomeCycleCell.m
//  Game789
//
//  Created by maiyou on 2021/5/7.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "HomeCycleCell.h"

@interface HomeCycleCell ()

@property(nonatomic,weak)IBOutlet YYAnimatedImageView * avater;
@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * descLabel;
@property(nonatomic,weak)IBOutlet UILabel * tagA;
@property(nonatomic,weak)IBOutlet UILabel * tagB;
@property(nonatomic,weak)IBOutlet UILabel * tagC;
@property(nonatomic,weak)IBOutlet UIView * gradientLayerView;
@property(nonatomic,strong) CAGradientLayer * gradientLayer;

@end

@implementation HomeCycleCell

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
    }
    return _gradientLayer;
}

- (void)setData:(NSDictionary *)data{
    _data = data;

    [self.avater yy_setImageWithURL:[NSURL URLWithString:data[@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
    self.titleLabel.text = data[@"game_name"];
    
    NSString *class_type = data[@"game_classify_type"];
    if ([class_type hasPrefix:@" "]){
        class_type = [class_type substringFromIndex:1];
    }
    //显示游戏的属性，类型·大小
//    NSString * gameSize = [YYToolModel isBlankString:data[@"game_size"][@"ios_size"]] ? data[@"gama_size"][@"ios_size"] : data[@"game_size"][@"ios_size"];
    if ([data[@"game_species_type"] integerValue] == 3){
       self.descLabel.text = [NSString stringWithFormat:@"%@", class_type];
    }else{
        self.descLabel.text = [NSString stringWithFormat:@"%@｜%@人在玩",class_type,data[@"howManyPlay"]];
    }

    NSArray * tags = [data[@"game_desc"] componentsSeparatedByString:@"+"];

    if(tags.count == 1){
        self.tagA.hidden = NO;
        self.tagB.hidden = YES;
        self.tagC.hidden = YES;
        self.tagA.text = tags.firstObject;
    }else if(tags.count == 2){
        self.tagA.hidden = NO;
        self.tagB.hidden = NO;
        self.tagC.hidden = YES;
        self.tagA.text = tags.firstObject;
        self.tagB.text = tags.lastObject;
    }else if(tags.count == 3){
        self.tagA.hidden = NO;
        self.tagB.hidden = NO;
        self.tagC.hidden = NO;
        self.tagA.text = tags.firstObject;
        self.tagB.text = tags[1];
        self.tagC.text = tags.lastObject;
    }else{
        self.tagA.hidden = YES;
        self.tagB.hidden = YES;
        self.tagC.hidden = YES;
    }
}

- (void)setShowGradientLayer:(BOOL)showGradientLayer{
    if (showGradientLayer) {
        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.0].CGColor];
    }else{
        self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.gradientLayer.frame = CGRectMake(0,0,self.width,71.5);
    self.gradientLayer.startPoint = CGPointMake(0, 1);
    self.gradientLayer.endPoint = CGPointMake(0, 0);
    [self.gradientLayerView.layer addSublayer:self.gradientLayer];
    
}

@end
