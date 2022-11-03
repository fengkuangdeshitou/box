//
//  YHSegmentView.m
//  WorkBench
//
//  Created by wanyehua on 2017/10/26.
//  Copyright © 2017年 com.bonc. All rights reserved.
//

#import "YHSegmentView.h"
#import "YHSegmentViewConstant.h"
#import "Masonry.h"

@interface YHSegmentView() <UIScrollViewDelegate>
/** 控制器数组 */
@property (nonatomic, strong) NSArray *viewControllersArr;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;
/** segmentView的Size的大小 */
@property (nonatomic, assign) CGSize size;
/** 按钮title到边的间距 */
@property (nonatomic, assign) CGFloat buttonSpace;
/** 按钮宽度（用于SegmentStyle = YHSegementStyleSpace） */
@property (nonatomic, assign) CGFloat button_W;
/** 存放按钮的宽度 */
@property (nonatomic, strong) NSMutableArray *widthBtnArr;
/** 指示杆 */
@property (nonatomic, strong) UIView *indicateView;
/** 当前被选中的按钮 */
@property (nonatomic, strong) UIButton *selectedButton;
/** 父控制器 */
@property (nonatomic, weak) UIViewController *parentViewController;

@property (nonatomic, assign) CGFloat ScrollView_Y;

@end

static CGFloat Font_Default_size = 0;
static CGFloat Font_Selected_size = 0;
/**<< 默认字体大小 <<*/
#define YH_Font_Default [UIFont systemFontOfSize:Font_Default_size]
/**<< 选中后大小 <<*/
#define YH_Font_Selected [UIFont systemFontOfSize:Font_Selected_size weight:UIFontWeightMedium]
/**<< 宽度 <<*/
#define kScreen_width   [[UIScreen mainScreen] bounds].size.width
/**<< 高度 <<*/
#define kScreen_height  [[UIScreen mainScreen] bounds].size.height

@implementation YHSegmentView{
    yh_indexBlock _yh_resultBlock;
}

# pragma mark -- lazy

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, YH_SegmentViewHeight, _size.width, 0)];
        //选择器下方灰线
//        _bottomLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //设置为白色
        _bottomLineView.backgroundColor = [UIColor whiteColor];
        _ScrollView_Y = YH_SegmentViewHeight;
    }
    return _bottomLineView;
}

- (NSMutableArray *)widthBtnArr {
    if (!_widthBtnArr) {
        _widthBtnArr = [NSMutableArray array];
    }
    return _widthBtnArr;
}

- (UIScrollView *)segmentTitleView {
    if (!_segmentTitleView) {
//        _segmentTitleView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreen_width*0.24, 0, _size.width-(kScreen_width*0.24*2), YH_SegmentViewHeight)];
        _segmentTitleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _size.width, YH_SegmentViewHeight)];
        _segmentTitleView.backgroundColor = YH_SegmentBgColor;
        _segmentTitleView.showsHorizontalScrollIndicator = NO;
        _segmentTitleView.showsVerticalScrollIndicator = NO;
//        if (_titleArr.count<3) {
//            self.button_W = (kScreen_width/self.titleArr.count)-100;
//        }else{
//            self.button_W = (kScreen_width/self.titleArr.count)-50;
//        }
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _segmentTitleView.height - 1, _segmentTitleView.width, 1)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_segmentTitleView addSubview:lineView];
        self.spaceView = lineView;
    }
    return _segmentTitleView;
}

