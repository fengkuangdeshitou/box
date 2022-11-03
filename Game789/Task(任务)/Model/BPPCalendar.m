//
//  BPPCalendar.m
//  Animation
//
//  Created by Onway on 2017/4/7.
//  Copyright © 2017年 Onway. All rights reserved.
//

#import "BPPCalendar.h"
#import "BPPCalendarModel.h"
#import "BPPCalendarCell.h"


@interface BPPCalendar () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong)  BPPCalendarModel *calendarModel;
@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, strong) NSArray *dayArray;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) NSMutableDictionary *mutDict;

@end

@implementation BPPCalendar

- (UILabel *)titlelabel {
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 60, 20, 120, 20)];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
        _titlelabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _titlelabel.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
    }
    return _titlelabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        [self initDataSourse];
        [self stepUI];
    }
    return self;
}

- (void)setSignedDateArray:(NSArray *)signedDateArray
{
    _signedDateArray = signedDateArray;
    
    [_calendarCollectView reloadData];
}

//初始化数据
- (void)initDataSourse {
    __weak typeof(self) weakSelf = self;
    _weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
   _calendarModel = [[BPPCalendarModel alloc] init];
    self.calendarModel.block = ^(NSUInteger year, NSUInteger month) {
        weakSelf.titlelabel.text = [NSString stringWithFormat:@"%ld年%ld月",year,month];
    };
    _dayArray = [_calendarModel setDayArr];
    self.index = _calendarModel.index;
    _mutDict = [NSMutableDictionary new];
}

//布局
- (void)stepUI {
    [self addSubview:self.titlelabel];
    CGFloat width = self.bounds.size.width/7.0;
//    UIButton *lastBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 60, 30)];
//    [lastBtn setTitle:@"上一月" forState:UIControlStateNormal];
//    [lastBtn addTarget:self action:@selector(lastMonthClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:lastBtn];
//
//    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80, 20, 60, 30)];
//    [nextBtn setTitle:@"下一月" forState:UIControlStateNormal];
//    [nextBtn addTarget:self action:@selector(nextMonthClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:nextBtn];
    
    for (int i = 0; i < [_weekArray count]; i ++) {
        UIButton *weekBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * width, self.titlelabel.bottom + 25, width, 15)];
        [weekBtn setTitle:_weekArray[i] forState:UIControlStateNormal];
        weekBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [weekBtn setTitleColor:[UIColor colorWithHexString:@"#9A9A9A"] forState:0];
        [self addSubview:weekBtn];
    }
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.minimumLineSpacing = 10;
    flowlayout.minimumInteritemSpacing = 0;
    _calendarCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.titlelabel.bottom + 60, self.bounds.size.width, self.bounds.size.height - width) collectionViewLayout:flowlayout];
    _calendarCollectView.delegate = self;
    _calendarCollectView.dataSource = self;
    [_calendarCollectView registerClass:[BPPCalendarCell class] forCellWithReuseIdentifier:@"cell"];
    _calendarCollectView.backgroundColor = [UIColor whiteColor];
    _calendarCollectView.scrollEnabled = NO;
    self.calendarCollectView.alwaysBounceVertical=YES;
    [self addSubview:_calendarCollectView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dayArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width/7.0, 32);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BPPCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dayArray[indexPath.item];
    if (indexPath.item <= self.index)
    {
        //显示上个月的天数
        if (_calendarModel.lastDayArray.count > 0 && indexPath.item < _calendarModel.lastDayArray.count)
        {
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
            cell.signImageView.hidden = YES;
        }
        else
        {
            cell.signImageView.hidden = NO;
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
            //处理本月已签到和未签到的天数
            NSString * date = self.dayArray[indexPath.item];
            NSString * currentMonth = [NSDate getNowTimeTimestamp:@"yyyy-MM"];
            if (date.integerValue > 9)
            {
                currentMonth = [NSString stringWithFormat:@"%@-%@", currentMonth, date];
            }
            else
            {
                currentMonth = [NSString stringWithFormat:@"%@-0%@", currentMonth, date];
            }
            if ([self.signedDateArray containsObject:currentMonth])
            {
                cell.signImageView.image = MYGetImage(@"task_checked_selected");
            }
            else
            {
                cell.signImageView.image = MYGetImage(@"task_checked_normal");
            }
        }
    }
    else
    {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#1B1B1B"];
        cell.signImageView.hidden = YES;
        //显示下个月的天数
        if (_calendarModel.nextDayArray.count > 0 && indexPath.item > _calendarModel.lastDayArray.count + _calendarModel.currentDayArray.count - 1)
        {
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#9A9A9A"];
        }
    }
    
    return cell;
}

- (void)lastMonthClick {
    [self.mutDict removeAllObjects];
    self.dayArray = [self.calendarModel lastMonthDataArr];
    [self.calendarCollectView reloadData];
}

- (void)nextMonthClick {
    [self.mutDict removeAllObjects];
    self.dayArray = [self.calendarModel nextMonthDataArr];
    [self.calendarCollectView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    BPPCalendarCell *cell = (BPPCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor lightGrayColor];
//    [self.mutDict removeAllObjects];
//    [self.mutDict setValue:@"value" forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
//    [self.calendarCollectView reloadData];
    
    //我将数据分为三部分处理，第一，获取本月的天数范围，第二，获取上个月与本月第一天遗留的天数，第三，获取到本月最后一天yu
}


@end
