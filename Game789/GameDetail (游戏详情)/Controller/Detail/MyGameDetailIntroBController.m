//
//  MyGameDetailIntroBController.m
//  Game789
//
//  Created by Maiyou on 2021/3/18.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyGameDetailIntroBController.h"
#import "ShowVipTableController.h"
#import "MyDetailRelateGamesApi.h"
#import "HGGameScreenshotsCell.h"
#import "HGShowGameContentCell.h"
#import "HGShowWelfareCell.h"
#import "HGShowVipInfoCell.h"
#import <CoreText/CoreText.h>
#import "HGHomeRecommendGamesCell.h"
#import "MyGameFeedbackCell.h"

#import "MyGetVoucherListApi.h"
@class MyReceiveVouchersListApi;

@interface MyGameDetailIntroBController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isOpenWelfare;
@property (nonatomic, assign) BOOL isOpenRebate;
@property (nonatomic, assign) BOOL isOpenContent;

@property (nonatomic, strong) NSArray * relateArray;

@end

@implementation MyGameDetailIntroBController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic[@"game_info"];
    
    self.relateArray = dataDic[@"recommend_info"];
    [self getRelateGames:_dataDic[@"game_id"]];
    [self.tableView reloadData];
}

- (void)getRelateGames:(NSString *)gameid
{
    MyDetailRelateGamesApi * api = [[MyDetailRelateGamesApi alloc] init];
    api.game_id = gameid;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            self.relateArray = request.data[@"list"];
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
    }];
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.view.height - 64 - kTabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView * footerView = [self creatFooterView];
        footerView.backgroundColor = UIColor.whiteColor;
        _tableView.tableFooterView = footerView;
        _tableView.backgroundColor = UIColor.whiteColor;
        
        [_tableView registerClass:[HGGameScreenshotsCell class] forCellReuseIdentifier:@"HGGameScreenshotsCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HGShowGameContentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HGShowGameContentCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HGGameScreenshotsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HGGameScreenshotsCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HGShowWelfareCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HGShowWelfareCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HGShowVipInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HGShowVipInfoCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"HGHomeRecommendGamesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HGHomeRecommendGamesCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"MyGameFeedbackCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyGameFeedbackCell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark TableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        NSString * content = self.dataDic[@"game_feature_list"][indexPath.row][@"content"];
        if ([content isBlankString])
        {
            return 0.001;
        }
        CGFloat height = [self getTextHeightWithStr:content withWidth:kScreenW - 30 withLineSpacing:5 withFont:14];
        if (height <= 112)
        {
            return UITableViewAutomaticDimension;
        }
        return self.isOpenWelfare ? UITableViewAutomaticDimension : 168 + 20;
    }
    else if (indexPath.row == 1)
    {
        NSString * content = self.dataDic[@"game_feature_list"][indexPath.row][@"content"];
        if ([content isBlankString])
        {
            return 0.001;
        }
        CGFloat height = [self getTextHeightWithStr:content withWidth:kScreenW - 30 withLineSpacing:5 withFont:14];
        if (height <= 112)
        {
            return UITableViewAutomaticDimension;
        }
        return self.isOpenRebate ? UITableViewAutomaticDimension : 168 + 20;
    }
    else if (indexPath.row == 2)
    {
        return 215;
    }
    else if (indexPath.row == 3)
    {
        if ([self.dataDic[@"game_introduce"] isBlankString])
        {
            return 0.001;
        }
        CGFloat height = [self getTextHeightWithStr:self.dataDic[@"game_introduce"] withWidth:kScreenW - 30 withLineSpacing:5 withFont:14];
        if (height <= 82)
        {
            return UITableViewAutomaticDimension;
        }
        return self.isOpenContent ? UITableViewAutomaticDimension : 82 + 56 + 20;
    }
    else if (indexPath.row == 4)
    {
        CGFloat width = (kScreenW - 30 - 15 * 3) / 4;
        //48为图片底部两行文字高度，60.5为标题高度，15为图片bottom，20为行间距
        return (width + 48 + 20) * 2 + 60.5 + 15 + 20;
    }
    else if (indexPath.row == 5)
    {
        return 44;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *reuseID = @"HGShowWelfareCell";
        HGShowWelfareCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        NSString * content = self.dataDic[@"game_feature_list"][indexPath.row][@"content"];
        cell.showTitle.text = @"上线福利";
        cell.showContent.attributedText = [self setTextSpace:5 Text:content];
        cell.hidden = [content isBlankString];
        cell.isRebate = NO;
        cell.isBoth = [self.dataDic[@"is_both"] boolValue];
        cell.moreBtn.selected = self.isOpenWelfare;
        CGFloat height = [self getTextHeightWithStr:content withWidth:kScreenW - 30 withLineSpacing:5 withFont:14];
        if (height <= 112)
        {
            cell.moreBtn.hidden = YES;
        }
        cell.viewMoreContent = ^{
            self.isOpenWelfare = !self.isOpenWelfare;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
    }
    else if (indexPath.row == 1)
    {
        static NSString *reuseID = @"HGShowWelfareCell";
        HGShowWelfareCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        NSString * content = self.dataDic[@"game_feature_list"][indexPath.row][@"content"];
        cell.showTitle.text = @"返利";
        cell.showContent.attributedText = [self setTextSpace:5 Text:content];
        cell.hidden = [content isBlankString];
        cell.isRebate = YES;
        cell.moreBtn.selected = self.isOpenRebate;
        cell.isAutoRebate = [self.dataDic[@"allow_rebate"] boolValue];
        CGFloat height = [self getTextHeightWithStr:content withWidth:kScreenW - 30 withLineSpacing:5 withFont:14];
        if (height <= 112)
        {
            cell.moreBtn.hidden = YES;
        }
        cell.viewMoreContent = ^{
            self.isOpenRebate = !self.isOpenRebate;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
    }
    else if (indexPath.row == 2)
    {
        static NSString *reuseID = @"HGGameScreenshotsCell";
        HGGameScreenshotsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.dataArray = self.dataDic[@"game_ur_list"];
        return cell;
    }
    else if (indexPath.row == 3)
    {
        static NSString *reuseID = @"HGShowGameContentCell";
        HGShowGameContentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.showContent.attributedText = [self setTextSpace:5 Text:self.dataDic[@"game_introduce"]];
        NSString * content = self.dataDic[@"game_feature_list"][0][@"content"];
        if ([content isBlankString])
        {
            cell.isBoth = [self.dataDic[@"is_both"] boolValue];
        }else{
            cell.isBoth = false;
        }
        cell.moreBtn.selected = self.isOpenContent;
        CGFloat height = [self getTextHeightWithStr:self.dataDic[@"game_introduce"] withWidth:kScreenW - 30 withLineSpacing:5 withFont:14];
        if (height <= 82)
        {
            cell.moreBtn.hidden = YES;
        }
        cell.viewMoreContent = ^{
            self.isOpenContent = !self.isOpenContent;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        return cell;
    }
    else if (indexPath.row == 4)
    {
        static NSString *reuseID = @"HGHomeRecommendGamesCell";
        HGHomeRecommendGamesCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.currentVC = self;
        cell.game_id   = self.dataDic[@"game_id"];
        cell.dataArray = self.relateArray;
        return cell;
    }
    else if (indexPath.row == 5)
    {
        static NSString *reuseID = @"MyGameFeedbackCell";
        MyGameFeedbackCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        cell.currentVC = self;
        cell.gameId   = self.dataDic[@"game_id"];
        cell.gameName = self.dataDic[@"game_name"];
        return cell;
    }
    else
    {
        static NSString *reuseID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 1)
//    {
//        NSArray * array = [self.dataDic objectForKey:@"game_feature_list"];
//        NSDictionary * dic = [array objectAtIndex:2];
//        ShowVipTableController * vipTable = [ShowVipTableController new];
//        vipTable.showText = [dic objectForKey:@"content"];
//        vipTable.navBar.title = [dic objectForKey:@"title"];
//        [self.navigationController pushViewController:vipTable animated:YES];
//    }
}

- (NSMutableAttributedString *)setTextSpace:(CGFloat)lineSpace Text:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [str length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

-(CGFloat)getTextHeightWithStr:(NSString *)str
                     withWidth:(CGFloat)width
               withLineSpacing:(CGFloat)lineSpacing
                      withFont:(CGFloat)font
{
    if (!str || str.length == 0) {
        return 0;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing =  lineSpacing;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:font]}];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
    CGSize attSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL,CGSizeMake(width, CGFLOAT_MAX), NULL);
    CFRelease(frameSetter);
    
    return attSize.height;

}

@end
