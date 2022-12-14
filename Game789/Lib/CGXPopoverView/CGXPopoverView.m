//
//  CGXPopoverView.h
//  CGXPopoverVIew
//
//  Created by CGX on 2018/6/6.
//  Copyright © 2018年 CGX. All rights reserved.
//

#import "CGXPopoverView.h"
#import "CGXPopovewCell.h"

static CGFloat const kPopoverViewMargin = 8.f;        ///< 边距
static CGFloat const kCGXPopovewCellHeight = 50.f;   ///< cell指定高度
static CGFloat const kPopoverViewArrowHeight = 8.f;  ///< 箭头高度

static NSString *CellReuseIdentifierCGXPopovew = @"CGXPopovewCell";

float PopoverViewDegreesToRadians(float angle)
{
    return angle*M_PI/180;
}



@interface CGXPopoverView () <UITableViewDelegate, UITableViewDataSource>

#pragma mark - UI
@property (nonatomic, weak) UIWindow *keyWindow;                ///< 当前窗口
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView;                ///< 遮罩层
@property (nonatomic, weak) CAShapeLayer *borderLayer;          ///< 边框Layer
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture; ///< 点击背景阴影的手势

#pragma mark - Data
@property (nonatomic, assign) CGFloat windowWidth;   ///< 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight;  ///< 窗口高度
@property (nonatomic, assign) BOOL isUpward;         ///< 箭头指向, YES为向上, 反之为向下, 默认为YES.

@property (nonatomic, copy) CGXPopoverViewSelectItemBlock selectItemBlock;
@end

@implementation CGXPopoverView

- (instancetype)initWithFrame:(CGRect)frame WithManager:(CGXPopoverManager *)manager
{
    self = [super initWithFrame:frame];
    if (self) {
        self.manager = manager;
         [self initializeData];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeData];
    }
    return self;
}

- (void)initializeData
{
    // data
    _isUpward = YES;
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    
    // shadeView
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_shadeView addGestureRecognizer:tapGesture];
    _tapGesture = tapGesture;
    
    
    // current view
    if (self.manager.style == CGXPopoverManagerItemDefault) {
        self.backgroundColor = [UIColor whiteColor];
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.tableView.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.00];
        self.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.00];
    }
    
    _tapGesture.enabled = self.manager.hideAfterTouchOutside;
    self.tableView.separatorColor = [CGXPopovewCell bottomLineColorForStyle:self.manager.style];
    
    _shadeView.backgroundColor = self.manager.showShade ? [UIColor colorWithWhite:0.f alpha:0.18f] : [UIColor clearColor];
    if (_borderLayer) {
        _borderLayer.strokeColor = self.manager.showShade ? [UIColor clearColor].CGColor : self.tableView.separatorColor.CGColor;
    }
    [self.tableView reloadData];
}
- (void)setManager:(CGXPopoverManager *)manager
{
    _manager = manager;
    [self.tableView reloadData];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tableView.frame = CGRectMake(0, _isUpward ? kPopoverViewArrowHeight : 0,
                                  CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kPopoverViewArrowHeight);
}

- (UITableView *)tableView
{
    if (!_tableView) {
        // tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[CGXPopovewCell class] forCellReuseIdentifier:CellReuseIdentifierCGXPopovew];
        [self addSubview:_tableView];
    }
    return _tableView;
}
/**
 显示弹窗指向某个点
 */