- (UIScrollView *)segmentContentView {
    if (!_segmentContentView) {
        _segmentContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _ScrollView_Y, _size.width, _size.height - _ScrollView_Y)];
        NSLog(@"ScrollViewVC_HH:%f",_size.height - _ScrollView_Y);
        _segmentContentView.delegate = self;
        _segmentContentView.showsHorizontalScrollIndicator = NO;
        _segmentContentView.pagingEnabled = YES;
        _segmentContentView.bounces = NO;
        [self addSubview:_segmentContentView];
        
        // 设置segmentScrollView的尺寸
        _segmentContentView.contentSize = CGSizeMake(_size.width * self.viewControllersArr.count, 0);
       // for (int i=0; i<self.viewControllersArr.count; i++) {
            // 默认加载第一个控制器
            UIViewController *viewController = self.viewControllersArr[0];
            viewController.view.frame = CGRectMake(_size.width * 0, 0, _size.width, _size.height-_ScrollView_Y);
            [_parentViewController addChildViewController:viewController];
            [viewController didMoveToParentViewController:_parentViewController];
            [_segmentContentView addSubview:viewController.view];
        }
   // }
    return _segmentContentView;
}

- (UIView *)indicateView {
    if (!_indicateView) {
        _indicateView = [[UIView alloc] init];
        _indicateView.backgroundColor = [UIColor colorWithHexString:@"#FF8A1C"];
        _indicateView.layer.cornerRadius = YH_IndicateHeight / 2;
        _indicateView.layer.masksToBounds = YES;
    }
    return _indicateView;
}

#pragma mark -- initVC

- (instancetype)initWithFrame:(CGRect)frame ViewControllersArr:(NSArray *)viewControllersArr TitleArr:(NSArray *)titleArr TitleNormalSize:(CGFloat)titleNormalSize TitleSelectedSize:(CGFloat)titleSelectedSize SegmentStyle:(YHSegementStyle)style ParentViewController:(UIViewController *)parentViewController ReturnIndexBlock:(yh_indexBlock)indexBlock {
    if (self = [super initWithFrame:frame]) {
        _viewControllersArr = viewControllersArr;
        _titleArr = titleArr;
        _size = frame.size;
        Font_Default_size = titleNormalSize;
        Font_Selected_size = titleSelectedSize;
        _buttonSpace = [self calculateSpace];
        _yh_segmentBtnSpace = 40;
        _parentViewController = parentViewController;
        [self loadSegmentTitleViewWithSegmentStyle:style];
        [self addSubview:self.segmentContentView];
        _yh_resultBlock = indexBlock;
    }
    return self;
}

- (CGFloat)calculateSpace
{
    CGFloat space = 0.f;
    CGFloat totalWidth = 0.f;
    
    for (NSString *title in _titleArr)
    {
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : YH_Font_Selected}];
//        CGFloat width = 50;
//        if (titleSize.width > 50)
//        {
//            width = titleSize.width;
//        }
        totalWidth += titleSize.width;
    }
    
    space = (_size.width - totalWidth - (_titleArr.count - 1) * 20) / 2;
    if (space > YH_MinItemSpace / 2) {
        return space;
    } else {
        return YH_MinItemSpace / 2;
    }
}

