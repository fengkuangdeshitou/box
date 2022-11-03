//
//  DownLoadManageCell.m
//  Game789
//
//  Created by Maiyou on 2018/11/27.
//  Copyright © 2018 xinpenghui. All rights reserved.
//

#import "DownLoadManageCell.h"

@implementation DownLoadManageCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    if (![DeviceInfo shareInstance].isGameVip)
    {
        CGFloat view_width = self.pauseButton.height;
        MyColorCircle *circle = [[MyColorCircle alloc]initWithFrame:CGRectMake((self.pauseButton.width - view_width) / 2, 0, view_width, view_width)];
        circle.hidden = YES;
        [self.pauseButton addSubview:circle];
        self.circleView = circle;
    }
    
    self.showDownSize.hidden = YES;
    self.progressView.hidden = YES;
}

- (void)setItem:(YCDownloadItem *)item
{
    _item = item;
    
    item.delegate = self;
    self.progressView.tintColor = self.selectIndex == 0 ? [UIColor groupTableViewBackgroundColor] : ORANGE_COLOR;
    //当下载地址为空/未分包时
    if ([item.downloadURL isEqualToString:@""])
    {
        self.progressView.progress = 0.05;
    }
    [self hiddenView];
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:item.extraData options:0 error:nil];
    [self setModelDic:dic];
}

- (void)setModelDic:(NSDictionary *)dic
{
    self.data = dic;
    self.routeURL = [dic[@"gama_url"] objectForKey:@"ios_url"];
    
    NSString *url = [[dic objectForKey:@"game_image"]objectForKey:@"thumb"];
    [self.imageViews sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:MYGetImage(@"game_icon") options:SDWebImageHighPriority];
    
    self.titleLabel.text = dic[@"game_name"];
    
    self.showDownSize.text = [NSString stringWithFormat:@"%@/%@", [YCDownloadUtils fileSizeStringFromBytes:self.item.downloadedSize], [YCDownloadUtils fileSizeStringFromBytes:self.item.fileSize]];
    
    [self getDownloadStatus:self.item];
    
    
    if ([[MyResignTimeTask sharedManager].maiyou_gameid isEqualToString:dic[@"maiyou_gameid"]] && [MyResignTimeTask sharedManager].isResign)
    {
        [MyResignTimeTask sharedManager].delegate = self;
    }
}

#pragma mark - 获取下载状态
- (void)getDownloadStatus:(YCDownloadItem *)item
{
//    MYLog(@">>>>>>>>>>>>>>>>>>>%lu", (unsigned long)self.item.downloadStatus);
    switch (item.downloadStatus) {
        case YCDownloadStatusPaused:
            [self.pauseButton setTitle:@"继续".localized forState:0];
            self.showDownSpeed.text = @"已暂停".localized;
            self.progressView.progress = (float)self.item.downloadedSize / self.item.fileSize;
            [self hiddenDeleteButton:YES];
            break;
        case YCDownloadStatusDownloading:
            [self.pauseButton setTitle:[DeviceInfo shareInstance].isGameVip ? @"下载中".localized : @"暂停".localized forState:0];
            [DeviceInfo shareInstance].isGameVip ? (self.progressView.progress = [MyResignTimeTask sharedManager].resginProgress) : (self.progressView.progress = (float)self.item.downloadedSize / self.item.fileSize);
            self.showDownSpeed.text = @"下载中".localized;
            [self hiddenDeleteButton:YES];
            break;
        case YCDownloadStatusFinished:
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString * title = [YYToolModel getIpaDownloadStatus:item];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.pauseButton setTitle:title forState:0];
                    self.showDownSpeed_top.constant = 20;
                    self.showDownSpeed.text  = [YCDownloadUtils fileSizeStringFromBytes:self.item.fileSize];
                    self.showDownSize.hidden = YES;
                    self.progressView.hidden = YES;
                    [self hiddenDeleteButton:NO];
                });
            });
        }
            break;
        case YCDownloadStatusWaiting:
            [self.pauseButton setTitle:@"等待中".localized forState:0];
            self.circleView.hidden = YES;
            self.progressView.progress = (float)self.item.downloadedSize / self.item.fileSize;
            self.showDownSpeed.text = @"等待下载".localized;
            [self hiddenDeleteButton:YES];
            break;
        case YCDownloadStatusFailed:
            [self.pauseButton setTitle:@"" forState:0];
            self.circleView.hidden = NO;
            self.showDownSize.text = @"正在获取下载地址".localized;
            [self hiddenDeleteButton:NO];
            //当没有正在签名的删除因闪退等不定因素导致失败的
            if (![MyResignTimeTask sharedManager].isResign) {
                [YCDownloadManager stopDownloadWithItem:item];
            }
            break;
            
        default:
            break;
    }
}

