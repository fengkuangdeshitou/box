//
//  MMImageListView.m
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMImageListView.h"
#import "MMImagePreviewView.h"

#pragma mark - ------------------ 小图List显示视图 ------------------

@interface MMImageListView ()

// 图片视图数组
@property (nonatomic, strong) NSMutableArray *imageViewsArray;
// 图片视图数组
@property (nonatomic, strong) NSMutableArray *imageDataArray;
// 预览视图
@property (nonatomic, strong) MMImagePreviewView *previewView;

@property (nonatomic, strong) UILabel * labelCount;

@end

@implementation MMImageListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 小图(九宫格)
        _imageViewsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 9; i++) {
            MMImageView *imageView = [[MMImageView alloc] initWithFrame:CGRectZero];
            imageView.tag = 1000 + i;
            [imageView setTapSmallView:^(MMImageView *imageView){
                [self singleTapSmallViewCallback:imageView];
            }];
            
            [_imageViewsArray addObject:imageView];
            [self addSubview:imageView];
        }
        
        UILabel * label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = NO;
        self.labelCount = label;
        
        // 预览视图
        _previewView = [[MMImagePreviewView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return self;
}

#pragma mark - Setter
- (void)setMoment:(Moment *)moment
{
    _moment = moment;
    for (MMImageView *imageView in _imageViewsArray) {
        imageView.hidden = YES;
    }
    // 图片区
    NSInteger count = moment.pic_list.count;
    if (count == 0) {
        self.size = CGSizeZero;
        return;
    }
    // 更新视图数据
    _previewView.pageNum = count;
    _previewView.scrollView.contentSize = CGSizeMake(_previewView.width*count, _previewView.height);
    // 添加图片
    MMImageView *imageView = nil;
    CGFloat imageWidth = (kScreenW - kImagePadding * 2 - 30) / 3;
    CGFloat imageHeight = 75;
    for (NSInteger i = 0; i < count; i++)
    {
        if (i > 2 && !self.isAll) {
            break;
        }
        NSInteger rowNum = i/3;
        NSInteger colNum = i%3;
//        if(count == 4) {
//            rowNum = i/2;
//            colNum = i%2;
//        }
        
        CGFloat imageX = colNum * (imageWidth + kImagePadding);
        CGFloat imageY = rowNum * (imageHeight + kImagePadding);
        CGRect frame = CGRectMake(imageX, imageY, imageWidth, imageHeight);
        
        //单张图片需计算实际显示size
//        if (count == 1) {
//            CGSize singleSize = [Utility getSingleSize:CGSizeMake(moment.singleWidth, moment.singleHeight)];
//            frame = CGRectMake(0, 0, singleSize.width, singleSize.height);
//        }
        imageView = [self viewWithTag:1000+i];
        imageView.hidden = NO;
        imageView.frame = frame;
        [imageView sd_setImageWithURL:[NSURL URLWithString:moment.pic_list[i]]];
        if (count > 3 && i == 2  && !self.isAll)
        {
            self.labelCount.hidden = NO;
            self.labelCount.frame = imageView.bounds;
            self.labelCount.text = [NSString stringWithFormat:@"+%ld", count - 3];
            [imageView addSubview:self.labelCount];
        }
        else
        {
            self.labelCount.hidden = YES;
        }
    }
    self.width = kTextWidth;
    self.height = imageView.bottom;
}

#pragma mark - 小图单击
- (void)singleTapSmallViewCallback:(MMImageView *)imageView
{
    NSInteger index = imageView.tag-1000;
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = self.imageDataArray;
    browser.currentPage = index;
    [browser show];
}

- (NSMutableArray *)imageDataArray
{
    if (!_imageDataArray)
    {
        _imageDataArray = [NSMutableArray array];
        [self.moment.pic_list enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 网络图片
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = [NSURL URLWithString:obj];
//            data.projectiveView = [self viewAtIndex:idx];
            data.allowSaveToPhotoAlbum = NO;
            [_imageDataArray addObject:data];
        }];
    }
    return _imageDataArray;
}

#pragma mark - 大图单击||长按
- (void)singleTapBigViewCallback:(MMScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        _previewView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _previewView.pageControl.hidden = YES;
        scrollView.contentRect = scrollView.contentRect;
        scrollView.zoomScale = 1.0;
    } completion:^(BOOL finished) {
        [_previewView removeFromSuperview];
    }];
}

- (void)longPresssBigViewCallback:(MMScrollView *)scrollView
{
    
}

@end

#pragma mark - ------------------ 单个小图显示视图 ------------------
@implementation MMImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.clipsToBounds  = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCallback:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)singleTapGestureCallback:(UIGestureRecognizer *)gesture
{
    if (self.tapSmallView) {
        self.tapSmallView(self);
    }
}

@end