- (void)loadSegmentTitleViewWithSegmentStyle:(YHSegementStyle)style {
    [self addSubview:self.segmentTitleView];
    [self addSubview:self.bottomLineView];
    
    NSString *title;
    NSMutableArray *mutBtnArr = [NSMutableArray array];
    if (style == YHSegementStyleIndicate)
    {
        for (int i = 0; i < _titleArr.count; i++)
        {
           title = _titleArr[i];
           CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: YH_Font_Selected}];
            CGFloat width = kScreenW / _titleArr.count;
//            if (titleSize.width > 50)
//            {
//                CGFloat width = titleSize.width;
//            }
//            if (mutBtnArr.count > 0)
//            {
//                UIButton * addButton = mutBtnArr[i - 1];
//                width = CGRectGetMaxX(addButton.frame) + 20;
//            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(width * i, 0, width, YH_SegmentViewHeight);
            [button setTag:i];
            button.titleLabel.font = YH_Font_Selected;
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:YH_NormalColor forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"#FF8A1C"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentTitleView addSubview:button];
            [mutBtnArr addObject:button];
            
            [self.widthBtnArr addObject:[NSNumber numberWithDouble:CGRectGetWidth(button.frame)]];
            
            if (i == 0) {
                button.selected = YES;
                self.selectedButton = button;
                self.indicateView.frame = CGRectMake(button.center.x - titleSize.width / 2, YH_SegmentViewHeight - YH_IndicateHeight, titleSize.width, YH_IndicateHeight);
                [_segmentTitleView insertSubview:_indicateView belowSubview:button];
            }else {
                button.titleLabel.font = YH_Font_Default;
            }
        }
       
    }else {
        _segmentTitleView.backgroundColor = [UIColor whiteColor];
        if(_titleArr.count %2 == 1){
            //基数排列
            NSInteger midindex = (_titleArr.count+1)/2 - 1;
            UIButton *midButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            [midButton setTag:midindex];
            title = _titleArr[midindex];
            [midButton setTitle:title forState:UIControlStateNormal];
            midButton.titleLabel.font = YH_Font_Default;
            [midButton setTitleColor:YH_NormalColor forState:UIControlStateNormal];
            [midButton setTitleColor:YH_SegmentTintColor forState:UIControlStateSelected];
            [midButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentTitleView addSubview:midButton];
            [midButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(YH_SegmentViewHeight));
                make.centerX.equalTo(_segmentTitleView.mas_centerX);
                make.centerY.equalTo(_segmentTitleView.mas_centerY);
            }];
            [mutBtnArr addObject:midButton];
            UIButton *lastLeftBtn;
            UIButton *lastRightBtn;
            for (NSInteger i=midindex-1,j=midindex+1; i>=0 && j<_titleArr.count; i--,j++) {
                UIButton *leftButton =  [UIButton buttonWithType:UIButtonTypeCustom];
                UIButton *rightButton =  [UIButton buttonWithType:UIButtonTypeCustom];
                NSString *leftTitle = _titleArr[i];
                NSString *rightTitle = _titleArr[j];
                [leftButton setTag:i];
                [leftButton setTitle:leftTitle forState:UIControlStateNormal];
                leftButton.titleLabel.font = YH_Font_Default;
                [leftButton setTitleColor:YH_NormalColor forState:UIControlStateNormal];
                [leftButton setTitleColor:YH_SegmentTintColor forState:UIControlStateSelected];
                [leftButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
                [_segmentTitleView addSubview:leftButton];
                
                [rightButton setTag:j];
                [rightButton setTitle:rightTitle forState:UIControlStateNormal];
                rightButton.titleLabel.font = YH_Font_Default;
                [rightButton setTitleColor:YH_NormalColor forState:UIControlStateNormal];
                [rightButton setTitleColor:YH_SegmentTintColor forState:UIControlStateSelected];
                [rightButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
                [_segmentTitleView addSubview:rightButton];
                
                if(lastLeftBtn == nil){
                    lastLeftBtn = midButton;
                }
                if(lastRightBtn == nil){
                    lastRightBtn = midButton;
                }
                
                [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(lastLeftBtn.mas_left).offset(-20 );
                    make.centerY.mas_equalTo(lastLeftBtn.mas_centerY);
                    make.height.equalTo(@(YH_SegmentViewHeight));
                    make.width.mas_equalTo(lastLeftBtn.mas_width);
                }];
                [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lastRightBtn.mas_right).offset(20);
                    make.centerY.mas_equalTo(lastRightBtn.mas_centerY);
                    make.height.equalTo(@(YH_SegmentViewHeight));
                    make.width.mas_equalTo(lastRightBtn.mas_width);
                }];

                lastLeftBtn = leftButton;
                lastRightBtn = rightButton;
                
                [mutBtnArr addObject:leftButton];
                [mutBtnArr addObject:rightButton];
            }
        }
        else if (_titleArr.count %2 == 0){
            //偶数排列
            NSInteger midone = _titleArr.count/2 -1;
            NSInteger midtwo = midone +1;
            
            NSString *midoneTilte = _titleArr[midone];
            NSString *midtwoTitle = _titleArr[midtwo];
            
            UIButton *midoneButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            UIButton *midtwoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [midoneButton setTag:midone];
            [midoneButton setTitle:midoneTilte forState:UIControlStateNormal];
            midoneButton.titleLabel.font = YH_Font_Default;
            [midoneButton setTitleColor:YH_NormalColor forState:UIControlStateNormal];
            [midoneButton setTitleColor:YH_SegmentTintColor forState:UIControlStateSelected];
            [midoneButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentTitleView addSubview:midoneButton];
            [midoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_segmentTitleView.mas_centerX).offset(-self.yh_segmentBtnSpace / 2);
                make.height.equalTo(@(YH_SegmentViewHeight));
                make.centerY.mas_equalTo(_segmentTitleView.mas_centerY);
            }];
            
            [midtwoButton setTag:midtwo];
            [midtwoButton setTitle:midtwoTitle forState:UIControlStateNormal];
            midtwoButton.titleLabel.font = YH_Font_Default;
            [midtwoButton setTitleColor:YH_NormalColor forState:UIControlStateNormal];
            [midtwoButton setTitleColor:YH_SegmentTintColor forState:UIControlStateSelected];
            [midtwoButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentTitleView addSubview:midtwoButton];
            [midtwoButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_segmentTitleView.mas_centerX).offset(self.yh_segmentBtnSpace / 2);
                make.height.equalTo(@(YH_SegmentViewHeight));
                make.centerY.mas_equalTo(_segmentTitleView.mas_centerY);
            }];
            
            [mutBtnArr addObject:midoneButton];
            [mutBtnArr addObject:midtwoButton];
            UIButton *lastLeftBtn = midoneButton;
            UIButton *lastRightBtn = midtwoButton;
            for (NSInteger i=midone-1,j=midtwo+1; i>=0 && j<_titleArr.count; i--,j++) {
                
                UIButton *leftButton =  [UIButton buttonWithType:UIButtonTypeCustom];
                UIButton *rightButton =  [UIButton buttonWithType:UIButtonTypeCustom];
                NSString *leftTitle = _titleArr[i];
                NSString *rightTitle = _titleArr[j];
                [leftButton setTag:i];
                [leftButton setTitle:leftTitle forState:UIControlStateNormal];
                leftButton.titleLabel.font = YH_Font_Default;
                [leftButton setTitleColor:YH_NormalColor forState:UIControlStateNormal];
                [leftButton setTitleColor:YH_SegmentTintColor forState:UIControlStateSelected];
                [leftButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
                [_segmentTitleView addSubview:leftButton];
                
                [rightButton setTag:j];
                [rightButton setTitle:rightTitle forState:UIControlStateNormal];
                rightButton.titleLabel.font = YH_Font_Default;
                [rightButton setTitleColor:YH_NormalColor forState:UIControlStateNormal];
                [rightButton setTitleColor:YH_SegmentTintColor forState:UIControlStateSelected];
                [rightButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
                [_segmentTitleView addSubview:rightButton];
                
                [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(lastLeftBtn.mas_left).offset(-self.yh_segmentBtnSpace);
                    make.centerY.mas_equalTo(lastLeftBtn.mas_centerY);
                    make.height.equalTo(@(YH_SegmentViewHeight));
                    make.width.mas_equalTo(lastLeftBtn.mas_width);
                }];
                [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(lastRightBtn.mas_right).offset(self.yh_segmentBtnSpace);
                    make.centerY.mas_equalTo(lastRightBtn.mas_centerY);
                    make.height.equalTo(@(YH_SegmentViewHeight));
                    make.width.mas_equalTo(lastRightBtn.mas_width);
                }];
                
                lastLeftBtn = leftButton;
                lastRightBtn = rightButton;
                
                [mutBtnArr addObject:leftButton];
                [mutBtnArr addObject:rightButton];
                
            }
        }
    }
   NSArray *sortedArr = [mutBtnArr sortedArrayUsingComparator:^NSComparisonResult(UIButton *obj1, UIButton * obj2) {
        NSString *tag1 = [NSString stringWithFormat:@"%lu",obj1.tag];
        NSString *tag2 = [NSString stringWithFormat:@"%lu",obj2.tag];
        return [tag1 compare:tag2];
    }];
    self.BtnArr = [sortedArr copy];
}