- (void)hiddenDeleteButton:(BOOL)isHidden
{
    if ([DeviceInfo shareInstance].isGameVip)
    {
        if (self.isEditing)
        {
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
            self.deleteButton.hidden = YES;
            self.pauseButton.enabled = NO;
        }
        else
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.deleteButton.hidden = isHidden;
            self.pauseButton.enabled = YES;
        }
    }
}

- (void)hiddenView
{
    self.showDownSize.hidden = self.item.downloadStatus == 5 ? YES : NO;
    self.progressView.hidden = self.item.downloadStatus == 5 ? YES : NO;
}

- (IBAction)pauseButtonAction:(id)sender
{
    switch (self.item.downloadStatus) {
        case YCDownloadStatusPaused:
            if (![DeviceInfo shareInstance].isGameVip)
            {
                [YCDownloadManager resumeDownloadWithItem:self.item];
            }
//            [self.pauseButton setTitle:@"暂停" forState:0];
//            self.showDownSpeed.text = @"下载中";
        break;
        case YCDownloadStatusDownloading:
            if (![DeviceInfo shareInstance].isGameVip)
            {
                [YCDownloadManager pauseDownloadWithItem:self.item];
            }
//            [self.pauseButton setTitle:@"继续" forState:0];
//            self.showDownSpeed.text = @"已暂停";
        break;
        case YCDownloadStatusFinished:
        {
            NSString * bundleid = _data[@"my_ios_bundleid"];
            if ([YYToolModel isInstalled:bundleid IsList:NO]) {
                [YYToolModel openApp:_data[@"my_ios_bundleid"]];
            }
            else
            {
                [self installAppClick];
            }
        }
        break;
        
        default:
        break;
    }
}

#pragma mark - 删除下载
- (IBAction)deteteDataAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    self.deleteLoadData(button.tag);
}

#pragma mark - YCYCDownloadItemDelegate
- (void)downloadItemStatusChanged:(nonnull YCDownloadItem *)item
{
    MYLog(@"downloadStatus : %lu", (unsigned long)item.downloadStatus);
    //改变该条任务状态
    [self getDownloadStatus:item];
    //刷新当前页面列表
    self.downLoadStatusChanged(item.downloadStatus);
    if (item.downloadStatus == YCDownloadStatusFinished)
    {
        [self hiddenDeleteButton:NO];
        [self installAppClick];
    }
}

- (void)downloadItem:(nonnull YCDownloadItem *)item downloadedSize:(int64_t)downloadedSize totalSize:(int64_t)totalSize
{
    //解决没有进度,percent = 0/0 = 1
    if (totalSize == 0 && downloadedSize == 0) return;
    CGFloat percent = (float)downloadedSize / totalSize;
    if ([DeviceInfo shareInstance].isGameVip)
    {
        CGFloat progress = [MyResignTimeTask sharedManager].resginProgress;
        self.progressView.progress = percent * (1 - progress) + progress;
    }
    else
    {
        //进度条
        self.progressView.progress = percent;
    }
    
    //下载大小
    self.showDownSize.text = [NSString stringWithFormat:@"%@/%@",  [YCDownloadUtils fileSizeStringFromBytes:downloadedSize], [YCDownloadUtils fileSizeStringFromBytes:totalSize]];
    MYLog(@"=======%f", (float)downloadedSize / totalSize);
}

- (void)downloadItem:(nonnull YCDownloadItem *)item speed:(NSUInteger)speed speedDesc:(NSString *)speedDesc
{
    self.showDownSpeed.text = [NSString stringWithFormat:@"%luB/s", (unsigned long)speed];
}

#pragma mark — MyResignTimeTaskDelegate
- (void)resignTimingWithDownIpa:(CGFloat)progress
{
    self.progressView.progress = progress;
    self.showDownSize.text = @"正在下载".localized;
    self.deleteButton.hidden = YES;
    
    [self.pauseButton setTitle:[MyResignTimeTask sharedManager].statusTitle forState:0];
}

#pragma mark - 安装APP
- (void)installAppClick
{
    [YYToolModel installAppForItem:self.item];
}

@end
