//
//  MyGameActivityFooterView.m
//  Game789
//
//  Created by Maiyou on 2020/9/12.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyGameActivityFooterView.h"
#import "GameDownLoadApi.h"

@implementation MyGameActivityFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyGameActivityFooterView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewGameDetail)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    NSString *url = [[dataDic objectForKey:@"game_image"] objectForKey:@"thumb"];
    [self.gameIcon yy_setImageWithURL:[NSURL URLWithString:url] placeholder:MYGetImage(@"game_icon")];
    
    self.gameName.text = dataDic[@"game_name"];
    
    //游戏类型,下载量,大小
    NSString * name = @"";
    NSArray * nameArray = dataDic[@"game_classify_name"];
    for (int i = 0; i < nameArray.count; i ++)
    {
        ([name isEqualToString:@""]) ?
        (name = nameArray[i][@"tagname"]) :
        (name = [NSString stringWithFormat:@"%@ %@", name, nameArray[i][@"tagname"]]);
    }
    if ([dataDic[@"game_species_type"] integerValue] != 3)
    {
        name = [name stringByAppendingString:[NSString stringWithFormat:@"· %@%@", dataDic[@"game_download_num"], @"次下载".localized]];
    }
    self.gameType.text = name;
    
    //BT游戏
    if ([dataDic[@"game_species_type"] isEqualToString:@"1"] || [dataDic[@"game_species_type"] isEqualToString:@"4"])
    {
        
        [self.downloadBtn setTitle:@"下载".localized forState:0];
    }
    else if ([dataDic[@"game_species_type"] isEqualToString:@"2"])//折扣
    {
        [self.downloadBtn setTitle:@"下载".localized forState:0];
    }
    else if([dataDic[@"game_species_type"] isEqualToString:@"3"])//H5
    {
        [self.downloadBtn setTitle:@"开始".localized forState:0];
    }
}

- (void)viewGameDetail
{
    GameDetailInfoController * info = [GameDetailInfoController new];
    info.gameID = self.dataDic[@"game_id"];
    info.hidesBottomBarWhenPushed = YES;
    [[YYToolModel getCurrentVC].navigationController pushViewController:info animated:YES];
}

- (IBAction)downloadBtnClick:(id)sender
{
    if ([self.dataDic[@"game_species_type"] integerValue] == 3)
    {
        //没有登陆
        if (![YYToolModel isAlreadyLogin])
        {
            return;
        }
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_name"];
        LoadGameViewController * game = [[LoadGameViewController alloc] init];
        game.load_url = [NSString stringWithFormat:@"%@&username=%@", self.dataDic[@"gama_url"][@"ios_url"], userName];
        game.hidesBottomBarWhenPushed = YES;
        game.hiddenNavBar = YES;
        [[YYToolModel getCurrentVC].navigationController pushViewController:game animated:YES];
    }
    else
    {
        [self getMessageApiRequest];
    }
}

#pragma mark - 获取安装plist
- (void)getMessageApiRequest
{
    GameDownLoadApi *api = [[GameDownLoadApi alloc] init];
    api.isShow = YES;
    api.urls = self.dataDic[@"game_url"][@"ios_url"];
    api.requestTimeOutInterval = 60;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        [self handle1NoticeSuccess:api];
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)handle1NoticeSuccess:(GameDownLoadApi *)api
{
    if (api.success == 1)
    {
        NSString * url = api.data[@"url"];
        if ([url containsString:@"url="])
        {
            [YYToolModel loadIpaUrl:[YYToolModel getCurrentVC] Url:url];
        }
        else
        {
            [YYToolModel loadIpaUrl:[YYToolModel getCurrentVC] Url:url];
        }
    }
        
}

@end
