//
//  HGCommunicityTopicV.m
//  HeiGuGame
//
//  Created by Harrison on 2020/9/28.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "HGCommunicityTopicV.h"

#import "MyCommunityRequestApi.h"
@class MyCommunityThemeRequestApi;

@interface HGCommunicityTopicV()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic ,strong) UIButton *closeBtn;
@property (nonatomic , strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;  //热议话题的；label
/** 页数  */
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) NSMutableArray *roomNotifyArr;
@end

@implementation HGCommunicityTopicV

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self = [[NSBundle mainBundle] loadNibNamed:@"HGCommunicityTopicV" owner:self options:nil].firstObject;
        self.frame = frame;
        self.backgroundColor = ColorWhite;
        self.pageNumber = 1;
        [self initView];
        [self netWork];
    }
    return self;
}

- (void)netWork
{
    MyCommunityThemeRequestApi * api = [[MyCommunityThemeRequestApi alloc] init];
    api.isShow = YES;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success == 1)
        {
            NSArray *dataArray = request.data[@"list"];
            if (self.pageNumber == 1 && self.roomNotifyArr.count > 0)
            {
                [self.roomNotifyArr removeAllObjects];
            }
            [self.roomNotifyArr addObjectsFromArray:dataArray];
            [self.tableView reloadData];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

-(void) initView
{
    [self addSubview:self.closeBtn];
    [self addSubview:self.tableView];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(-  (IS_IPhoneX_All ? 34.f : 10.f));
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.height.mas_equalTo (@44);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicLabel.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-20);
        make.bottom.equalTo(self.closeBtn.mas_top).offset(-10);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.roomNotifyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dic = self.roomNotifyArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", dic[@"themename"]];
    cell.textLabel.font = [UIFont fontWithName:@"Regular"size:16];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.roomNotifyArr[indexPath.row];
    if(_topicBlock)_topicBlock(dic[@"themename"], dic[@"id"]);
}

#pragma mark -- 关闭按钮回调
-(void) closeBtnWithAction
{
    if (self.textField.text)
    {
//        YYBaseApi *api = [[YYBaseApi alloc] init];
//        [api yy_Post:@"/createTheme" parameters:@{@"name": self.textField.text} swpNetworkingSuccess:^(id  _Nonnull resultObject) {
//            NSDictionary *dic = resultObject[@"data"][@"data"];
////            [self dismissSheetView];
//            if (self.textField.text) {
//                if(_topicBlock)_topicBlock(dic[@"themename"], dic[@"id"]);
//            }
//        } swpNetworkingError:^(NSError * _Nonnull error, NSString * _Nonnull errorMessage) {
//
//        } Hud:YES];
    }
    else
    {
//        [self dismissSheetView];
    }
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.backgroundColor = MAIN_COLOR;
        [_closeBtn setTitleColor:ColorWhite forState:UIControlStateNormal];
        [_closeBtn setTitle:@"确定" forState:0];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _closeBtn.layer.cornerRadius = 5;
        _closeBtn.layer.masksToBounds = YES;
        [_closeBtn addTarget:self action:@selector(closeBtnWithAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

#pragma mark -- 懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight=0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
//        __unsafe_unretained UITableView *tableView = _tableView;
//          // 下拉刷新
//          tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
//              [tableView.mj_footer resetNoMoreData];
//              self.pageNumber = 1;
//              [self netWork];
//          }];
//
//          // 上拉刷新
//          tableView.mj_footer = [MFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//              self.pageNumber ++;
//              [self netWork];
//          }];
    }
    return _tableView;
}



-(NSMutableArray *)roomNotifyArr{
    if (!_roomNotifyArr) {
        _roomNotifyArr = [[NSMutableArray alloc] init];
    }
    return _roomNotifyArr;
}




@end


