//
//  MemberInterestsAlertView.m
//  Game789
//
//  Created by maiyou on 2021/9/13.
//  Copyright © 2021 yangyong. All rights reserved.
//

#import "MemberInterestsAlertView.h"
#import "MemberInterestsContentView.h"
#import "MemberInterestsModel.h"

@interface MemberInterestsAlertView ()<UIScrollViewDelegate,MemberInterestsContentViewDelegate>

@property(nonatomic,strong)NSMutableArray * itemImageArray;
@property(nonatomic,strong)NSMutableArray * itemLockImageArray;

@property(nonatomic,weak)IBOutlet UIScrollView * itemScrollView;
@property(nonatomic,weak)IBOutlet UIScrollView * scrollView;
@property(nonatomic,weak)IBOutlet UIButton * leftButton;
@property(nonatomic,weak)IBOutlet UIButton * rightButton;

@end

@implementation MemberInterestsAlertView

+ (void)showMemberInterestsAlertViewWithData:(NSDictionary *)data scrollToIndex:(NSInteger)index{
    MemberInterestsAlertView * alertView = [[NSBundle.mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    alertView.frame = UIScreen.mainScreen.bounds;
    
    NSArray * titleArray = @[@"购买相应等级会员后立即等额返还相应平台币\n子爵 返还980平台币\n伯爵 返还2880平台币\n公爵 返还4990平台币\n国王 返还9990平台币\n皇帝 返还99990平台币",
                             @"会员有效期内，个人中心及评论专区享有专属会员标识，彰显您尊贵的身份",
                             @"会员签到可获得的额外奖励",
                             @"会员尊享礼遇，生日当天送您一张无门槛代金券",
                             @"咨询客服快人一步，专享绿色客服通道，快速响应。全程为您贴心跟进事情处理进度，全方位为您服务。",
                             @"平台会不定期配合游戏商发行一些高价值会员礼包，公爵以上的会员可免费领取。会员等级越高，可免费领取的游戏礼包越多。游戏详情页礼包处会标注该礼包的领取权限，您可以前往游戏详情页查看和领取。",
                             @"平台会不定期推出会员专属活动，会员可独享更多福利优惠（具体视活动规则而定），敬请期待。",
                             @"皇帝会员专享购买账号，按照账号销售金额的3%的返还金币"];
    NSArray * descArray = @[@"(1元=10平台币)",
                            @"",
                            @"N代表完成对应任务普通用户所获金币",
                            @"前提是您必须先完成实名认证，系统会根据您身份证上的出生日期作为判断依据，会员有效期内，生日当天系统会自动给您发放生日代金券，届时请前往我的页面代金券处查看。",@"",@"",@"",@""];
    NSArray * objectArray = @[@"子爵/伯爵/公爵/国王/皇帝",
                              @"子爵/伯爵/公爵/国王/皇帝",
                              @"子爵/伯爵/公爵/国王/皇帝",
                              @"子爵/伯爵/公爵/国王/皇帝",
                              @"国王/皇帝",
                              @"公爵/国王/皇帝",
                              @"国王/皇帝",
                              @"皇帝"];
    NSArray * itemTitleArray = @[@"等额返还",@"身份标识",@"金币加成",@"生日礼",@"客服VIP通道",@"特权礼包",@"专属活动",@"账号返还"];
    
    alertView.itemImageArray = [[NSMutableArray alloc] init];
    alertView.itemLockImageArray = [[NSMutableArray alloc] init];
    
    BOOL isVip = [data[@"is_vip"] boolValue];
    int grade_id = [data[@"grade_id"] intValue];
    for (int i=0; i<titleArray.count; i++) {
        if (isVip) {
            if (i<=3) {
                [alertView.itemImageArray addObject:[NSString stringWithFormat:@"gray_active_%d",i]];
                [alertView.itemLockImageArray addObject:[NSString stringWithFormat:@"member_active_%d",i]];
            }else{
                if (grade_id <= 2) {
                    [alertView.itemImageArray addObject:[NSString stringWithFormat:@"gray_normal_%d",i]];
                    [alertView.itemLockImageArray addObject:[NSString stringWithFormat:@"active_lock_%d",i]];
                }else{
                    if (grade_id == 3 && i <= 4) {
                        [alertView.itemImageArray addObject:[NSString stringWithFormat:@"gray_active_%d",i]];
                        [alertView.itemLockImageArray addObject:[NSString stringWithFormat:@"member_active_%d",i]];
                    }else if(grade_id == 4 && i<=6){
                        [alertView.itemImageArray addObject:[NSString stringWithFormat:@"gray_active_%d",i]];
                        [alertView.itemLockImageArray addObject:[NSString stringWithFormat:@"member_active_%d",i]];
                    }else if(grade_id == 5){
                        [alertView.itemImageArray addObject:[NSString stringWithFormat:@"gray_active_%d",i]];
                        [alertView.itemLockImageArray addObject:[NSString stringWithFormat:@"member_active_%d",i]];
                    }else{
                        [alertView.itemImageArray addObject:[NSString stringWithFormat:@"gray_normal_%d",i]];
                        [alertView.itemLockImageArray addObject:[NSString stringWithFormat:@"active_lock_%d",i]];
                    }
                }
            }
        }else{
            [alertView.itemImageArray addObject:[NSString stringWithFormat:@"gray_normal_%d",i]];
            [alertView.itemLockImageArray addObject:[NSString stringWithFormat:@"active_lock_%d",i]];
        }
        
        UIButton * button = [alertView createButtonItemWithFrame:CGRectMake(86*i+ScreenWidth/2-86/2, 0, 86, 70) title:itemTitleArray[i] image:[UIImage imageNamed:alertView.itemImageArray[i]]];
        button.tag = i+10;
        if (i == 0) {
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"member_active_0"] forState:UIControlStateNormal];
        }
        [alertView.itemScrollView addSubview:button];
        
        MemberInterestsModel * model = [[MemberInterestsModel alloc] init];
        model.title = titleArray[i];
        model.desc = descArray[i];
        model.tag = i;
        model.data = data;
        model.object = objectArray[i];
        
        MemberInterestsContentView * view = [[MemberInterestsContentView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60)*i, 0, SCREEN_WIDTH-60, 430)];
        view.model = model;
        view.delegate = alertView;
        [alertView.scrollView addSubview:view];
    }
    alertView.itemScrollView.contentSize = CGSizeMake(86*titleArray.count+ScreenWidth-86, 0);
    alertView.scrollView.contentSize = CGSizeMake((ScreenWidth-60)*titleArray.count, 0);
    [alertView show];
    [alertView.scrollView setContentOffset:CGPointMake((ScreenWidth-60)*index, 0) animated:false];
}

