//
//  MyRebateMoreGiftCodeController.m
//  Game789
//
//  Created by Maiyou001 on 2021/6/28.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MyRebateMoreGiftCodeController.h"
#import "MyRebateDetailGiftCodeCell.h"

@interface MyRebateMoreGiftCodeController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MyRebateMoreGiftCodeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navBar.title = @"更多礼包码";
    [self.navBar wr_setRightButtonWithTitle:@"一键复制" titleColor:MAIN_COLOR];
    WEAKSELF
    [self.navBar setOnClickRightButton:^{
        NSString * codes = nil;
        for (NSString * str in weakSelf.dataArray)
        {
            codes == nil ? codes = str : (codes = [codes stringByAppendingFormat:@"\n%@", str]);
        }
        UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = codes;
        
        [MBProgressHUD showToast:@"已复制到粘贴板" toView:weakSelf.view];
    }];
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = FontColorF6;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:@"MyRebateDetailGiftCodeCell" bundle:nil] forCellReuseIdentifier:@"MyRebateDetailGiftCodeCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"MyRebateDetailGiftCodeCell";
    MyRebateDetailGiftCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell.showCode.text = self.dataArray[indexPath.row];
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
