//
//  HGMMImageListView.m
//  MomentKit
//
//  Created by LEA on 2017/12/14.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "HGMMImageListView.h"
#import "MMImagePreviewView.h"

#pragma mark - ------------------ 小图List显示视图 ------------------

@interface HGMMImageListView ()

// 图片视图数组
@property (nonatomic, strong) NSMutableArray *imageViewsArray;
// 预览视图
@property (nonatomic, strong) MMImagePreviewView *previewView;
// 图片视图数组
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) UILabel * labelCount;

@end

@implementation HGMMImageListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 小图(九宫格)
        _imageViewsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 9; i++) {
            HGMMImageView *imageView = [[HGMMImageView alloc] initWithFrame:CGRectZero];
            imageView.tag = 1000 + i;
            [imageView setTapSmallView:^(HGMMImageView *imageView){
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

- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

#pragma mark - Setter
- (void)setMomentDic:(NSDictionary *)momentDic
{
    _momentDic = momentDic;
    for (HGMMImageView *imageView in _imageViewsArray) {
        imageView.hidden = YES;
    }
    // 图片区
    NSArray *imageArray = _momentDic[@"imgs"];
    if (imageArray.count == 0) {
        self.size = CGSizeZero;
        return;
    }
    // 更新视图数据
    _previewView.pageNum = imageArray.count;
    _previewView.scrollView.contentSize = CGSizeMake((_previewView.width * imageArray.count), _previewView.height);
    // 添加图片
    HGMMImageView *imageView = nil;
    for (NSInteger i = 0; i < imageArray.count; i++)
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
        
        CGFloat imageX = colNum * (kImageWidth + kImagePadding);
        CGFloat imageY = rowNum * (kImageWidth + kImagePadding);
        CGRect frame = CGRectMake(imageX, imageY, kImageWidth, kImageWidth);
        
        //单张图片需计算实际显示size
//        if (count == 1) {
//            CGSize singleSize = [Utility getSingleSize:CGSizeMake(moment.singleWidth, moment.singleHeight)];
//            frame = CGRectMake(0, 0, singleSize.width, singleSize.height);
//        }
        imageView = [self viewWithTag:1000+i];
        imageView.hidden = NO;
        imageView.frame = frame;
        [imageView sd_setImageWithURL:[NSURL URLWithString:_momentDic[@"imgs"][i][@"medium"]] placeholderImage:MYGetImage(@"game_icon")];
        if (imageArray.count > 3 && i == 2  && !self.isAll)
        {
            self.labelCount.hidden = NO;
            self.labelCount.frame = imageView.bounds;
            self.labelCount.text = [NSString stringWithFormat:@"+%ld", imageArray.count - 3];
            [imageView addSubview:self.labelCount];
        }
        else
        {
            self.labelCount.hidden = YES;
        }
        
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:_momentDic[@"imgs"][i][@"medium"]];
        data.projectiveView = imageView;
        data.allowSaveToPhotoAlbum = NO;
        [self.imageArray addObject:data];
    }
    self.width = kTextWidth;
    self.height = imageView.bottom;
}

#pragma mark - 小图单击
- (void)singleTapSmallViewCallback:(HGMMImageView *)imageView
{
    NSInteger index = imageView.tag-1000;
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = self.imageArray;
    browser.currentPage = index;
    [browser show];
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
@implementation HGMMImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = 8;
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