- (void)showToPoint:(CGPoint)toPoint
{
    // 截取弹窗时相关数据
    CGFloat arrowWidth = self.manager.cornerRadius;
    CGFloat cornerRadius = self.manager.cornerRadius;
    CGFloat arrowCornerRadius = 2.5f;
    CGFloat arrowBottomCornerRadius = 4.f;
    
    // 如果是菱角箭头的话, 箭头宽度需要小点.
    if (self.manager.arrowStyle == CGXPopoverManagerArrowStyleTriangle) {
        arrowWidth = 14.0;
    }
    
    // 如果箭头指向的点过于偏左或者过于偏右则需要重新调整箭头 x 轴的坐标
    CGFloat minHorizontalEdge = kPopoverViewMargin + cornerRadius + arrowWidth/2 + 2;
    if (toPoint.x < minHorizontalEdge) {
        toPoint.x = minHorizontalEdge;
    }
    if (_windowWidth - toPoint.x < minHorizontalEdge) {
        toPoint.x = _windowWidth - minHorizontalEdge;
    }
    
    // 遮罩层
    _shadeView.alpha = 0.f;
    [_keyWindow addSubview:_shadeView];
    
    // 刷新数据以获取具体的ContentSize
    [_tableView reloadData];
    // 根据刷新后的ContentSize和箭头指向方向来设置当前视图的frame
    CGFloat currentW = [self calculateMaxWidth]; // 宽度通过计算获取最大值
    CGFloat currentH = _tableView.contentSize.height;
    if (self.manager.popoverViewWidth) {
        currentW = self.manager.popoverViewWidth;
    }
    
    // 如果 actions 为空则使用默认的宽高
    //    if (_actions.count == 0) {
    //        currentW = 150.0;
    //        currentH = 20.0;
    //    }
    if (self.manager.modleArray.count == 0) {
        currentW = 150.0;
        currentH = 20.0;
    }
    
    // 箭头高度
    currentH += kPopoverViewArrowHeight;
    
    // 限制最高高度, 免得选项太多时超出屏幕
    CGFloat maxHeight = _isUpward ? (_windowHeight - toPoint.y - kPopoverViewMargin) : (toPoint.y - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    if (currentH > maxHeight) { // 如果弹窗高度大于最大高度的话则限制弹窗高度等于最大高度并允许tableView滑动.
        currentH = maxHeight;
        _tableView.scrollEnabled = YES;
        if (!_isUpward) { // 箭头指向下则移动到最后一行
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.manager.modleArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    CGFloat currentX = toPoint.x - currentW/2, currentY = toPoint.y;
    // x: 窗口靠左
    if (toPoint.x <= currentW/2 + kPopoverViewMargin) {
        currentX = kPopoverViewMargin;
    }
    // x: 窗口靠右
    if (_windowWidth - toPoint.x <= currentW/2 + kPopoverViewMargin) {
        currentX = _windowWidth - kPopoverViewMargin - currentW;
    }
    // y: 箭头向下
    if (!_isUpward) {
        currentY = toPoint.y - currentH;
    }
    
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    // 截取箭头
    CGPoint arrowPoint = CGPointMake(toPoint.x - CGRectGetMinX(self.frame), _isUpward ? 0 : currentH); // 箭头顶点在当前视图的坐标
    CGFloat maskTop = _isUpward ? kPopoverViewArrowHeight : 0; // 顶部Y值
    CGFloat maskBottom = _isUpward ? currentH : currentH - kPopoverViewArrowHeight; // 底部Y值
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    // 左上圆角
    [maskPath moveToPoint:CGPointMake(0, cornerRadius + maskTop)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius + maskTop)
                        radius:cornerRadius
                    startAngle:PopoverViewDegreesToRadians(180)
                      endAngle:PopoverViewDegreesToRadians(270)
                     clockwise:YES];
    // 箭头向上时的箭头位置
    if (_isUpward) {
        
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, kPopoverViewArrowHeight)];
        // 菱角箭头
        if (self.manager.arrowStyle == CGXPopoverManagerArrowStyleTriangle) {
            
            [maskPath addLineToPoint:arrowPoint];
            [maskPath addLineToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, kPopoverViewArrowHeight)];
        }
        else {
            
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, arrowCornerRadius)
                             controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, kPopoverViewArrowHeight)];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, arrowCornerRadius)
                             controlPoint:arrowPoint];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, kPopoverViewArrowHeight)
                             controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, kPopoverViewArrowHeight)];
        }
    }
    // 右上圆角
    [maskPath addLineToPoint:CGPointMake(currentW - cornerRadius, maskTop)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskTop + cornerRadius)
                        radius:cornerRadius
                    startAngle:PopoverViewDegreesToRadians(270)
                      endAngle:PopoverViewDegreesToRadians(0)
                     clockwise:YES];
    // 右下圆角
    [maskPath addLineToPoint:CGPointMake(currentW, maskBottom - cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:PopoverViewDegreesToRadians(0)
                      endAngle:PopoverViewDegreesToRadians(90)
                     clockwise:YES];
    // 箭头向下时的箭头位置
    if (!_isUpward) {
        
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, currentH - kPopoverViewArrowHeight)];
        // 菱角箭头
        if (self.manager.arrowStyle == CGXPopoverManagerArrowStyleTriangle) {
            
            [maskPath addLineToPoint:arrowPoint];
            [maskPath addLineToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, currentH - kPopoverViewArrowHeight)];
        }
        else {
            
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, currentH - arrowCornerRadius)
                             controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, currentH - kPopoverViewArrowHeight)];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, currentH - arrowCornerRadius)
                             controlPoint:arrowPoint];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, currentH - kPopoverViewArrowHeight)
                             controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, currentH - kPopoverViewArrowHeight)];
        }
    }
    // 左下圆角
    [maskPath addLineToPoint:CGPointMake(cornerRadius, maskBottom)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:PopoverViewDegreesToRadians(90)
                      endAngle:PopoverViewDegreesToRadians(180)
                     clockwise:YES];
    [maskPath closePath];
    // 截取圆角和箭头
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    // 边框 (只有在不显示半透明阴影层时才设置边框线条)
    if (!self.manager.showShade) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = self.bounds;
        borderLayer.path = maskPath.CGPath;
        borderLayer.lineWidth = 1;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = [UIColor groupTableViewBackgroundColor].CGColor;
        [self.layer addSublayer:borderLayer];
        _borderLayer = borderLayer;
    }
    
    [_keyWindow addSubview:self];
    
    // 弹出动画
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(arrowPoint.x/currentW, _isUpward ? 0.f : 0.5f);
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    
    if (self.manager.isAnimate) {
        [UIView animateWithDuration:self.manager.timeInterval animations:^{
            self.transform = CGAffineTransformIdentity;
            self.shadeView.alpha = 1.f;
        }];
    } else{
        self.transform = CGAffineTransformIdentity;
        self.shadeView.alpha = 1.f;
    }
    
}