- (CGFloat)widthAtIndex:(NSInteger)index {
    if (index < 0 || index > _titleArr.count - 1) {
        return .0;
    }
    return [[_widthBtnArr objectAtIndex:index] doubleValue];
}


- (void)didClickButton:(UIButton *)button {
    if (button != _selectedButton) {
        MYLog(@"%f------%f", Font_Default_size, Font_Selected_size);
        button.titleLabel.font = YH_Font_Selected;
        _selectedButton.titleLabel.font = YH_Font_Default;
        button.selected = YES;
        _selectedButton.selected = NO;
        self.selectedButton = button;
        [self scrollIndicateView];
        //禁止按钮滑动
//        [self scrollSegementView];
    }
    // 点击第几个标题加载第几个控制器
    [self loadOtherVCWith:_selectedButton.tag];
    
    if (_yh_resultBlock) {
        _yh_resultBlock(_selectedButton.tag);
       
    }
    
}

- (void)loadOtherVCWith:(NSInteger)tag {

    UIViewController *viewController = self.viewControllersArr[tag];
//    viewController.view.frame = CGRectMake(_size.width * tag, 0, _size.width, _size.height-YH_SegmentViewHeight);
    [viewController.view setFrame:CGRectMake(_size.width * tag, 0, _size.width, _size.height-_ScrollView_Y)];
    [_parentViewController addChildViewController:viewController];
    [viewController didMoveToParentViewController:_parentViewController];
    [_segmentContentView addSubview:viewController.view];
}

