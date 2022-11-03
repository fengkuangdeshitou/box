//
//  DetailIntroduceTableViewCell.m
//  Game789
//
//  Created by xinpenghui on 2017/9/12.
//  Copyright © 2017年 xinpenghui. All rights reserved.
//

#import "DetailIntroduceTableViewCell.h"
#import "DetailIntroduceView.h"
#import "macro.h"
#import "UIColor+HexString.h"

#import "GiftListContentView.h"
#import "GameActiveContentView.h"


#import "ChangyanSDK.h"

#import "GiftDetailViewController.h"

@interface DetailIntroduceTableViewCell () <DetailIntroduceViewDelegate,GiftListContentViewDelegate,GameActiveContentViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *chooseImage;
@property (strong, nonatomic) DetailIntroduceView *introduceView;
@property (strong, nonatomic) GiftListContentView *giftListContentView;
@property (strong, nonatomic) DetailIntroduceView *activeIntroduceView;
@property (strong, nonatomic) DetailIntroduceView *activeIntroduceView2;

@property (strong, nonatomic) GameActiveContentView *gameActiview;


@property (assign, nonatomic) float firstViewHeight;
@property (assign, nonatomic) float secondViewHeight;
@property (assign, nonatomic) float thirdViewHeight;
@property (assign, nonatomic) float fourthViewHeight;
@property (assign, nonatomic) float fifthViewHeight;


@property (strong, nonatomic) UIView *kaifuViews;

@property (strong, nonatomic) NSArray *kaifuList;

@property (strong, nonatomic) NSArray *giftList;

@property (strong, nonatomic) NSDictionary *infoDic;

@property (assign, nonatomic) NSInteger recordSelectViewTag;

@end

@implementation DetailIntroduceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.recordSelectViewTag = 101;
    self.firstViewHeight = 90;
    self.secondViewHeight = 0;
    self.thirdViewHeight = 0;
    self.fourthViewHeight = 0;
    self.fifthViewHeight = 0;

    [self addSubview:self.introduceView];
    [self addSubview:self.giftListContentView];
//    [self addSubview:self.activeIntroduceView];
    [self addSubview:self.activeIntroduceView2];

    [self addSubview:self.gameActiview];

    self.introduceView.hidden = NO;
    self.giftListContentView.hidden = YES;
//    self.activeIntroduceView.hidden = YES;
    self.activeIntroduceView2.hidden = YES;
    self.gameActiview.hidden = YES;

    [self resetBtns];

    UIButton *btn = [self viewWithTag:101];
    [btn setTitleColor:[UIColor colorWithHexString:@"#f5842d"] forState:UIControlStateNormal];
    CGFloat x = btn.frame.origin.x;
    CGFloat width = btn.frame.size.width;
    CGRect rect = self.chooseImage.frame;
    self.chooseImage.frame = CGRectMake(x+(width/2)-rect.size.width/2, rect.origin.y, rect.size.width, rect.size.height);

    // Initialization code
}
- (IBAction)buttonPress:(id)sender {
    [self resetBtns];

    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:[UIColor colorWithHexString:@"#f5842d"] forState:UIControlStateNormal];
    CGFloat x = btn.frame.origin.x;
    CGFloat width = btn.frame.size.width;
    CGRect rect = self.chooseImage.frame;
    self.chooseImage.frame = CGRectMake(x+(width/2)-rect.size.width/2, rect.origin.y, rect.size.width, rect.size.height);
    CGRect selectRect;
    self.recordSelectViewTag = btn.tag;
    float defaultHeight = 46;
    if (btn.tag == 101) {
        self.introduceView.hidden = NO;
        self.giftListContentView.hidden = YES;
//        self.activeIntroduceView.hidden = YES;
        self.activeIntroduceView2.hidden = YES;
        self.kaifuViews.hidden = NO;
        self.gameActiview.hidden = YES;
        defaultHeight += 45;
        selectRect = self.introduceView.frame;
    }
    else if (btn.tag == 102) {
        self.introduceView.hidden = YES;
        self.kaifuViews.hidden = YES;
        self.giftListContentView.hidden = YES;
//        self.activeIntroduceView.hidden = YES;
        self.activeIntroduceView2.hidden = NO;
        self.gameActiview.hidden = YES;
        selectRect = self.activeIntroduceView2.frame;
    }
    else if (btn.tag == 103) {
        self.introduceView.hidden = YES;
        self.kaifuViews.hidden = YES;
        self.giftListContentView.hidden = NO;
        self.giftListContentView.frame = CGRectMake(0, self.giftListContentView.frame.origin.y, kScreen_width, [self.giftListContentView getHeight]);
//        self.activeIntroduceView.hidden = YES;
        self.gameActiview.hidden = YES;
        self.activeIntroduceView2.hidden = YES;
        selectRect = self.giftListContentView.frame;
    }
    else if (btn.tag == 104) {
        self.introduceView.hidden = YES;
        self.kaifuViews.hidden = YES;
        self.giftListContentView.hidden = YES;
//        self.activeIntroduceView.hidden = NO;
        self.gameActiview.hidden = NO;
        self.activeIntroduceView2.hidden = YES;
        selectRect = self.gameActiview.frame;
    }