/*! @brief 计算最大宽度 */
- (CGFloat)calculateMaxWidth
{
    CGFloat maxWidth = 0.f, titleLeftEdge = 0.f, imageWidth = 0.f, imageMaxHeight = kCGXPopovewCellHeight - CGXPopovewCellVerticalMargin*2;
    CGSize imageSize = CGSizeZero;
    UIFont *titleFont = [UIFont systemFontOfSize:15];
    
    for (CGXPopoverItem *action in self.manager.modleArray) {
        
        imageWidth = 0.f;
        titleLeftEdge = 0.f;
        
        if (action.image) { // 存在图片则根据图片size和图片最大高度来重新计算图片宽度
            
            titleLeftEdge = CGXPopovewCellTitleLeftEdge; // 有图片时标题才有左边的边距
            imageSize = action.image.size;
            
            if (imageSize.height > imageMaxHeight) {
                
                imageWidth = imageMaxHeight*imageSize.width/imageSize.height;
            }
            else {
                
                imageWidth = imageSize.width;
            }
        }
        
        CGFloat titleWidth;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) { // iOS7及往后版本
            titleWidth = [action.title sizeWithAttributes:@{NSFontAttributeName : titleFont}].width;
        } else { // iOS6
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            titleWidth = [action.title sizeWithFont:titleFont].width;
#pragma GCC diagnostic pop
        }
        
        CGFloat contentWidth = CGXPopovewCellHorizontalMargin*2 + imageWidth + titleLeftEdge + titleWidth;
        if (contentWidth > maxWidth) {
            maxWidth = ceil(contentWidth); // 获取最大宽度时需使用进一取法, 否则Cell中没有图片时会可能导致标题显示不完整.
        }
    }
    
    // 如果最大宽度大于(窗口宽度 - kPopoverViewMargin*2)则限制最大宽度等于(窗口宽度 - kPopoverViewMargin*2)
    if (maxWidth > CGRectGetWidth(_keyWindow.bounds) - kPopoverViewMargin*2) {
        maxWidth = CGRectGetWidth(_keyWindow.bounds) - kPopoverViewMargin*2;
    }
    
    return maxWidth;
}

