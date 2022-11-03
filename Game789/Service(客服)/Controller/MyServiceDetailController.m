//
//  MyServiceDetailController.m
//  Game789
//
//  Created by Maiyou on 2020/9/30.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyServiceDetailController.h"
#import "MyServiceDetailCell.h"

@interface MyServiceDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MyServiceDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    self.navBar.title = self.dataDic[@"text"];
    self.dataArray = self.dataDic[@"items"];
    [self.tableView reloadData];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH - kStatusBarAndNavigationBarHeight - kTabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 60;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MyServiceDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyServiceDetailCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"MyServiceDetailCell";
    MyServiceDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    cell.showTitle.text = self.dataArray[indexPath.row][@"q"];
    NSString * content = [self.dataArray[indexPath.row][@"a"] stringByReplacingOccurrencesOfString:@"<br>\n" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:@"  " withString:@""];
    cell.showContent.text = content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
