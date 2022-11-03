//
//  GameRankingTableViewCell.m
//  Game789
//
//  Created by Maiyou on 2018/7/20.
//  Copyright © 2018年 xinpenghui. All rights reserved.
//

#import "GameRankingTableViewCell.h"
#import "YYToolModel.h"

@interface GameRankingTableViewCell()
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *champion;
@property (weak, nonatomic) IBOutlet UILabel *championLab;
@property (weak, nonatomic) IBOutlet UILabel *championType;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *runner;
@property (weak, nonatomic) IBOutlet UILabel *runnerLab;
@property (weak, nonatomic) IBOutlet UILabel *runnerType;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *bronze;
@property (weak, nonatomic) IBOutlet UILabel *bronzeLab;
@property (weak, nonatomic) IBOutlet UILabel *bronzeType;
@property (weak, nonatomic) IBOutlet UIButton *championBtn;
@property (weak, nonatomic) IBOutlet UIButton *runnerBtn;
@property (weak, nonatomic) IBOutlet UIButton *bronzeBtn;
//详情
- (IBAction)chanpionDetails:(id)sender;
- (IBAction)runnerDetails:(id)sender;
- (IBAction)bronzeDetails:(id)sender;

//下载
@end

@implementation GameRankingTableViewCell

-(void)setModelDic:(NSDictionary *)dic
{
    if ([dic[@"rankType"] isEqualToString:@"1"]) {
        //BT
        if(![dic[@"rankDate1"] isKindOfClass:[NSArray class]] || ((NSArray *)dic[@"rankDate1"]).count < 1){
            return;
        }
        [self.champion yy_setImageWithURL:[NSURL URLWithString:dic[@"rankDate1"][0][@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
         self.championLab.text = dic[@"rankDate1"][0][@"game_name"];
        self.championType.text = dic[@"rankDate1"][0][@"game_classify_type"];

        if(((NSArray *)dic[@"rankDate1"]).count < 2){
            return;
        }
        [self.runner yy_setImageWithURL:[NSURL URLWithString:dic[@"rankDate1"][1][@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
        self.runnerLab.text = dic[@"rankDate1"][1][@"game_name"];
        self.runnerType.text = dic[@"rankDate1"][1][@"game_classify_type"];
        
        if(((NSArray *)dic[@"rankDate1"]).count < 3){
            return;
        }
        [self.bronze yy_setImageWithURL:[NSURL URLWithString:dic[@"rankDate1"][2][@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
        self.bronzeLab.text = dic[@"rankDate1"][2][@"game_name"];
        self.bronzeType.text = dic[@"rankDate1"][2][@"game_classify_type"];
        
        [self.championBtn setTitle:@"下载".localized forState:0];
        [self.runnerBtn setTitle:@"下载".localized forState:0];
        [self.bronzeBtn setTitle:@"下载".localized forState:0];
        
    }else if ([dic[@"rankType"] isEqualToString:@"2"]){
        //折扣
        //判断 防止数组越界 edit guo
        if(![dic[@"rankDate2"] isKindOfClass:[NSArray class]] || ((NSArray *)dic[@"rankDate2"]).count < 1){
            return;
        }
        [self.champion sd_setImageWithURL:[NSURL URLWithString:dic[@"rankDate2"][0][@"game_image"][@"thumb"]]];
        self.championLab.text = dic[@"rankDate2"][0][@"game_name"];
        self.championType.text = dic[@"rankDate2"][0][@"game_classify_type"];
        if(((NSArray *)dic[@"rankDate2"]).count < 2){
            return;
        }
        [self.runner sd_setImageWithURL:[NSURL URLWithString:dic[@"rankDate2"][1][@"game_image"][@"thumb"]]];
        self.runnerLab.text = dic[@"rankDate2"][1][@"game_name"];
        self.runnerType.text = dic[@"rankDate2"][1][@"game_classify_type"];
        if(((NSArray *)dic[@"rankDate2"]).count < 3){
            return;
        }
        [self.bronze sd_setImageWithURL:[NSURL URLWithString:dic[@"rankDate2"][2][@"game_image"][@"thumb"]]];
        self.bronzeLab.text = dic[@"rankDate2"][2][@"game_name"];
        self.bronzeType.text = dic[@"rankDate2"][2][@"game_classify_type"];
        
        [self.championBtn setTitle:@"下载".localized forState:0];
        [self.runnerBtn setTitle:@"下载".localized forState:0];
        [self.bronzeBtn setTitle:@"下载".localized forState:0];
        
    }else if ([dic[@"rankType"] isEqualToString:@"3"]){
        //H5
        if(![dic[@"rankDate3"] isKindOfClass:[NSArray class]] || ((NSArray *)dic[@"rankDate3"]).count < 1){
            return;
        }
        [self.champion sd_setImageWithURL:[NSURL URLWithString:dic[@"rankDate3"][0][@"game_image"][@"thumb"]]];
        self.championLab.text = dic[@"rankDate3"][0][@"game_name"];
        self.championType.text = dic[@"rankDate3"][0][@"game_classify_type"];
        if(((NSArray *)dic[@"rankDate3"]).count < 2){
            return;
        }
        [self.runner sd_setImageWithURL:[NSURL URLWithString:dic[@"rankDate3"][1][@"game_image"][@"thumb"]]];
        self.runnerLab.text = dic[@"rankDate3"][1][@"game_name"];
        self.runnerType.text = dic[@"rankDate3"][1][@"game_classify_type"];
        if(((NSArray *)dic[@"rankDate3"]).count < 3){
            return;
        }
        [self.bronze sd_setImageWithURL:[NSURL URLWithString:dic[@"rankDate3"][2][@"game_image"][@"thumb"]]];
        self.bronzeLab.text = dic[@"rankDate3"][2][@"game_name"];
        self.bronzeType.text = dic[@"rankDate3"][2][@"game_classify_type"];
        
        [self.championBtn setTitle:@"开始".localized forState:0];
        [self.runnerBtn setTitle:@"开始".localized forState:0];
        [self.bronzeBtn setTitle:@"开始".localized forState:0];
    }else if ([dic[@"rankType"] isEqualToString:@"4"]){
        //折扣
        //判断 防止数组越界 edit guo
        if(![dic[@"rankDate4"] isKindOfClass:[NSArray class]] || ((NSArray *)dic[@"rankDate4"]).count < 1){
            return;
        }
        [self.champion sd_setImageWithURL:[NSURL URLWithString:dic[@"rankDate4"][0][@"game_image"][@"thumb"]]];
        self.championLab.text = dic[@"rankDate4"][0][@"game_name"];
        self.championType.text = dic[@"rankDate4"][0][@"game_classify_type"];
        if(((NSArray *)dic[@"rankDate4"]).count < 2){
            return;
        }
        [self.runner sd_setImageWithURL:[NSURL URLWithString:dic[@"rankDate4"][1][@"game_image"][@"thumb"]]];
        self.runnerLab.text = dic[@"rankDate4"][1][@"game_name"];
        self.runnerType.text = dic[@"rankDate4"][1][@"game_classify_type"];
        if(((NSArray *)dic[@"rankDate4"]).count < 3){
            return;
        }
        [self.bronze sd_setImageWithURL:[NSURL URLWithString:dic[@"rankDate4"][2][@"game_image"][@"thumb"]]];
        self.bronzeLab.text = dic[@"rankDate4"][2][@"game_name"];
        self.bronzeType.text = dic[@"rankDate4"][2][@"game_classify_type"];
        
        [self.championBtn setTitle:@"下载".localized forState:0];
        [self.runnerBtn setTitle:@"下载".localized forState:0];
        [self.bronzeBtn setTitle:@"下载".localized forState:0];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //设置头像
    self.champion.layer.masksToBounds = YES;
    self.champion.layer.cornerRadius = self.champion.frame.size.width/2;
    self.runner.layer.masksToBounds = YES;
    self.runner.layer.cornerRadius = self.runner.frame.size.width/2;
    self.bronze.layer.masksToBounds = YES;
    self.bronze.layer.cornerRadius = self.bronze.frame.size.width/2;
    //设置下载按钮背景色
    
    //设置渐变色背景
    NSArray * array = @[(id)[UIColor colorWithHexString:@"#FF5A9B"].CGColor, (id)[UIColor colorWithHexString:@"#FECB5D"].CGColor];
    [YYToolModel setGradientColor:self.championBtn CornerRadius:11 ColorArray:array];
    [YYToolModel setGradientColor:self.runnerBtn CornerRadius:11 ColorArray:array];
    [YYToolModel setGradientColor:self.bronzeBtn CornerRadius:11 ColorArray:array];
}




- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chanpionDetails:)];
    [self.champion addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(runnerDetails:)];
    [self.runner addGestureRecognizer:tap1];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bronzeDetails:)];
    [self.bronze addGestureRecognizer:tap2];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//判断字符是否为空
- (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

- (IBAction)chanpionDetails:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rankTopClcik:)])
    {
        [self.delegate rankTopClcik:0];
    }
}
- (IBAction)runnerDetails:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rankTopClcik:)])
    {
        [self.delegate rankTopClcik:1];
    }
}

- (IBAction)bronzeDetails:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rankTopClcik:)])
    {
        [self.delegate rankTopClcik:2];
    }
}
@end