/**
 点击外部隐藏弹窗
 */
- (void)hide
{
    [self removeViewAnimation];
}


- (void)showToView:(UIView *)pointView
        SelectItem:(CGXPopoverViewSelectItemBlock)selectItem
{
    // 判断 pointView 是偏上还是偏下
    CGRect pointViewRect = [pointView.superview convertRect:pointView.frame toView:_keyWindow];
    CGFloat pointViewUpLength = CGRectGetMinY(pointViewRect);
    CGFloat pointViewDownLength = _windowHeight - CGRectGetMaxY(pointViewRect);
    // 弹窗箭头指向的点
    CGPoint toPoint = CGPointMake(CGRectGetMidX(pointViewRect), 0);
    // 弹窗在 pointView 顶部
    if (pointViewUpLength > pointViewDownLength) {
        toPoint.y = pointViewUpLength - 5;
    }
    // 弹窗在 pointView 底部
    else {
        toPoint.y = CGRectGetMaxY(pointViewRect) + 5;
    }
    
    // 箭头指向方向
    _isUpward = pointViewUpLength <= pointViewDownLength;
    
    [self showToPoint:toPoint];
    
    self.selectItemBlock = selectItem;
}

- (void)showToPoint:(CGPoint)toPoint
         SelectItem:(CGXPopoverViewSelectItemBlock)selectItem
{
    // 计算箭头指向方向
    _isUpward = toPoint.y <= _windowHeight - toPoint.y;
    
    [self showToPoint:toPoint];
    self.selectItemBlock = selectItem;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.manager.modleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCGXPopovewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGXPopovewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifierCGXPopovew forIndexPath:indexPath];
    cell.style = self.manager.style;
    CGXPopoverItem *item = self.manager.modleArray[indexPath.row];
    [cell setAction:item];
    [cell showBottomLine: indexPath.row < self.manager.modleArray.count - 1];
    if ([self.manager.selectIndexPath isEqual:indexPath]) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell.button setTitleColor:self.manager.selectTitleColor forState:UIControlStateNormal];
    } else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CGXPopoverItem *item = self.manager.modleArray[indexPath.row];

    [self removeViewAnimationAtIndexPath:indexPath Item:item IsBlcok:YES];
}

- (void)removeViewAnimation
{
    [self removeViewAnimationAtIndexPath:nil Item:nil IsBlcok:NO];
}
- (void)removeViewAnimationAtIndexPath:(NSIndexPath *)indexPath Item:(CGXPopoverItem *)item IsBlcok:(BOOL)isBlock
{
    if (self.manager.isAnimate) {
        [UIView animateWithDuration:self.manager.timeInterval animations:^{
            self.alpha = 0.f;
            self.shadeView.alpha = 0.f;
            self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        } completion:^(BOOL finished) {
            if (isBlock) {
               self.selectItemBlock(item,indexPath);
            }

            [self.shadeView removeFromSuperview];
            [self removeFromSuperview];
        }];
    } else{
        self.alpha = 0.f;
        self.shadeView.alpha = 0.f;
        if (isBlock) {
            self.selectItemBlock(item,indexPath);
        }
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }
}
@end

