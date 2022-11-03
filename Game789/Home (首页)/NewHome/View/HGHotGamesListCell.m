//
//  HGRecommendGamesCell.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/5/18.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGHotGamesListCell.h"

#import "HomeTypeApi.h"
@class StageABTestApi;

@implementation HGHotGamesListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view1GameDetailClick:)];
    [self.backView1 addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view2GameDetailClick:)];
    [self.backView2 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(view3GameDetailClick:)];
    [self.backView3 addGestureRecognizer:tap2];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"HGHotGamesListCell" owner:self options:nil].firstObject;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    for (int i = 0; i < dataArray.count; i ++)
    {
        NSDictionary * dic = dataArray[i];
        YYAnimatedImageView * imageView = [self.contentView viewWithTag:10 + i];
        if ([dic[@"game_image"] isKindOfClass:[NSDictionary class]])
        {
            [imageView yy_setImageWithURL:[NSURL URLWithString:dic[@"game_image"][@"thumb"]] placeholder:MYGetImage(@"game_icon")];
        }
        
        UILabel * gameName = [self.contentView viewWithTag:i + 20];
        gameName.text = dic[@"game_name"];
        
        UILabel * gameType = [self.contentView viewWithTag:i + 30];
        if ([dic[@"gama_size"] isKindOfClass:[NSDictionary class]])
        {
            if ([dic[@"game_species_type"] integerValue] == 3)
            {
                gameType.text = [NSString stringWithFormat:@"%@", dic[@"game_classify_type"]];
            }
            else
            {
                gameType.text = [NSString stringWithFormat:@"%@·%@", dic[@"game_classify_type"], dic[@"gama_size"][@"ios_size"]];
            }
        }
        else
        {
            gameType.text = dic[@"game_classify_type"];
        }
        UIImageView * discountBgm = [self.contentView viewWithTag:i + 110];
        UILabel * showDiscount    = [self.contentView viewWithTag:i + 100];
        
        if ([dic[@"discount"] floatValue] < 1 && [dic[@"discount"] floatValue] > 0)
        {
            discountBgm.hidden  = NO;
            showDiscount.hidden = NO;
            showDiscount.text = [NSString stringWithFormat:@"%.1f折", [dic[@"discount"] floatValue] * 10];
        }
        else
        {
            discountBgm.hidden  = YES;
            showDiscount.hidden = YES;
        }
        
        
        UILabel * showDesc = [self.contentView viewWithTag:i + 40];
        UILabel * firstLabel = [self.contentView viewWithTag:i + 60];
        UILabel * secondLabel = [self.contentView viewWithTag:i + 70];
        UILabel * thirdLabel = [self.contentView viewWithTag:i + 80];
        UILabel * fourLabel = [self.contentView viewWithTag:i + 90];
        //返回福利标签或是一句话  如果有详情介绍，显示，没有显示送VIP送福利
        NSString *desc = dic[@"introduction"];
        if ([YYToolModel isBlankString:desc])
        {
            showDesc.hidden = YES;
            firstLabel.hidden = YES;
            secondLabel.hidden = YES;
            thirdLabel.hidden = YES;
            fourLabel.hidden = YES;
            
            NSArray *tagArray = [dic[@"game_desc"] componentsSeparatedByString:@"+"];
            for (int i = 0; i < tagArray.count; i ++)
            {
                if (i == 0)
                {
                    firstLabel.hidden = NO;
                    firstLabel.text  = [NSString stringWithFormat:@"%@", tagArray[i]];
                }
                else if (i == 1)
                {
                    secondLabel.hidden = NO;
                    secondLabel.text = [NSString stringWithFormat:@"%@", tagArray[i]];
                }
                else if (i == 2)
                {
                    thirdLabel.hidden = NO;
                    thirdLabel.text = [NSString stringWithFormat:@"%@", tagArray[i]];
                }
                else if (i == 3)
                {
                    fourLabel.hidden = NO;
                    fourLabel.text = [NSString stringWithFormat:@"%@", tagArray[i]];
                }
            }
        }
        else
        {
            showDesc.hidden = NO;
            showDesc.text = desc;
            firstLabel.hidden = YES;
            secondLabel.hidden = YES;
            thirdLabel.hidden = YES;
            fourLabel.hidden = YES;
        }
        
        UIButton * downloadBtn = [self.contentView viewWithTag:i + 50];
        if ([dic[@"game_species_type"] integerValue] == 3)
        {
            [downloadBtn setTitle:@"开始" forState:0];
        }
        else
        {
            [downloadBtn setTitle:@"下载" forState:0];
        }
    }
}

- (void)view1GameDetailClick:(UITapGestureRecognizer *)gesture
{
    if (self.dataArray.count > 0)
    {
        [self pushToGameDetail:self.dataArray[0]];
    }
}

- (void)view2GameDetailClick:(UITapGestureRecognizer *)gesture
{
    if (self.dataArray.count > 1)
    {
        [self pushToGameDetail:self.dataArray[1]];
    }
}

- (void)view3GameDetailClick:(UITapGestureRecognizer *)gesture
{
    if (self.dataArray.count > 2)
    {
        [self pushToGameDetail:self.dataArray[2]];
    }
}

- (IBAction)downloadBtnClick:(id)sender
{
    UIButton * button = sender;
    
    [self pushToGameDetail:self.dataArray[button.tag - 50][@"game_id"]];
}

- (void)pushToGameDetail:(NSDictionary *)dic
{
    NSDictionary * dic2 = @{@"title":self.showTitle};
    NSDictionary * dic1 = @{@"title":self.showTitle, @"ab_test1":[NSString stringWithFormat:@"%ld", (long)self.ab_test_index_swiper]};
    //专题游戏的点击统计
    [MyAOPManager gameRelateStatistic:@"ClickTheGameInTheTopic" GameInfo:dic Add:self.is_985 ? dic1 : dic2];
    
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.gameID = dic[@"game_id"];
    info.hidesBottomBarWhenPushed = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:info animated:YES];
//    if (self.is_985)
//    {
//        [self stageABTest];
//    }
}

- (void)stageABTest
{
    StageABTestApi * api = [[StageABTestApi alloc] init];
    api.name = @"ab_test_index_swiper";
    api.value = [NSString stringWithFormat:@"%ld", (long)self.ab_test_index_swiper];
    api.ab_test_stage = @"1";
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

@end
