//
//  MessageHeaderView.m
//  Game789
//
//  Created by maiyou on 2021/4/6.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MessageHeaderView.h"
#import "MessageHeaderCell.h"
#import "MessageTypeViewController.h"

@interface MessageHeaderView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray * colorArray;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UITableView * tableView;

@end

@implementation MessageHeaderView

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 74;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        [self.tableView registerNib:[UINib nibWithNibName:@"MessageHeaderCell" bundle:nil] forCellReuseIdentifier:@"MessageHeaderCell"];
        self.colorArray = @[@[(id)[UIColor colorWithHexString:@"#F44557"].CGColor,(id)[UIColor colorWithHexString:@"#F86C9E"].CGColor],@[(id)[UIColor colorWithHexString:@"#3C9FFF"].CGColor,(id)[UIColor colorWithHexString:@"#49C8FF"].CGColor],@[(id)[UIColor colorWithHexString:@"#FFB069"].CGColor,(id)[UIColor colorWithHexString:@"#FFDC7C"].CGColor]];
    }
    return self;
}

- (void)setDataDictionary:(NSDictionary *)dataDictionary{
    _dataDictionary = dataDictionary;
    self.dataArray = [[NSMutableArray alloc] init];
    [self.dataArray addObject:dataDictionary[@"comment"]];
    [self.dataArray addObject:dataDictionary[@"qa"]];
//    [self.dataArray addObject:dataDictionary[@"topic"]];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MessageHeaderCell" forIndexPath:indexPath];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * item = self.dataArray[indexPath.row];
    NSString * type = item[@"type"];
    MessageTypeViewController * controller = [[MessageTypeViewController alloc] initWithType:type];
    controller.title = item[@"title"];
    controller.delegate = [YYToolModel getCurrentVC];
    [[YYToolModel getCurrentVC].navigationController pushViewController:controller animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
