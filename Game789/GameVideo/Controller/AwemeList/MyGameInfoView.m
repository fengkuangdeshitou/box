//
//  MyGameInfoView.m
//  Game789
//
//  Created by yangyongMac on 2020/2/21.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameInfoView.h"

@implementation MyGameInfoView

- (instancetype)init
{
    if ([super init])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyGameInfoView" owner:self options:nil].firstObject;
        self.frame = CGRectMake(0, 0, kScreenW, 60);
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gameDetailInfoAction)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.downLoadBtn])
    {
        return NO;
    }
    return YES;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSDictionary * dic = dataDic;
    
    NSString *url = [[dic objectForKey:@"game_image"] objectForKey:@"thumb"];
    [self.imageViews yy_setImageWithURL:[NSURL URLWithString:url] placeholder:MYGetImage(@"game_icon")];
    
    NSString *class_type = dic[@"game_classify_type"];
    self.titleLabel.text = dic[@"game_name"];
    
    if ([YYToolModel isBlankString:dic[@"label"]])
    {
        self.showLabelBgView.hidden = YES;
    }
    else
    {
        self.showLabelBgView.hidden = NO;
        self.showLableText.text = dic[@"label"];
    }
    
    //返回福利标签或是一句话  如果有详情介绍，显示，没有显示送VIP送福利
    if ([YYToolModel isBlankString:dic[@"introduction"]])
    {
        self.introduction.hidden = YES;
        self.firstTagLabel.hidden = YES;
        self.secondTagLabel.hidden = YES;
        self.thirdTagLabel.hidden = YES;
        self.fourTagLabel.hidden = YES;
        NSString *desc = dic[@"game_desc"];
        if ([YYToolModel isBlankString:desc])
        {
            //当没有描述和两个label
//            self.titleLabel_top.constant = 11;
        }
        else
        {
            NSArray *tagArray = [desc componentsSeparatedByString:@"+"];
            for (int i = 0; i < tagArray.count; i ++)
            {
                if (i == 0)
                {
                    self.firstTagLabel.hidden = NO;
                    self.firstTagLabel.text  = [NSString stringWithFormat:@"%@", tagArray[i]];
                }
                else if (i == 1)
                {
                    self.secondTagLabel.hidden = NO;
                    self.secondTagLabel.text = [NSString stringWithFormat:@"%@", tagArray[i]];
                }
                else if (i == 2)
                {
                    self.thirdTagLabel.hidden = NO;
                    self.thirdTagLabel.text = [NSString stringWithFormat:@"%@", tagArray[i]];
                }
                else if (i == 3)
                {
                    self.fourTagLabel.hidden = NO;
                    self.fourTagLabel.text = [NSString stringWithFormat:@"%@", tagArray[i]];
                }
            }
        }
    }
    else
    {
        self.introduction.hidden = NO;
        _introduction.text = dic[@"introduction"];
        self.firstTagLabel.hidden = YES;
        self.secondTagLabel.hidden = YES;
        self.thirdTagLabel.hidden = YES;
        self.fourTagLabel.hidden = YES;
    }
    
    /*******  判断是模块（数据需求与其他列表不同）*******/
    NSString * detailStr = @"";
    //BT游戏
    if([dic[@"game_species_type"] isEqualToString:@"3"])//H5
    {
        detailStr = [NSString stringWithFormat:@"%@", class_type];
    }
    else
    {
        detailStr = [NSString stringWithFormat:@"%@｜%@%@", class_type, dic[@"howManyPlay"], @"人在玩".localized];
    }
    self.detailLabel.text = detailStr;
    
    //根据下载状态显示
    if ([dic[@"game_species_type"] integerValue] == 3)//H5游戏
    {
        [self.buttonGradient setTitle:@"开始".localized forState:0];
    }
    else if ([dic[@"game_species_type"] integerValue] == 4 && dic[@"isGMAssisant"])//GM游戏
    {
        self.buttonGradient.backgroundColor = [UIColor colorWithHexString:@"#00D280"];
        [self.buttonGradient setTitle:@"进入权限".localized forState:0];
        self.buttonGradient.layer.borderColor = [UIColor colorWithHexString:@"#00D280"].CGColor;
        [self.buttonGradient setTitleColor:[UIColor whiteColor] forState:0];
    }
    else
    {
//        [self.buttonGradient setTitle:@"下载".localized forState:0];
        [self.buttonGradient setTitle:[NSString stringWithFormat:@"%@", dic[@"gama_size"][@"ios_size"]] forState:0];
    }
    
    [self.buttonGradient layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:8];
}

- (void)gameDetailInfoAction
{
    if (self.ViewGameInfoClick)
    {
        self.ViewGameInfoClick(NO);
    }
}

- (IBAction)downLoadBtnClick:(id)sender
{
    if (self.ViewGameInfoClick)
    {
        self.ViewGameInfoClick(YES);
    }
}

@end