//    [self.delegate changeTabBtn:btn.tag-101 withHeight:defaultHeight + selectRect.size.height];
    [self.delegate changeTabBtn:btn.tag-101 withHeight:selectRect.origin.y + selectRect.size.height];

}

- (void)expandPress:(BOOL)expand withHeight:(float)height {
    NSLog(@"expand press height = %f",height);
    float defaultHeight = 46;
    if (self.kaifuList.count > 0) {
        defaultHeight += 45;
    }

    if (expand) {
        CGSize size = [self.introduceView getLabelSize:self.infoDic[@"game_introduce"]];
        self.introduceView.frame = CGRectMake(0, self.introduceView.frame.origin.y, kScreen_width, height);
    }
    else {
        self.introduceView.frame = CGRectMake(0, self.introduceView.frame.origin.y, kScreen_width, height);
    }
    NSLog(@"hegith info =%f",self.introduceView.frame.size.height);
    self.firstViewHeight = height;
    [self.delegate expandPress:self.introduceView.frame.origin.y+self.introduceView.frame.size.height];

//    [self.delegate expandPress:self.introduceView.frame.size.height];
}
- (void)theCallbackOfClickView:(NSInteger)index {
    [self.delegate DetailIntroduceCallbackOfClickView:index];
}
- (void)resetBtns {
    float width = kScreen_width/4.0;
    for (int i=0; i<4; i++) {
        UIButton *btn = [self viewWithTag:101+i];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(width*i, btn.frame.origin.y, width, btn.frame.size.height);

        CGFloat x = btn.frame.origin.x;
        CGFloat width = btn.frame.size.width;
        CGRect rect = self.chooseImage.frame;
        self.chooseImage.frame = CGRectMake(x+(width/2)-rect.size.width/2, rect.origin.y, rect.size.width, rect.size.height);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetKaiFuView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 46, kScreen_width, 48)];
//    NSInteger count = self.kaifuList.count;
//    float width = kScreen_width/2;
    NSInteger index = self.kaifuList.count;
    if (index > 2) {
        index = 2;
    }
    float width = kScreen_width/index;

    for (NSInteger i=0; i<index; i++) {
        NSDictionary *dic = [self.kaifuList objectAtIndex:i];
        UILabel *serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake((index - 1-i)*width, 0, width, 20)];
        serviceLabel.font = [UIFont systemFontOfSize:12];
        serviceLabel.textColor = [UIColor colorWithHexString:@"#f5842d"];
        serviceLabel.text = dic[@"kaifuname"];
        serviceLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:serviceLabel];

        UIView *sepretor = [[UIView alloc] initWithFrame:CGRectMake(0, 22.5, kScreen_width, 1)];
        sepretor.backgroundColor = [UIColor colorWithHexString:@"#f5842d"];
        [view addSubview:sepretor];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width-15)/2+(index - 1-i)*width, 17, 15, 15)];
        imageView.image = [UIImage imageNamed:@"choose"];
        [view addSubview:imageView];

        NSString *time = [self timeWithTimeIntervalString:dic[@"starttime"]];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((index - 1-i)*width, 28, width, 20)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textColor = [UIColor colorWithHexString:@"#f5842d"];
        timeLabel.text = time;
        [view addSubview:timeLabel];

    }

    [self addSubview:view];
    self.kaifuViews = view;
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];

    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (void)setModelDic:(NSDictionary *)dic {

    self.infoDic = dic;
    self.kaifuList = dic[@"kaifu_info"];
    float defaultHeight = 46;
    if (self.kaifuList.count > 0) {
        [self.kaifuViews removeFromSuperview];
        [self resetKaiFuView];

        defaultHeight += 45;
    }

//    [self addSubview:self.introduceView];
    CGSize size = [self.introduceView getLabelSize:dic[@"game_introduce"]];
    self.introduceView.frame = CGRectMake(0, defaultHeight, kScreen_width, self.firstViewHeight);
    NSLog(@"self.firstheigt=%f",self.firstViewHeight);
    self.kaifuViews.hidden = self.introduceView.hidden;
//    self.introduceView.hidden = self.recordSelectViewTag == 101?0:1;
//    self.introduceView.hidde = 

//    [self addSubview:self.giftListContentView];
//    self.giftListContentView.hidden = YES;
    self.giftList = dic[@"gift_bag_list"];
    [self.giftListContentView setModelArray:self.giftList];
    self.secondViewHeight = [self.giftListContentView getHeight];
    self.giftListContentView.frame = CGRectMake(0, 46, kScreen_width, self.secondViewHeight);
//    self.giftListContentView.hidden = self.recordSelectViewTag == 103?0:1;

//    [self addSubview:self.activeIntroduceView];
    [self.gameActiview setModelArray:dic[@"game_activity"]];

    self.fifthViewHeight = [self.gameActiview getHeight];
    self.gameActiview.frame = CGRectMake(0, 46, kScreen_width, self.fifthViewHeight);
//
//    self.activeIntroduceView.frame = CGRectMake(0, 46, kScreen_width, self.thirdViewHeight);
////    self.activeIntroduceView.hidden = self.recordSelectViewTag == 104?0:1;
//    [self.activeIntroduceView getLabelSize:@""];


//    [self addSubview:self.activeIntroduceView2];
//    self.fourthViewHeight = kScreen_height+80;
    self.fourthViewHeight = 80;

    self.activeIntroduceView2.frame = CGRectMake(0, 46, kScreen_width, self.fourthViewHeight);
//    self.activeIntroduceView2.hidden = self.recordSelectViewTag == 102?0:1;;

    // 默认评论bar 使用默认的UI 获取包括评论和评论列表组件 dic[@"game_id"]

    UIView *defaultBar = [ChangyanSDK getDefaultCommentBar:CGRectMake(0, 0, kScreen_width, 80)
                                            postButtonRect:CGRectMake(10, 40, kScreen_width-20, 30)
                                            listButtonRect:CGRectMake(10, 5, 30, 30)
                                                  topicUrl:@""
                                             topicSourceID:dic[@"game_id"]
                                                   topicID:nil
                                                categoryID:nil
                                                topicTitle:nil
                                                    target:self.currentVC];
    [self.activeIntroduceView2 addSubview:defaultBar];

//    UIViewController *listViewController = [ChangyanSDK getListCommentViewController:@""
//                                                                             topicID:nil
//                                                                       topicSourceID:@"118"
//                                                                          categoryID:nil
//                                                                          topicTitle:nil];
//    listViewController.view.frame = CGRectMake(0, 80, kScreen_width, kScreen_height);
//    [self.activeIntroduceView2 addSubview:listViewController.view];


    [self.activeIntroduceView2 getLabelSize:@""];
    NSLog(@"size info = %f",size.height);
}

