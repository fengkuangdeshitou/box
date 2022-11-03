//
//  HGGameReceiveGiftView.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/6/3.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyActivityReceiveView.h"
#import "MyLimitedBuyingApi.h"
@class MyLimitedBuyReceivedApi;

@implementation MyActivityReceiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyActivityReceiveView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedRowHeight = 44;
        self.tableView.backgroundColor = ColorWhite;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    //代金券
    if ([dataDic[@"type"] integerValue] == 1)
    {
        self.showTitle.text = @"温馨提示";
        
        self.showTime.text = [NSString stringWithFormat:@"有效期至：%@", self.dataDic[@"use_end_time"]];
        
        [self.receiveBtn setTitle:@"确定兑换" forState:0];
    }
    else
    {
        self.showTitle.text = self.dataDic[@"title"];
        
        self.showTime.text = [NSString stringWithFormat:@"有效期至：%@", self.dataDic[@"use_end_time"]];
        
        [self.receiveBtn setTitle:@"确认兑换" forState:0];
    }
    
    [self.tableView reloadData];
}

#pragma mark TableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return self.dataDic[@"gift_code"] ? 44 : 0;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    cell.contentView.backgroundColor = ColorWhite;
    cell.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    cell.textLabel.textColor = FontColor28;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = FontColor66;
    cell.detailTextLabel.numberOfLines = 0;
    if (indexPath.row == 0)
    {
        if (self.dataDic[@"gift_code"])
        {
            cell.hidden = NO;
            NSString * str = [NSString stringWithFormat:@"礼包码：%@", self.dataDic[@"gift_code"]];
            NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:str];
            [attribute addAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]} range:[str rangeOfString:self.dataDic[@"gift_code"]]];
            cell.textLabel.attributedText = attribute;
        }
        else
        {
            cell.textLabel.text = @"";
            cell.hidden = YES;
        }
    }
    else if (indexPath.row == 1)
    {
        if ([self.dataDic[@"type"] integerValue] == 1)
        {
            NSString * amount = @"";
            if ([self.dataDic[@"use_type"] isEqualToString:@"direct"])
            {
                amount = [NSString stringWithFormat:@"%@%@元%@代金券", @"仅限".localized, @([self.dataDic[@"meet_amount"] floatValue]), @"档可用".localized];
            }
            else
            {
                amount = [self.dataDic[@"meet_amount"] floatValue] == 0 ? [NSString stringWithFormat:@"%@元无门槛代金券", @([self.dataDic[@"money"] floatValue])] : [NSString stringWithFormat:@"%@%@减%@元代金券", @"满".localized, @([self.dataDic[@"meet_amount"] floatValue]), @([self.dataDic[@"money"] floatValue])];
            }
            cell.textLabel.text = amount;
            
            if (self.dataDic[@"result"])
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"\n%@元代金券已到账，共消耗%@金币", @([self.dataDic[@"money"] floatValue]), self.dataDic[@"exchange_coin"]];
            }
            else
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"\n%@，需消耗%@金币", amount, self.dataDic[@"exchange_coin"]];
            }
        }
        else
        {
            cell.textLabel.text = self.dataDic[@"pack_title"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"\n%@", self.dataDic[@"packcontent"]];
        }
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"使用说明";
        if ([self.dataDic[@"type"] integerValue] == 1)
        {
            cell.detailTextLabel.text = @"\n仅限BT游戏";
        }
        else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"\n%@", self.dataDic[@"packuse"]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"==%ld",(long)indexPath.row);
}

- (IBAction)closeBtnClick:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)receiveBtnClick:(id)sender
{
    //代金券
    if ([self.dataDic[@"type"] integerValue] == 1)
    {
        if (self.dataDic[@"result"])
        {
            [self removeFromSuperview];
        }
        else
        {
            [self exchangeVoucherRequest];
        }
    }
    else
    {
        if (self.dataDic[@"gift_code"])
        {
            UIPasteboard * paste = [UIPasteboard generalPasteboard];
            paste.string = self.dataDic[@"gift_code"];
            [MBProgressHUD showToast:@"复制成功,也可前往我的礼包查看" toView:[UIApplication sharedApplication].keyWindow];
            
            [self removeFromSuperview];
        }
        else
        {
            [self exchangeVoucherRequest];
        }
    }
}

- (void)exchangeVoucherRequest
{
    UIView * view = [YYToolModel getCurrentVC].view;
    //兑换请求
    MyLimitedBuyReceivedApi * api = [[MyLimitedBuyReceivedApi alloc] init];
    api.isShow = YES;
    api.receiveId = self.dataDic[@"id"];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            if ([self.dataDic[@"type"] integerValue] == 1)
            {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
                [dic setValue:@"1" forKey:@"result"];
                self.dataDic = dic;
                [self.tableView reloadData];
                
                [self.receiveBtn setTitle:@"确定" forState:0];
                self.showTitle.text = @"抢购成功";
            }
            else
            {
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
                [dic setValue:request.data[@"gift_card"] forKey:@"gift_code"];
                self.dataDic = dic;
                [self.tableView reloadData];
                [self.receiveBtn setTitle:@"复制礼包码" forState:0];
                self.showTitle.text = @"抢购成功";
            }
            if (self.receiveGiftAction) {
                self.receiveGiftAction();
            }
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:request.error_desc toView:view];
    }];
}

- (void)parmasData:(NSDictionary *)dic
{
    
}

@end