#pragma mark --  属性

- (void)setYh_bgColor:(UIColor *)yh_bgColor {
    _yh_bgColor = yh_bgColor;
    _segmentTitleView.backgroundColor = _yh_bgColor;
}

- (void)setYh_titleNormalColor:(UIColor *)yh_titleNormalColor {
    _yh_titleNormalColor = yh_titleNormalColor;
    for (UIButton *titleBtn in self.BtnArr) {
        [titleBtn setTitleColor:yh_titleNormalColor forState:UIControlStateNormal];
        
    }
}

- (void)setYh_titleSelectedColor:(UIColor *)yh_titleSelectedColor {
    _yh_titleSelectedColor = yh_titleSelectedColor;
    for (UIButton *titleBtn in self.BtnArr) {
        [titleBtn setTitleColor:yh_titleSelectedColor forState:UIControlStateSelected];
    }
    if (!_yh_defaultSelectIndex) {
         [self didClickButton:self.BtnArr.firstObject];
    }
   
}

- (void)setYh_segmentTintColor:(UIColor *)yh_segmentTintColor {
    _yh_segmentTintColor = yh_segmentTintColor;
    _indicateView.backgroundColor =yh_segmentTintColor ;
}

- (void)setYh_defaultSelectIndex:(NSInteger)yh_defaultSelectIndex {
    _yh_defaultSelectIndex = yh_defaultSelectIndex;
    for (UIView *view in _segmentTitleView.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag == yh_defaultSelectIndex) {
            UIButton *button = (UIButton *)view;
            [self didClickButton:button];
        }
    }
}

- (void)setYh_segmentIndicateHeight:(CGFloat)yh_segmentIndicateHeight
{
    _yh_segmentIndicateHeight = yh_segmentIndicateHeight;
    
    self.indicateView.height = yh_segmentIndicateHeight;
}

- (void)setYh_segmentIndicateWidth:(CGFloat)yh_segmentIndicateWidth
{
    _yh_segmentIndicateWidth = yh_segmentIndicateWidth;
    
    self.indicateView.width = yh_segmentIndicateWidth;
    self.indicateView.ly_centerX = self.selectedButton.center.x;
}

