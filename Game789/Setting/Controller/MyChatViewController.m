//
//  MyChatViewController.m
//  Game789
//
//  Created by Maiyou001 on 2022/8/26.
//  Copyright © 2022 yangyong. All rights reserved.
//

#import "MyChatViewController.h"
#import "GetSettingNewsMgsList.h"
@class GetChatMessageAPI;
@class SendChatMessageAPI;

#import "GetSettingNewsMgsModel.h"
@class MyChatMessageModel;

#import "MyChatTableViewCell.h"

@interface MyChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatView_bottom;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textView_height;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSDictionary *infoDic;

@end

@implementation MyChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.title = @"平台消息";
    
    self.tableView_top.constant = kStatusBarAndNavigationBarHeight;
    self.chatView_bottom.constant = kTabbarSafeBottomMargin;
    [self.textView setContentInset:UIEdgeInsetsMake(0, 5, 0, 5)];
    self.textView.zw_placeHolder = @"请输入回复内容";
    self.textView.zw_placeHolderColor = [UIColor colorWithHexString:@"#999999"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged) name:UITextViewTextDidChangeNotification object:nil];
    
//    self.tableView.tableFooterView = [self creatFooterView];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 15, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyChatTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyChatTableViewCell"];
    
    [self addKeyboardObserver];
    
    [self getMessageList:nil Hud:YES];
    
    [self loadData];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)getMessageList:(RequestData)block Hud:(BOOL)isHud
{
    GetChatMessageAPI * api = [[GetChatMessageAPI alloc] init];
    api.isShow = isHud;
    api.Id = self.message_id;
    api.pageNumber = self.pageNumber;
    api.count = 20;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success) {
            if (block) block(YES);
            self.infoDic = request.data[@"info"];
            self.navBar.title = self.infoDic[@"title"];
            
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * dic in request.data[@"list"])
            {
                NSMutableDictionary * muDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
                [muDic addEntriesFromDictionary:self.infoDic];
                MyChatMessageModel * model = [MyChatMessageModel mj_objectWithKeyValues:muDic];
                [array addObject:model];
            }
            if (self.pageNumber == 1){
                array = (NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
                self.dataArray = [NSMutableArray arrayWithArray:array];
                [self.tableView reloadData];
                [self scrollToBottom];
            }else{
                for (MyChatMessageModel * model in array)
                {
                    [self.dataArray insertObject:model atIndex:0];
                }
                [self.tableView reloadData];
            }
            
//            NSDictionary * paginated = request.data[@"paginated"];
//            if (![paginated[@"more"] boolValue])
//            {
//                self.tableView.mj_header.state = MJRefreshStateNoMoreData;
//            }
        } else {
            [YJProgressHUD showMessage:api.error_desc inView:self.view];
            if (block) block(NO);
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        if (block) block(NO);
    }];
}

#pragma mark - 输入框处理键盘
- (void)addKeyboardObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat curkeyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0&& (begin.origin.y-end.origin.y>0)){
        [UIView animateWithDuration:0.26 animations:^{
            self.chatView_bottom.constant = curkeyBoardHeight;
        } completion:^(BOOL finished) {
            if (self.dataArray.count > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [UIView animateWithDuration:0.26 animations:^{
        self.chatView_bottom.constant = kTabbarSafeBottomMargin;
    }];
}

- (UIView *)creatFooterView
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 15)];
    view.backgroundColor = UIColor.clearColor;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyChatTableViewCell";
    MyChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.chatModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)submitBtnClick:(id)sender
{
    if (self.textView.text.length == 0)
    {
        [YJProgressHUD showMessage:@"请输入回复内容" inView:self.view];
        return;
    }
    SendChatMessageAPI * api = [[SendChatMessageAPI alloc] init];
    api.isShow = YES;
    api.taskId = self.infoDic[@"taskId"];
    api.toUid  = self.infoDic[@"fromUid"];
    api.content = self.textView.text;
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success) {
            MyChatMessageModel * model = [MyChatMessageModel mj_objectWithKeyValues:self.infoDic];
            model.content = self.textView.text;
            model.messageType = @"text";
            model.type = @"2";
            model.gameInfo = @{};
            model.createTime = [NSDate getNowTimeTimestamp:@"yyyy-MM-dd HH:mm:ss"];
            self.textView.text = @"";
            
            [self.dataArray addObject:model];
            [self.tableView reloadData];
            
            [self scrollToBottom];
        } else {
            [YJProgressHUD showMessage:request.error_desc inView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        
    }];
}

- (void)scrollToBottom
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

- (void)textViewChanged
{
    CGRect rect = [self.textView.text boundingRectWithSize:CGSizeMake(self.textView.width - 14, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    CGFloat height = rect.size.height + 16;
    [UIView animateWithDuration:0.26 animations:^{
        if (height > 39)
        {
            self.textView_height.constant = height > 83 ? 83 : height;
        }
        else
        {
            self.textView_height.constant = 39;
        }
    }];
}

- (void)loadData
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MFRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNumber ++;
        [self getMessageList:^(BOOL isSuccess) {
            [tableView.mj_header endRefreshing];
        } Hud:NO];
    }];
}

@end
