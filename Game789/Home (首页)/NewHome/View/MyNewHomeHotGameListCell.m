//
//  MyNewHomeHotGameListCell.m
//  Game789
//
//  Created by Maiyou on 2020/8/10.
//  Copyright © 2020 yangyong. All rights reserved.
//

#import "MyNewHomeHotGameListCell.h"
#import "HGHotGamesListCell.h"

@implementation MyNewHomeHotGameListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (XHPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[XHPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, 56 + 270, kScreenW, 20);
        _pageControl.delegate = self;
        _pageControl.otherColor = FontColorDE;
        _pageControl.currentColor = MAIN_COLOR;
//        _pageControl.backgroundColor = UIColor.redColor;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (WSLRollView *)pageRollView
{
    if (!_pageRollView)
    {
        WSLRollView * pageRollView = [[WSLRollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
        pageRollView.sourceArray = [NSMutableArray arrayWithArray:self.dataArrSource];
        pageRollView.backgroundColor = [UIColor whiteColor];
        pageRollView.scrollStyle = WSLRollViewScrollStylePage;
        pageRollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        pageRollView.interval = 0;
        pageRollView.loopEnabled = NO;
        pageRollView.delegate = self;
        [pageRollView registerNib:[UINib nibWithNibName:@"HGHotGamesListCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PageRollID"];
        [self.backView addSubview:pageRollView];
        _pageRollView = pageRollView;
    }
    return _pageRollView;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    NSInteger count = 0;
    for (int i = 0; i < dataArray.count; i ++)
    {
        count = dataArray.count / 3;
        NSInteger index = dataArray.count % 3;
        if (index > 0) count = count + 1;
    }
    self.dataArrSource = [NSMutableArray array];
    for (int i = 0; i < count; i ++)
    {
        [self.dataArrSource addObject:@"0"];
    }
    [self.pageRollView reloadData];

    self.pageControl.numberOfPages = self.dataArrSource.count;
}

#pragma mark - WSLRollViewDelegate
//返回itemSize
- (CGSize)rollView:(WSLRollView *)rollView sizeForItemAtIndex:(NSInteger)index{
    
    return CGSizeMake(kScreenW, 270);
}

//间隔
- (CGFloat)spaceOfItemInRollView:(WSLRollView *)rollView
{
    return 15;
}

//内边距
- (UIEdgeInsets)paddingOfRollView:(WSLRollView *)rollView
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//点击事件
- (void)rollView:(WSLRollView *)rollView didSelectItemAtIndex:(NSInteger)index
{
   
}

//返回自定义cell样式page
-(WSLRollViewCell *)rollView:(WSLRollView *)rollView cellForItemAtIndex:(NSInteger)index{
    
    HGHotGamesListCell * cell = (HGHotGamesListCell *)[rollView dequeueReusableCellWithReuseIdentifier:@"PageRollID" forIndex:index];
    NSInteger count = self.dataArray.count / 3;
    NSInteger page = self.dataArray.count % 3;
    NSMutableArray * array = [NSMutableArray array];
    if (index < count)
    {
        [array addObject:self.dataArray[index * 3]];
        [array addObject:self.dataArray[index * 3 + 1]];
        [array addObject:self.dataArray[index * 3 + 2]];
        cell.backView2.hidden = NO;
        cell.backView3.hidden = NO;
    }
    else
    {
        if (page == 1)
        {
            [array addObject:self.dataArray[index * 3]];
            cell.backView2.hidden = YES;
            cell.backView3.hidden = YES;
        }
        else if (page == 2)
        {
            [array addObject:self.dataArray[index * 3]];
            [array addObject:self.dataArray[index * 3 + 1]];
            cell.backView2.hidden = NO;
            cell.backView3.hidden = YES;
        }
    }
    cell.dataArray = array;
    return cell;
}

- (void)rollView:(WSLRollView *_Nullable)rollView didRollItemToIndex:(NSInteger)currentIndex
{
    self.pageControl.currentPage = currentIndex;
}

//- (void)wSLRollViewillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
//{
//    NSInteger currentPage = scrollView.contentOffset.x / self.pageRollView.width;
//    self.pageControl.currentPage = currentPage;
//
//}

@end
