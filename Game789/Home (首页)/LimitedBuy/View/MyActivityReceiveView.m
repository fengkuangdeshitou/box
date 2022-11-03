//
//  HGGameReceiveGiftView.m
//  HeiGuGame
//
//  Created by Maiyou on 2020/6/3.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyActivityReceiveView.h"

@implementation MyActivityReceiveView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"HGGameReceiveGiftView" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.estimatedRowHeight = 44;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    self.showTitle.text = [self.dataDic[@"isReceived"] boolValue] ? @"领取成功" : dataDic[@"name"];
    
    if ([dataDic[@"isReceive"] boolValue])
    {
        [self.receiveBtn setTitle:[self.dataDic[@"isReceived"] boolValue] ? @"复制" : @"领取" forState:0];
    }
    else
    {
        [self.receiveBtn setTitle:@"请到游戏悬浮球中领取" forState:0];
    }
    
    if ([dataDic[@"endTime"] floatValue] == 0)
    {
        self.showTime.text = @"有效期：长期有效";
    }
    else
    {
        self.showTime.text = [NSString stringWithFormat:@"有效期至：%@", [NSDate dateWithFormat:@"yyyy.MM.dd" WithTS:[dataDic[@"endTime"] doubleValue]]];
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
        return [self.dataDic[@"isReceived"] boolValue] ? 44 : 0;
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
    cell.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    cell.textLabel.textColor = FontColor28;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = FontColor66;
    cell.detailTextLabel.numberOfLines = 0;
    if (indexPath.row == 0)
    {
        if ([self.dataDic[@"isReceived"] boolValue])
        {
            cell.hidden = NO;
            NSString * str = [NSString stringWithFormat:@"礼包码：%@", self.dataDic[@"receivedCdk"]];
            NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:str];
            [attribute addAttributes:@{NSForegroundColorAttributeName:MAIN_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightMedium]} range:[str rangeOfString:self.dataDic[@"receivedCdk"]]];
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
        cell.textLabel.text = self.dataDic[@"name"];
        cell.detailTextLabel.text = self.dataDic[@"content"];
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"使用说明";
        cell.detailTextLabel.text = self.dataDic[@"explain"];
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
    if ([self.dataDic[@"isReceive"] boolValue])
    {
        if ([self.dataDic[@"isReceived"] boolValue])
        {
            [self removeFromSuperview];
            UIPasteboard * paste = [UIPasteboard generalPasteboard];
            paste.string = self.dataDic[@"receivedCdk"];
            [MBProgressHUD showToast:@"复制成功" toView:[UIApplication sharedApplication].keyWindow];
        }
        else
        {
            if ([YYToolModel islogin])
            {
                if (self.receiveGiftAction) {
                    self.receiveGiftAction();
                }
            }
            else
            {
                [self removeFromSuperview];
            }
        }
    }
    else
    {
        [self removeFromSuperview];
    }
}


@end