- (void)show{
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    [UIView animateWithDuration:0.1 animations:^{
        
    }];
}

- (IBAction)dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)onDismiss{
    [self dismiss];
}

- (UIButton *)createButtonItemWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    btn.titleLabel.textAlignment = 1;
    [btn addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)itemAction:(UIButton *)btn{
    [self.itemScrollView setContentOffset:CGPointMake((btn.tag-10)*86, 0) animated:YES];
    [self.scrollView setContentOffset:CGPointMake((btn.tag-10)*(ScreenWidth-60), 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        [self.itemScrollView setContentOffset:CGPointMake(scrollView.contentOffset.x*86/(ScreenWidth-60), 0) animated:NO];
        CGFloat currentIndex = self.scrollView.contentOffset.x/(ScreenWidth-60);
        self.leftButton.hidden = currentIndex == 0;
        self.rightButton.hidden = currentIndex == 7;
        
        if (![@[@0,@1,@2,@3,@4,@5,@6,@7] containsObject:[NSNumber numberWithFloat:currentIndex]]) {
            return;
        }
        for (UIButton * btn in self.itemScrollView.subviews) {
            [btn setImage:[UIImage imageNamed:self.itemImageArray[btn.tag-10]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        }
        UIButton * btn =  [self.itemScrollView viewWithTag:currentIndex+10];
//        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"member_active_%.0f",currentIndex]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:self.itemLockImageArray[btn.tag-10]] forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
    }
}

- (IBAction)moveScrollView:(UIButton *)sender{
    NSInteger currentIndex = self.scrollView.contentOffset.x/(ScreenWidth-60);
    if (sender.tag == 100) {
        if (currentIndex > 0) {
            [self.scrollView setContentOffset:CGPointMake((currentIndex-1) * (ScreenWidth-60), 0) animated:YES];
            [self.itemScrollView setContentOffset:CGPointMake(86*(currentIndex-1), 0) animated:YES];
        }
    }else{
        if (currentIndex < 7) {
            [self.scrollView setContentOffset:CGPointMake((currentIndex+1) * (ScreenWidth-60), 0) animated:YES];
            [self.itemScrollView setContentOffset:CGPointMake(86*(currentIndex+1), 0) animated:YES];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
