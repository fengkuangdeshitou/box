//
//  AreaViewController.m
//  Game789
//
//  Created by maiyou on 2021/10/28.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "AreaViewController.h"
#import "LoginApi.h"
#import "AreaIndexTableViewCell.h"
#import "UITableView+SCIndexView.h"
#import "SCIndexView.h"

@interface AreaViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *areaArray;
@property (nonatomic,strong) NSMutableArray *indexArray;
@property(nonatomic,weak)IBOutlet UITableView * tableView;
@property(nonatomic,weak)IBOutlet NSLayoutConstraint * top;

@end

@implementation AreaViewController

- (NSMutableArray *)indexArray{
    if (!_indexArray) {
        _indexArray = [[NSMutableArray alloc] init];
    }
    return _indexArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navBar.title = @"选择国家或地区";
    self.top.constant = kStatusBarAndNavigationBarHeight;
    SCIndexViewConfiguration * config = [SCIndexViewConfiguration configuration];
    config.indexItemBackgroundColor = UIColor.clearColor;
    config.indexItemTextFont = [UIFont systemFontOfSize:11];
    config.indexItemSelectedBackgroundColor = UIColor.clearColor;
    config.indexItemSelectedTextColor = MAIN_COLOR;
    config.indexItemsSpace = 8;
    config.indexItemRightMargin = 5;
    self.tableView.sc_indexViewConfiguration = config;
    self.tableView.sc_translucentForTableViewInNavigationBar = false;
    [self getCountryCodeList];
}

#pragma mark - 获取国家/地区代码表
- (void)getCountryCodeList
{
    GetCountryCodeApi * api = [[GetCountryCodeApi alloc] init];
    [api startWithRequestSuccessBlock:^(BaseRequest * _Nonnull request) {
        if (request.success)
        {
            self.areaArray = request.data;
            for (int i=0; i<self.areaArray.count; i++) {
                NSDictionary * item = self.areaArray[i];
                [self.indexArray addObject:item[@"key"]];
            }
            self.tableView.sc_indexViewDataSource = self.indexArray;
            self.tableView.sc_startSection = 0;
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showToast:api.error_desc  toView:self.view];
        }
    } failureBlock:^(BaseRequest * _Nonnull request) {
        [MBProgressHUD showToast:api.error_desc  toView:self.view];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifity = @"AreaIndexTableViewCell";
    AreaIndexTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifity];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AreaIndexTableViewCell" owner:self options:nil] lastObject];
    }
    cell.titleLabel.text = self.areaArray[indexPath.section][@"data"][indexPath.row][@"countryName"];
    cell.detailLabel.text = [NSString stringWithFormat:@"+ %@ ",self.areaArray[indexPath.section][@"data"][indexPath.row][@"phoneCode"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * item = self.areaArray[indexPath.section][@"data"][indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectedArea:)]) {
        [self.delegate onSelectedArea:item];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.areaArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.areaArray[section][@"data"] count];
}

//- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.indexArray;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.indexArray[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return tableView == self.tableView ? 28 : 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