- (DetailIntroduceView *)activeIntroduceView2 {
    if (!_activeIntroduceView2) {
        //        _introduceView = [[DetailIntroduceView alloc] initWithFrame:CGRectMake(0, 43, kScreen_width, 200)];
        _activeIntroduceView2 = [self createViews];
        _activeIntroduceView2.delegate = self;
        [_activeIntroduceView2 ifExpendBtnHidden:YES];
    }
    return _activeIntroduceView2;
}

- (DetailIntroduceView *)activeIntroduceView {
    if (!_activeIntroduceView) {
        //        _introduceView = [[DetailIntroduceView alloc] initWithFrame:CGRectMake(0, 43, kScreen_width, 200)];
        _activeIntroduceView = [self createViews];
        _activeIntroduceView.delegate = self;
        [_activeIntroduceView ifExpendBtnHidden:YES];
    }
    return _activeIntroduceView;
}

- (DetailIntroduceView *)createViews {
    DetailIntroduceView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DetailIntroduceView class]) owner:nil options:nil] firstObject];
    return view;
}

- (GameActiveContentView *)gameActiview {
    if (!_gameActiview) {
        //        _introduceView = [[DetailIntroduceView alloc] initWithFrame:CGRectMake(0, 43, kScreen_width, 200)];
        _gameActiview = [self createViewss];
        _gameActiview.delegate = self;
    }
    return _gameActiview;
}

- (GameActiveContentView *)createViewss {
    GameActiveContentView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GameActiveContentView class]) owner:nil options:nil] firstObject];
    return view;
}

- (DetailIntroduceView *)introduceView {
    if (!_introduceView) {
//        _introduceView = [[DetailIntroduceView alloc] initWithFrame:CGRectMake(0, 43, kScreen_width, 200)];
        _introduceView = [self createView];
        _introduceView.delegate = self;
    }
    return _introduceView;
}

- (DetailIntroduceView *)createView {
    DetailIntroduceView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DetailIntroduceView class]) owner:nil options:nil] firstObject];
    return view;
}

- (void)giftListSelectRow:(NSInteger)row {
    NSLog(@"select row = %d",row);
    NSLog(@"select row data = %@",[self.giftList objectAtIndex:row]);
    [self.delegate giftGetPress:row];
}

- (void)giftListSelectViewRow:(NSInteger)row {
    NSLog(@"select row view = %@",[self.giftList objectAtIndex:row]);
    [self.delegate giftViewPress:row];


}
- (GiftListContentView *)giftListContentView {
    if (!_giftListContentView) {
        _giftListContentView = [self createListContentView];
        _giftListContentView.delegate = self;
    }
    return _giftListContentView;
}

- (GiftListContentView *)createListContentView {
    GiftListContentView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GiftListContentView class]) owner:nil options:nil] firstObject];
    return view;
}

@end
