//
//  DownLoadManageController.m
//  Game789
//
//  Created by Maiyou on 2018/11/27.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "DownLoadManageController.h"
#import "DownLoadManageCell.h"
#import "MyGameDownLoadView.h"
#import "WebViewController.h"

@interface DownLoadManageController ()

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) MyGameDownLoadView * downView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *allButton;

@end

@implementation DownLoadManageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareBasic];
}

- (void)prepareBasic
{
    self.navBar.title = @"下载管理".localized;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatNavRightButton];
    
    [self creatTopView];
}

- (void)creatNavRightButton
{
    NSMutableArray * cacheDataList = [NSMutableArray array];
    [cacheDataList addObjectsFromArray:[YCDownloadManager downloadList]];
    [cacheDataList addObjectsFromArray:[YCDownloadManager finishList]];
    
    if (cacheDataList.count > 0 && ![MyResignTimeTask sharedManager].isResign && [YCDownloadManager downloadList].count == 0)
    {
        WEAKSELF
        [self.navBar wr_setRightButtonWithTitle:@"编辑".localized titleColor:ORANGE_COLOR];
        [self.navBar setOnClickRightButton:^{
            [weakSelf changeEditStatus];
        }];
    }
}

- (void)changeEditStatus
{
    self.isEdit = !self.isEdit;
    self.downView.isEdit = self.isEdit;
    self.downView.tableView.editing = self.isEdit;
    
    self.bottomView.hidden = !self.isEdit;
    CGFloat view_top = [DeviceInfo shareInstance].isGameVip ? kStatusBarAndNavigationBarHeight : kStatusBarAndNavigationBarHeight + 60;
    if (self.isEdit)
    {
        self.downView.height = kScreenH - view_top - 44 - kTabbarSafeBottomMargin;
    }
    else
    {
        self.downView.height = kScreenH - view_top - kTabbarSafeBottomMargin;
        self.allButton.selected = NO;
    }
    self.downView.tableView.height = self.downView.height;
    [self.navBar.rightButton setTitle:self.isEdit ? @"取消".localized : @"编辑".localized forState:0];
    [self.downView.tableView reloadData];
}

- (void)creatTopView
{
    if (![DeviceInfo shareInstance].isGameVip)
    {
        UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, 60)];
        topView.backgroundColor = MYColor(250, 232, 214);
        [self.view addSubview:topView];
        
        NSArray * array = @[@"①下载完毕安装时，请返回桌面查看安装进度;".localized, @"②若游戏提示“未受信任...”，请戳→如何设置信任?".localized];
        for (int i = 0; i < array.count; i ++)
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, i * 30, kScreenW - 30, 30)];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor darkGrayColor];
            label.text = array[i];
            [topView addSubview:label];
            
            if (i == 1)
            {
                NSString * string = @"如何设置信任?";
                NSRange range = [array[i] rangeOfString:@"→"];
                NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:array[i]];
                [attribtStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(range.location + 1, string.length)];
                [attribtStr addAttribute:NSForegroundColorAttributeName value:MYColor(0, 142, 245) range:NSMakeRange(range.location + 1, string.length)];
                label.attributedText = attribtStr;
                
                [label yb_addAttributeTapActionWithStrings:@[string] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
                    MYLog(@"-------%@", string);
                    WebViewController * web = [WebViewController new];
                    web.hidesBottomBarWhenPushed = YES;
                    web.urlString = @"http://www.985sy.com/pages/iosCertificate/";
                    [self.navigationController pushViewController:web animated:YES];
                }];
            }
        }
    }
    
    CGFloat view_top = [DeviceInfo shareInstance].isGameVip ? kStatusBarAndNavigationBarHeight : kStatusBarAndNavigationBarHeight + 60;
    self.downView = [[MyGameDownLoadView alloc] initWithFrame:CGRectMake(0, view_top, kScreenW, kScreenH - view_top - kTabbarSafeBottomMargin)];
    self.downView.currentVC = self;
    [self.view addSubview:self.downView];
    [self.downView reloadDownLoadData];
}

- (IBAction)selectAllButtonClick:(id)sender
{
    UIButton * button = sender;
    
    button.selected = !button.selected;
    
    [self.downView.selectedArray removeAllObjects];
    if (button.isSelected)
    {
        for (int i = 0; i < self.downView.cacheDataList.count; i ++)
        {
            [self.downView.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        self.downView.selectedArray = [NSMutableArray arrayWithArray:self.downView.cacheDataList];
    }
    else
    {
        for (int i = 0; i < self.downView.cacheDataList.count; i ++)
        {
            [self.downView.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
    }
}


- (IBAction)deleteButtonClick:(id)sender
{
    WEAKSELF
    [weakSelf jxt_showAlertWithTitle:@"提示".localized message:@"删除任务将同时删除已下载的本地文件，确定删除吗?".localized appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
        alertMaker.addActionCancelTitle(@"取消".localized).addActionDefaultTitle(@"确定".localized);
    } actionsBlock:^(NSInteger buttonIndex, UIAlertAction * _Nonnull action, JXTAlertController * _Nonnull alertSelf) {
        if (buttonIndex == 1) {
            for (int i = 0; i < self.downView.selectedArray.count; i ++)
            {
                YCDownloadItem * item = weakSelf.downView.selectedArray[i];
                [YCDownloadManager stopDownloadWithItem:item];
                if ([weakSelf.downView.cacheDataList containsObject:item]) {
                    [weakSelf.downView.cacheDataList removeObject:item];
                }
            }
            [weakSelf changeEditStatus];
        }
        else
        {
            [weakSelf changeEditStatus];
        }
    }];
}


@end
