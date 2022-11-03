//
//  MyTryPlayListCell.m
//  Game789
//
//  Created by Maiyou on 2020/12/31.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyTryPlayListCell.h"

#import "MyTryPlayApi.h"
@class MyReceiveTaskApi;
@class MyReceiveCoinsApi;

#define kDegreesToRadians(x) (M_PI*(x)/180.0)

@implementation MyTryPlayListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self sectorProgress];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 扇形图
- (void)sectorProgress
{
    self.progressView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0, 0, 42, 42) pathBackColor:[UIColor colorWithHexString:@"#DDDDDD"] pathFillColor:[UIColor colorWithHexString:@"#FF5E00"] startAngle:137 strokeWidth:2];
    self.progressView.reduceAngle = 90;
    self.progressView.duration = 1.0f;
    self.progressView.showPoint = NO;
    self.progressView.showProgressText = NO;
    self.progressView.increaseFromLast = YES;
    self.progressView.backgroundColor = [UIColor whiteColor];
    [self.circleView insertSubview:self.progressView belowSubview:self.showCount];
}

- (void)setDataModel:(MyTryPlayModel *)dataModel
{
    _dataModel = dataModel;
    
    [self.showIcon yy_setImageWithURL:[NSURL URLWithString:dataModel.game_logo] placeholder:MYGetImage(@"game_icon")];
    
    self.showName.text = dataModel.game_name;
    
    self.showTime.text = [NSString stringWithFormat:@"有效期：%@", dataModel.validity];
    
    self.showTask.text = [NSString stringWithFormat:@"要求：%@", dataModel.require];
    
    self.showCoin.text = [NSString stringWithFormat:@"奖励：%@", dataModel.reward];
    
    self.progressView.progress = dataModel.surplus / (CGFloat)dataModel.total;
    
    self.showCount.text = [NSString stringWithFormat:@"%ld", (long)dataModel.surplus];
    
    BOOL isNameRemark = [YYToolModel isBlankString:dataModel.nameRemark];
    self.nameRemark.text = isNameRemark ? @"" : [NSString stringWithFormat:@"%@  ", dataModel.nameRemark];
    self.nameRemark.hidden = isNameRemark;
    
    //是否还有任务可领
    if (dataModel.surplus == 0)
    {
        self.receiveBtn.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
        [self.receiveBtn setTitle:@"已领完" forState:0];
        return;
    }
    //是否领取了任务
    if (dataModel.is_receive == 0)
    {
        self.receiveBtn.backgroundColor = MAIN_COLOR;
        [self.receiveBtn setTitle:@"领任务" forState:0];
    }
    else
    {
        //是否完成了任务
        if (dataModel.is_complete == 0)
        {
            self.receiveBtn.backgroundColor = MAIN_COLOR;
            [self.receiveBtn setTitle:@"进行中" forState:0];
        }
        else
        {
            //是否领取了金币
            if (dataModel.is_receive_coin == 0)
            {
                self.receiveBtn.backgroundColor = [UIColor colorWithHexString:@"#FF8400"];
                [self.receiveBtn setTitle:@"领奖励" forState:0];
            }
            else
            {
                self.receiveBtn.backgroundColor = [UIColor colorWithHexString:@"#DEDEDE"];
                [self.receiveBtn setTitle:@"已完成" forState:0];
            }
        }
    }
}

- (IBAction)receiveBtnClick:(id)sender
{
    if (self.dataModel.surplus == 0)
    {
        return;
    }
    
    if (self.dataModel.is_receive == 0)
    {//领取任务
        [MyAOPManager relateStatistic:@"ClickToGetTrialTask" Info:@{@"game_name":self.dataModel.game_name}];
        [self receiveTaskRequest];
    }
    else if (self.dataModel.is_complete == 1 && self.dataModel.is_receive_coin == 0)
    {//领取金币
        [self receiveCoinsRequest];
    }
}

#pragma mark ——— 领取任务
- (void)receiveTaskRequest
{
    MyReceiveTaskApi * api = [[MyReceiveTaskApi alloc] init];
    api.isShow = YES;
    api.taskId = self.dataModel.Id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [YJProgressHUD showSuccess:@"领取成功" inview:[YYToolModel getCurrentVC].view];
            NSInteger surplus = self.dataModel.surplus;
            surplus --;
            self.dataModel.surplus = surplus;
            self.dataModel.is_receive = 1;
            if (self.receivedActionBlock) {
                self.receivedActionBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                GameDetailInfoController * detail = [GameDetailInfoController new];
                detail.hidesBottomBarWhenPushed = YES;
                detail.maiyou_gameid = [NSString stringWithFormat:@"%ld", (long)self.dataModel.gameid];
                [[YYToolModel getCurrentVC].navigationController pushViewController:detail animated:YES];
            });
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark ——— 领取金币
- (void)receiveCoinsRequest
{
    MyReceiveCoinsApi * api = [[MyReceiveCoinsApi alloc] init];
    api.isShow = YES;
    api.taskId = self.dataModel.Id;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            [YJProgressHUD showSuccess:@"领取成功" inview:[YYToolModel getCurrentVC].view];
            self.dataModel.is_receive_coin = 1;
            if (self.receivedActionBlock) {
                self.receivedActionBlock();
            }
        }
        else
        {
            [MBProgressHUD showToast:request.error_desc toView:[YYToolModel getCurrentVC].view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

@end