- (void)setYh_segmentIndicateBottom:(CGFloat)yh_segmentIndicateBottom
{
    _yh_segmentIndicateBottom = yh_segmentIndicateBottom;
    
    self.indicateView.y = _segmentTitleView.height - yh_segmentIndicateBottom - self.indicateView.height;
}

/**
 根据下标更换segment标题名称
 */
- (void)changeTitleWithIndex:(NSInteger)index title:(NSString *)title {
    if (index < self.BtnArr.count) {
        UIButton *titleBtn = self.BtnArr[index];
        [titleBtn setTitle:title forState:UIControlStateNormal];
    }
}

/**
 根据选中的按钮滑动指示杆
 */
- (void)scrollIndicateView {
    NSInteger index = [self selectedAtIndex];
    CGSize titleSize = [_selectedButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : YH_Font_Selected}];
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:YH_Duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (weakSelf.yh_indicateStyle == YHSegementIndicateStyleDefault) {
            weakSelf.indicateView.width = titleSize.width;
            weakSelf.indicateView.ly_centerX = _selectedButton.center.x;
        }
        else if (weakSelf.yh_indicateStyle == YHSegementIndicateStyleDefine)
        {
            weakSelf.indicateView.width = self.yh_segmentIndicateWidth;
            weakSelf.indicateView.ly_centerX = _selectedButton.center.x;
        }
        else {
            weakSelf.indicateView.frame = CGRectMake(CGRectGetMinX(weakSelf.selectedButton.frame), CGRectGetMinY(weakSelf.indicateView.frame), [self widthAtIndex:index], YH_IndicateHeight);
        }
        
        [weakSelf.segmentContentView setContentOffset:CGPointMake(index * weakSelf.size.width, 0)];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 根据选中调整segementView的offset
 */
- (void)scrollSegementView {
    CGFloat selectedWidth = _selectedButton.frame.size.width;
    CGFloat offsetX = (_size.width - selectedWidth) / 2;
    
    if (_selectedButton.frame.origin.x <= _size.width / 2) {
        [_segmentTitleView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else if (CGRectGetMaxX(_selectedButton.frame) >= (_segmentTitleView.contentSize.width - _size.width / 2)) {
        [_segmentTitleView setContentOffset:CGPointMake(_segmentTitleView.contentSize.width - _size.width, 0) animated:YES];
    } else {
        [_segmentTitleView setContentOffset:CGPointMake(CGRectGetMinX(_selectedButton.frame) - offsetX, 0) animated:YES];
    }
}

#pragma mark -- index

- (NSInteger)selectedAtIndex {
    return _selectedButton.tag;
}


- (void)setSelectedItemAtIndex:(NSInteger)index {
    for (UIView *view in _segmentTitleView.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag == index) {
            UIButton *button = (UIButton *)view;
            [self didClickButton:button];
        }
    }
}

#pragma mark -- scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = round(scrollView.contentOffset.x / _size.width);
    if (self.yh_defaultSelectIndex != index)
    {
        self.yh_defaultSelectIndex = index;
    }
   // [self setSelectedItemAtIndex:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    self.indicateView.center = CGPointMake(_selectedButton.center.x, YH_SegmentViewHeight - YH_IndicateHeight / 2);
}

- (void)setYh_indicateStyle:(YHSegementIndicateStyle)yh_indicateStyle {
    _yh_indicateStyle = yh_indicateStyle;
    if (yh_indicateStyle == YHSegementIndicateStyleDefault) {
        
    }
    else if (yh_indicateStyle == YHSegementIndicateStyleDefine)
    {
        _indicateView.frame = CGRectMake((_selectedButton.ly_centerX - self.yh_segmentIndicateWidth) / 2, YH_SegmentViewHeight - YH_IndicateHeight, self.yh_segmentIndicateWidth, YH_IndicateHeight);
    }
    else
    {
         _indicateView.frame = CGRectMake(_selectedButton.frame.origin.x, YH_SegmentViewHeight - YH_IndicateHeight, [self widthAtIndex:0], YH_IndicateHeight);
    }
}

@end
